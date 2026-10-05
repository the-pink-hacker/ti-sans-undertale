import sys
from pathlib import Path
from typing import Optional
from math import sin, tau, ceil

INDENT = "    "

class CValue:
    def eval(self) -> str:
        raise NotImplementedError


class CDefineMacro(CValue):
    name: str
    value: any

    def __init__(self, name: str, value: any):
        self.name = name
        self.value = value

    def eval(self) -> str:
        return f"#define {self.name} {self.value}\n"


class CIncludeMacro(CValue):
    name: str
    dynamic: bool

    def __init__(self, name: str, dynamic: bool = False):
        self.name = name
        self.dynamic = dynamic

    def eval(self) -> str:
        if self.dynamic:
            return f"#include <{self.name}.h>\n"
        else:
            return f"#include \"{self.name}.h\"\n"


class CFormatGap(CValue):
    lines: int

    def __init__(self, lines: int = 1):
        self.lines = lines

    def eval(self) -> str:
        return "\n" * self.lines


class CVariable(CValue):
    name: str
    type_name: str
    array: bool
    array_length: Optional[int | list[int]]
    extern: bool
    const: bool
    value: Optional[any]

    def __init__(
        self,
        name: str,
        type_name: str,
        array: bool = False,
        array_length: Optional[int | list[int]] = None,
        extern: bool = False,
        const: bool = False,
        value: Optional[any] = None,
    ):
        self.name = name
        self.type_name = type_name
        self.array = array
        self.extern = extern
        self.array_length = array_length
        self.const = const
        self.value = value

    def eval(self) -> str:
        out = ""

        if self.extern:
            out += "extern "

        if self.const:
            out += "const "

        out += f"{self.type_name} {self.name}"

        if self.array:
            if self.array_length is None:
                out += "[]"
            elif isinstance(self.array_length, list):
                for length in self.array_length:
                    out += f"[{length}]"
            else:
                out += f"[{self.array_length}]"

        if self.value is not None:
            out += f" = {self.value}"

        out += ";\n"

        return out


class CPragmaOnce(CValue):
    def eval(self) -> str:
        return "#pragma once\n\n"


class CFileAbstract:
    values: dict[str, CValue]
    name: str

    def __init__(self, name: str):
        self.name = name
        self.values = []

    def add_value(self, value: CValue):
        self.values.append(value)

    def add_values(self, values: list[CValue]):
        self.values.extend(values)

    def write_to_path(self, out_path: Path):
        out = ""

        for value in self.values:
            out += value.eval()

        with open(self.get_out_file(out_path), "w") as file:
            file.write(out)

    def get_out_file(self, out_path: Path) -> Path:
        raise NotImplementedError


class CHeader(CFileAbstract):
    def __init__(self, name: str):
        super().__init__(name)
        self.add_value(CPragmaOnce())

    def get_out_file(self, out_path: Path) -> Path:
        return out_path / (self.name + ".h")


class CFile(CFileAbstract):
    def __init__(self, name: str):
        super().__init__(name)
        self.add_values([
            CIncludeMacro(name),
            CFormatGap(),
        ])

    def get_out_file(self, out_path: Path) -> Path:
        return out_path / (self.name + ".c")


def get_out_path(arg: str) -> Path:
    return Path(arg).resolve()

def list_to_c_array(values: list[any], indent: int = 1) -> str:
    out = "{"
    current_indent = INDENT * indent

    last_index = len(values) - 1

    for (i, raw_value) in enumerate(values):
        newline = False

        if isinstance(raw_value, dict):
            newline = True
            out += "\n"
            out += current_indent
            out += dict_to_c_value(raw_value, indent + 1)
        elif isinstance(raw_value, list):
            newline = True
            out += "\n"
            out += current_indent
            out += list_to_c_array(raw_value, indent + 1)
        else:
            out += str(raw_value)

        if i != last_index:
            out += ","
        elif newline:
            out += "\n"

    out += INDENT * (indent - 1)
    out += "}"

    return out

def dict_to_c_value(value: dict[str, dict], indent: int = 1) -> str:
    out = "{\n"

    for (key, raw_value) in value.items():
        value: str

        if isinstance(raw_value, dict):
            value = dict_to_c_value(raw_value, indent + 1)
        elif isinstance(raw_value, list):
            value = list_to_c_array(value, indent + 1)
        else:
            value = str(raw_value)

        out += INDENT * indent
        out += f".{key} = {value},\n"

    out += INDENT * (indent - 1)
    out += "}"

    return out

BONE_WAVE_COUNT = 20

def bone_wave_get_value(i: int) -> int:
    bone_index = i - 1
    theta = (bone_index / float(BONE_WAVE_COUNT)) * tau
    scale = 23.0 / 2.0
    height = round((sin(theta) * scale) + scale)
    return height

def bone_wave(out: Path):
    name = "bone_wave"
    header = CHeader(name)
    file = CFile(name)

    table_name = "SANS_LOOKUP_BONE_RISE_TABLE"
    table_type_name = "uint8_t"

    header.add_values([
        CIncludeMacro("stdint", dynamic = True),
        CFormatGap(),
        CDefineMacro("SANS_LOOKUP_BONE_RISE_COUNT", BONE_WAVE_COUNT),
        CVariable(
            name = table_name,
            type_name = table_type_name,
            array = True,
            array_length = BONE_WAVE_COUNT,
            extern = True,
            const = True,
        ),
    ])

    values = map(bone_wave_get_value, range(BONE_WAVE_COUNT))

    file.add_value(CVariable(
        name = table_name,
        type_name = table_type_name,
        array = True,
        array_length = BONE_WAVE_COUNT,
        value = list_to_c_array(list(values)),
        const = True,
    ))

    header.write_to_path(out)
    file.write_to_path(out)

BLASTER_4A_START_FRAME = 86
BLASTER_4A_END_FRAME = 97
BLASTER_4A_FRAMES = BLASTER_4A_END_FRAME - BLASTER_4A_START_FRAME + 1

def blaster_position(x: int, y: int, rotation_index: int) -> dict:
    return {
        "position": {
            "x": x,
            "y": y,
        },
        "rotation_index": rotation_index
    }

def blaster_4a_get_value(i: int) -> tuple[
    dict[str, any],
    dict[str, any],
    dict[str, any],
    dict[str, any],
]:
    return [
        blaster_position(0, 0, 0),
        blaster_position(60, 0, 0),
        blaster_position(0, 60, 0),
        blaster_position(60, 60, 0),
    ]

def blaster_4a(out: Path):
    name = "blaster_4a"
    header = CHeader(name)
    file = CFile(name)

    table_name = "SANS_LOOKUP_BLASTER_4A_TABLE"
    table_type_name = "sans_blaster_position_t"
    table_array_lengths = [BLASTER_4A_FRAMES, 4]

    header.add_values([
        CIncludeMacro("stdint", dynamic = True),
        CFormatGap(),
        CIncludeMacro("../../blaster"),
        CFormatGap(),
        CDefineMacro("SANS_LOOKUP_BLASTER_4A_FRAMES", BLASTER_4A_FRAMES),
        CVariable(
            name = table_name,
            type_name = table_type_name,
            array = True,
            array_length = table_array_lengths,
            extern = True,
            const = True,
        ),
    ])

    values = map(blaster_4a_get_value, range(BLASTER_4A_FRAMES))

    file.add_value(CVariable(
        name = table_name,
        type_name = table_type_name,
        array = True,
        array_length = table_array_lengths,
        const = True,
        value = list_to_c_array(list(values)),
    ))

    header.write_to_path(out)
    file.write_to_path(out)

def make_out_path(out: Path):
    out.mkdir(parents = True, exist_ok = True)

def main():
    args = sys.argv

    match len(args):
        case 1:
            raise ValueError("No command was provided")
        case 2:
            raise ValueError("No out path was provided")

    command = args[1]

    out = get_out_path(args[2])

    make_out_path(out)

    match command:
        case "bone_wave":
            bone_wave(out)
        case "blaster_4a":
            blaster_4a(out)
        case _:
            raise NotImplementedError(f"Unknown command {command}")

if __name__ == "__main__":
    main()

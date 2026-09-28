import sys
from pathlib import Path
from typing import Optional
from math import sin, tau, ceil

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
    array_length: Optional[int]
    extern: bool
    value: Optional[any]

    def __init__(
        self,
        name: str,
        type_name: str,
        array: bool = False,
        array_length: Optional[int] = None,
        extern: bool = False,
        value: Optional[any] = None,
    ):
        self.name = name
        self.type_name = type_name
        self.array = array
        self.extern = extern
        self.array_length = array_length
        self.value = value

    def eval(self) -> str:
        out = ""

        if self.extern:
            out += "extern "

        out += f"{self.type_name} {self.name}"

        if self.array:
            if self.array_length is None:
                out += "[]"
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
        self.add_value(CIncludeMacro(name))

    def get_out_file(self, out_path: Path) -> Path:
        return out_path / (self.name + ".c")


def get_out_path(arg: str) -> Path:
    return Path(arg).resolve()

def list_to_c_array(values: list[any]) -> str:
    return "{" + ",".join(map(str, values)) + "}"

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
        CDefineMacro("SANS_LOOKUP_BONE_RISE_COUNT", 20),
        CVariable(
            name = table_name,
            type_name = table_type_name,
            array = True,
            array_length = BONE_WAVE_COUNT,
            extern = True,
        ),
    ])

    values = map(bone_wave_get_value, range(BONE_WAVE_COUNT))

    file.add_values([
        CFormatGap(),
        CVariable(
            name = table_name,
            type_name = table_type_name,
            array = True,
            array_length = BONE_WAVE_COUNT,
            value = list_to_c_array(values),
        ),
    ]);

    header.write_to_path(out)
    file.write_to_path(out)

def main():
    args = sys.argv

    match len(args):
        case 1:
            raise ValueError("No command was provided")
        case 2:
            raise ValueError("No out path was provided")

    command = args[1]

    out = get_out_path(args[2]);

    match command:
        case "bone_wave":
            bone_wave(out)
        case _:
            raise NotImplementedError(f"Unknown command {command}")

if __name__ == "__main__":
    main()

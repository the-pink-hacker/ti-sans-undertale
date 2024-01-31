macro libload_header name, version
    db $C0, name, 0, version
end macro

macro libload_func name, offset
    name:
        jp 3 * offset
end macro

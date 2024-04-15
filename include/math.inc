PI := 3.141592653589793238
TAU := 2.0 * PI
TRUE := 1
FALSE := 0

macro factorial: n
    if n
        factorial n - 1
        result = result * (n)
    else
        result = 1
    end if
end macro

; Positive only
macro power: base, exponent
    if exponent
        power base, exponent - 1
        result = base * result
    else
        result = 1
    end if
end macro

; Power series
macro sin: theta, iterations
    if iterations
        sin theta, iterations - 1
        old = result
        power -1.0, (iterations)
        var1 = result
        power theta, 2.0 * (iterations) + 1.0
        var2 = result
        factorial 2.0 * (iterations) + 1.0
        result = old + (var1 * var2 / result)
    else
        result = theta
    end if
end macro

; Power series
macro cos: theta, iterations
    if iterations
        cos theta, iterations - 1
        old = result
        power -1.0, (iterations)
        var1 = result
        power theta, 2.0 * (iterations)
        var2 = result
        factorial 2.0 * (iterations)
        result = old + (var1 * var2 / result)
    else
        result = 1.0
    end if
end macro

; Domain: [-9.9999999999999E128, 9.9999999999999E128]
; I don't think IEEE-754 is as pecise as TI's floating point.
; The limit is probably the assembler and not the calculator.
macro ti_number: number
    if number < 0
        number_abs = -number
        sign = 1 shl 7
    else
        number_abs = number
        sign = 0
    end if
    db sign or 1
    exponent = -127
    exponent_eval = 1.0
    i = 0
    while i < -exponent ; Looses some percision.
                        ; TODO: calculate exponent without really small numbers.
        exponent_eval = exponent_eval / 10.0
        i = i + 1
    end while
    while number_abs / exponent_eval >= 10.0
        exponent = exponent + 1
        exponent_eval = exponent_eval * 10.0
    end while
    db $80 + exponent
    i = 0
    ;display_decimal trunc (number_abs)
    ;display $0A
    ;display_decimal exponent
    ;display $0A, $0A
    while i < 7
        number_first = trunc (number_abs / exponent_eval)
        number_abs = number_abs - (number_first * exponent_eval)
        exponent_eval = exponent_eval / 10.0

        number_second = trunc (number_abs / exponent_eval)
        number_abs = number_abs - (number_second * exponent_eval)
        exponent_eval = exponent_eval / 10.0

        ;display_decimal number_first
        ;display_decimal number_second
        ;display $0A

        db (number_first shl 4) or number_second
        i = i + 1
    end while
end macro

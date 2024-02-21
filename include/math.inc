PI := 3.14159265
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

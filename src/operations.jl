function (+)(a::CN, b::CN)::CN
    return CN(simplify(a.sym + b.sym))
end

function (-)(a::CN)::CN
    return CN(simplify(-a.sym))
end

function (-)(a::CN, b::CN)::CN
    return CN(simplify(a.sym - b.sym))
end

function (*)(a::CN, b::CN)::CN
    return CN(simplify(a.sym * b.sym))
end

function (/)(a::CN, b::CN)::CN
    if iszero(b)
        throw(DomainError(b, "Cannot divide by zero."))
    end
    return CN(simplify(a.sym / b.sym))
end

function inv(a::CN)::CN
    if iszero(a)
        throw(DomainError(a, "Zero is not invertible."))
    end
    return (1 / a)
end

function sqrt(a::CN)::CN
    if a < 0
        throw(DomainError(a, "Cannot take the square root of a negative number."))
    end
    return CN(simplify(sqrt(a.sym)))
end

"""
    sqrtx(a::T) where {T<:Real}

Exact square root. `a` should be an `Integer`, `Rational`, or `ConstructibleNumber`.

## Example
```
julia> 1 + sqrt(3)
2.732050807568877

julia> 1 + sqrtx(3)
1 + sqrt(3)

julia> typeof(ans)
ConstructibleNumbe
```
"""
function sqrtx(a::T)::CN where {T<:Real}
    return sqrt(CN(a))
end

"""
    (^)(x::CN, p::Rational)::CN

Raise a `ConstructibleNumber` to a `Rational` power. 
Note that the denominator of the exponent must be a power of 2. 
"""
function (^)(x::CN, p::Rational)::CN
    top = numerator(p)
    bot = denominator(p)

    if bot == 0
        throw(DomainError(p, "Invalid exponent"))
    end

    if bot == 1
        return x^top
    end

    if !ispow2(bot)
        throw(DomainError(p, "Exponent denominator must be a power of 2"))
    end

    return sqrt(x ^ (2p))
end

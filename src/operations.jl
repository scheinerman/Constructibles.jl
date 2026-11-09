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

function ConstructibleNumbers.inv(a::CN)::CN
    if iszero(a)
        throw(DomainError(a, "Zero is not invertible."))
    end
    return (1 / a)
end

function ConstructibleNumbers.sqrt(a::CN)::CN
    if a < 0
        throw(DomainError(a, "Cannot take the square root of a negative number."))
    end
    return CN(simplify(sqrt(a.sym)))
end

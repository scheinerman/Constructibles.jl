ConstructibleNumbers.iszero(a::CN) = iszero(a.sym)

ConstructibleNumbers.isone(a::CN) = isone(a.sym)

ConstructibleNumbers.isequal(a::CN, b::CN)::Bool = isequal(a.sym, b.sym)

ConstructibleNumbers.isless(a::CN, b::CN) = a.sym < b.sym

(<)(a::CN, b::CN)::Bool = isless(a, b)

(==)(a::CN, b::CN)::Bool = isequal(a, b)

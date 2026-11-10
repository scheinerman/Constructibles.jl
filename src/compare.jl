Constructibles.iszero(a::CN) = iszero(a.sym)
Constructibles.isone(a::CN) = isone(a.sym)
Constructibles.isequal(a::CN, b::CN)::Bool = isequal(a.sym, b.sym)
Constructibles.isless(a::CN, b::CN) = a.sym < b.sym
(<)(a::CN, b::CN)::Bool = isless(a, b)
(==)(a::CN, b::CN)::Bool = isequal(a, b)

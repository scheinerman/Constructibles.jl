# points, lines, and circles

abstract type ConstructibleObject end
const CO = ConstructibleObject

"""
    ConstructiblePoint

A point in the plane with constructible coordinates. Use `ConstructibePoint(x,y)`.

`CP` is an abbreviation for `ConstructiblePoint`.
"""
struct ConstructiblePoint <: ConstructibleObject
    x::CN
    y::CN
end

const CP = ConstructiblePoint

hash(p::CP) = hash(p.x.sym.o, Base.hash(p.y.sym.o))
hash(p::CP, h::UInt) = hash(p.x.sym.o, Base.hash(p.y.sym.o, h))

(==)(A::CP, B::CP) = (A.x == B.x) && (A.y == B.y)

function show(io::IO, p::CP)
    return print(io, "CP($(p.x), $(p.y))")
end

"""
    dist(A::CP, B::CP)

The Euclidean distance between points `A` and `B`.
"""
function dist(A::CP, B::CP)
    dx = A.x - B.x
    dy = A.y - B.y
    return sqrt(dx * dx + dy * dy)
end

##################################################################################

"""
    ConstructibleCircle

A circle in the plane whose center is a `ConstructiblePoint` and whose radius is
a `ConstructibleNumber`.

Use one of the following:
* `ConstructibleCircle(Z,r)` for a circle centered at `Z` with radius `r`.
* `ConstructibleCircle(Z,A)` for a circle centered at `Z` that includes the point `A`.
* `ConstrucibleCirlce(x,y,r)` for a circle centered at `(x,y)` with radius `r`.

`CC` is an abbreviation for `ConstrucibleCirlce`,
"""
struct ConstructibleCircle <: ConstructibleObject
    ctr::CP
    rad::CN

    function ConstructibleCircle(Z::CP, r::_EXACT)
        if r < 0
            throw(DomainError(r, "radius cannot be negative"))
        end
        return new(Z, r)
    end

    function ConstructibleCircle(Z::CP, A::CP)
        r = dist(Z, A)
        return new(Z, r)
    end

    function ConstructibleCircle(x::_EXACT, y::_EXACT, r::_EXACT)
        Z = CP(x, y)
        if r < 0
            throw(DomainError(r, "radius cannot be negative"))
        end
        return new(Z, r)
    end
end

const CC = ConstructibleCircle

center(C::CC) = C.ctr
radius(C::CC) = C.rad

(==)(C::CC, D::CC) = (C.ctr == D.ctr) && (C.rad == D.rad)

hash(C::CC) = hash(C.ctr, hash(C.rad))
hash(C::CC, h::UInt) = hash(C.ctr, hash(C.rad,h))

function show(io::IO, C::CC)
    str = "CC(($(C.ctr.x), $(C.ctr.y)), $(C.rad))"

    return print(io, str)
end

"""
    in(P::CP, C::CC)::Bool
    P ∈ C

Determine if the point `P` lies on the circle `C`.
"""
function in(P::CP, C::CC)::Bool
    d = dist(P, C.ctr)
    return d == C.rad
end

##################################################################################

"""
    _canonical(a::_EXACT, b::_EXACT, c::_EXACT)

Return a triple by scaling `(a,b,c)` so the last nonzero entry is `1`.
"""
function _canonical(a::_EXACT, b::_EXACT, c::_EXACT)::Tuple
    if a == b == c == 0
        error("0x + 0y + 0 = 0 is not a valid equation of a line.")
    end
    a, b, c = CN.((a, b, c))

    if c ≠ 0
        return (a / c, b / c, c / c)
    end

    if b ≠ 0
        return (a / b, b / b, CN(0))
    end

    return (CN(1), CN(0), CN(0))
end

"""
    ConstructibleLine

A line represented by an equation of the form `ax + by +c = 0` where `a`, `b`, and `c`
are constructible numbers, not all zero. 

* `CL(a,b,c)` for the line with equation `ax + by +c = 0`.
* `CL(A,B)` for the line through the points `A` and `B`.

`CL` is an abbreviation for `ConstructibleLine`.
"""
struct ConstructibleLine <: ConstructibleObject
    a::CN
    b::CN
    c::CN

    function ConstructibleLine(a::_EXACT, b::_EXACT, c::_EXACT)
        a, b, c = _canonical(a, b, c)
        return new(a, b, c)
    end

    function ConstructibleLine(A::CP, B::CP)
        if A == B
            error("Points must be distinct.")
        end
        M = [A.x A.y CN(1); B.x B.y CN(1)]
        a, b, c = nullspacex(M)
        return new(a, b, c)
    end
end

const CL = ConstructibleLine

function show(io::IO, L::CL)
    return print(io, "CL($(L.a), $(L.b), $(L.c))")
end

function hash(L::CL)
    a = L.a.sym.o
    b = L.b.sym.o
    c = L.c.sym.o
    return hash(a, hash(b, hash(c)))
end

function hash(L::CL, h::UInt)
    a = L.a.sym.o
    b = L.b.sym.o
    c = L.c.sym.o
    return hash(a, hash(b, hash(c, h)))
end

"""
    in(P::CP, L::CL)::Bool
    P ∈ L

Determine if the point `P` lies on the line `L`.
"""
function in(P::CP, L::CL)::Bool
    return L.a * P.x + L.b * P.y + L.c * CN(1) == CN(0)
end

(==)(L::CL, LL::CL) = (L.a == LL.a) && (L.b == LL.b) && (L.c == LL.c)

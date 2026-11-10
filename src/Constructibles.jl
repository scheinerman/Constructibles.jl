module Constructibles

using SymPy, SimpleDrawing, SimpleDrawingObjects, Plots, LinearAlgebraX

import Base:
    (+),
    (-),
    (*),
    (/),
    (<),
    (==),
    float,
    Float64,
    hash,
    in,
    intersect,
    inv,
    isequal,
    isless,
    isone,
    iszero,
    promote_rule,
    show,
    sqrt

import SymPy: latex
import SimpleDrawingObjects: draw
import Plots: center

export CC,
    center,
    CL,
    CN,
    CO,
    compass,
    ConstructibleCircle,
    ConstructibleLine,
    ConstructibleNumber,
    ConstructibleObject,
    ConstructiblePoint,
    Construction,
    CP,
    display_objects,
    display_points,
    dist,
    draw,
    label_maker,
    latex,
    radius,
    redraw,
    restart!,
    ruler,
    show_labels

const sym_type = Sym

"""
    ConstructibleNumber

This is an exact real number formed from 0 and 1, and repeated applications
of addition, subtraction, multiplication, division, and square root. 

Use `ConstructibleNumber(n::Integer)` and `ConstructibleNumber(q::Rational)` to get started.

`CN` is an abbreviation for `ConstructibleNumber`.
"""
struct ConstructibleNumber <: Real
    sym::sym_type

    function ConstructibleNumber(a::Integer)
        return new(Sym(a))
    end

    function ConstructibleNumber(a::Rational)
        if iszero(denominator(a))
            error(DivideError())
        end
        return new(a)
    end

    function ConstructibleNumber(a::sym_type)
        return new(a)
    end
end

ConstructibleNumber() = zero(ConstructibleNumber)

const CN = ConstructibleNumber

hash(a::CN) = hash(a.sym.o)
hash(a::CN, h::UInt) = hash(a.sym.o, h)

"""
    float(a::CN)

Convert `a` to a `Float64` number. 
"""
float(a::CN) = float(a.sym)

Float64(a::CN) = float(a.sym)

function show(io::IO, x::CN)
    return print(io, x.sym)
end

function promote_rule(
    ::Type{ConstructibleNumber},
    ::Type{T},
) where {T<:Union{Integer,Rational}}
    return ConstructibleNumber
end

"""
    latex(a::CN)

Return a `String` for the LaTeX code for `a`.

### Example
```
julia> a = 1 + sqrt(CN(3));

julia> println(latex(a))
1 + \\sqrt{3}
```
"""
latex(a::CN) = SymPy.latex(a.sym)

const _EXACT = Union{CN,Integer,Rational}

include("compare.jl")
include("operations.jl")
include("objects.jl")
include("intersect.jl")
include("construct.jl")
include("draw_construct.jl")

end # module 

module Constructibles

using SymPy, SimpleDrawing, SimpleDrawingObjects, Plots, LinearAlgebraX

import Base:
    show,
    promote_rule,
    float,
    Float64,
    (+),
    (-),
    (*),
    (/),
    (<),
    (==),
    hash,
    in,
    intersect,
    inv,
    sqrt,
    iszero,
    isless,
    isone,
    isequal


import SymPy: latex

import SimpleDrawingObjects: draw


export ConstructibleNumber,
    CN,
    ConstructiblePoint,
    CP,
    ConstructibleCircle,
    CC,
    ConstructibleLine,
    CL,
    ConstructibleObject,
    CO,
    center,
    radius,
    dist,
    Construction,
    reset_construction!,
    label_maker,
    draw,
    display_points,
    display_objects,
    add_point!,
    add_line!,
    add_circle!,
    redraw,
    draw_labels,
    ruler,
    compass

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

# function BigFloat(a::CN)
#     s = "big(0) + " * string(a.sym)
#     return Core.eval(Main, Meta.parse(s))
# end

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

latex(a::CN) = SymPy.latex(a.sym)

const _EXACT = Union{CN,Integer,Rational}

include("compare.jl")
include("operations.jl")
include("objects.jl")
include("intersect.jl")
include("construct.jl")
include("draw_construct.jl")

end # module 

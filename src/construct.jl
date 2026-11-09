# interactively create constructions

import SimpleDrawingObjects.draw

function label_maker(i::Int, alphabet::String="ABCDEFGHIJKLMNOPQRSTUVWXYZ")::Symbol
    n = length(alphabet)

    index = mod1(i, n)
    ticks = i ÷ n

    result = alphabet[index] ^ (ticks + 1)

    return Symbol(result)
end

export Construction,
    reset_construction!,
    label_maker,
    draw,
    display_points,
    display_objects,
    add_point!,
    add_object!,
    redraw,
    draw_labels

export ruler, compass

struct Construction
    points::Dict{Symbol,CP}
    objects::Vector{CO}

    function Construction()
        A = CP(0, 0)
        B = CP(1, 0)

        d = Dict{Symbol,CP}()
        d[:A] = A
        d[:B] = B

        @info "New Construction created"
        return new(d, CO[])
    end
end

global master::Construction

function __init__()
    return global master = Construction()
end

function reset_construction!(C::Construction=master)
    for k in keys(C.points)
        delete!(C.points, k)
    end
    A = CP(0, 0)
    B = CP(1, 0)
    C.points[:A] = A
    C.points[:B] = B

    while length(C.objects) > 0
        pop!(C.objects)
    end
    return nothing
end

"""
    display_points(C::Construction = master)

Print a table of the points in the construction.
"""
function display_points(C::Construction=master)
    np = length(C.points)
    for k in 1:np
        P = label_maker(k)
        println(P, "\t", C.points[P])
    end
    return nothing
end

function display_objects(C::Construction=master)
    for X in C.objects
        println(X)
    end
    return nothing
end

"""
    add_point!(P::CP, C::Construction = master)::Bool

Add a point to a construction. Returns `true` if successful (it's a new point)
or `false` otherwise (if the point is already in the construction).
"""
function add_point!(P::CP, C::Construction=master)::Bool
    if P ∈ values(C.points)
        return false
    end

    k = length(C.points) + 1
    S = label_maker(k)
    C.points[S] = P

    println("New point $S: $P")

    return true
end

function add_object!(X::CO, C::Construction=master)
    if X ∈ C.objects
        return false
    end
    push!(C.objects, X)
    return true
end


function _check_symbols(SS::Vector{Symbol}, C::Construction=master)::Bool
    for S in SS 
        if !haskey(C.points, S)
            return false 
        end
    end
    return true
end

"""
    ruler(P1::Symbol, P2::Symbol, C::Construction=master)::Bool

Add the line between points `P1` and `P2`.
"""
function ruler(P1::Symbol, P2::Symbol, C::Construction=master)

    if !_check_symbols([P1,P2], C)
        @info "Bad symbol"
        return false 
    end 

    d = C.points
    L = CL(d[P1], d[P2])

    if L ∈ C.objects # already have this line
        return false
    end

    for X in C.objects
        pts = X ∩ L
        for P in pts
            add_point!(P)
        end
    end

    add_object!(L, C)

    redraw()
end


function compass(CTR::Symbol, B::Symbol, C::Construction=master)

    if !_check_symbols([CTR, B], C)
        return false 
    end 

    A = C.points[CTR]
    r = dist(A, C.points[B])
    
    Z = CC(A,r)
    _compass_work(Z, C)
end

function compass(CTR::Symbol, A::Symbol, B::Symbol, C::Construction=master)
    
end



function _compass_work(Z::CC, C::Construction= master)
    if Z ∈ C.objects 
        return false 
    end

    for X in C.objects
        pts = X ∩ Z
        for P in pts
            add_point!(P)
        end
    end

    add_object!(Z, C)
    redraw()
end
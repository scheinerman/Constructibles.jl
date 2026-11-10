# interactively create constructions


function label_maker(i::Int, alphabet::String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ")::Symbol
    n = length(alphabet)

    index = mod1(i, n)
    ticks = (i-1) ÷ n

    result = alphabet[index] ^ (ticks + 1)

    return Symbol(result)
end

"""
    Construction

This is a structure that holds points, lines, and circles created 
using the `compass` and `ruler` functions. 
"""
struct Construction
    points::Dict{Symbol,CP}
    lines::Vector{CL}
    circles::Vector{CC}

    function Construction()
        A = CP(0, 0)
        B = CP(1, 0)

        d = Dict{Symbol,CP}()
        d[:A] = A
        d[:B] = B

        return new(d, CL[], CC[])
    end
end

global master::Construction

function __init__()
    return global master = Construction()
end

"""
    reset!(C::Construction = master)

Remove all objects from the construction except for the initial points `:A` and `:B`
that lie a unit distance apart.
"""
function reset!(C::Construction = master)
    for k in keys(C.points)
        delete!(C.points, k)
    end
    A = CP(0, 0)
    B = CP(1, 0)
    C.points[:A] = A
    C.points[:B] = B

    while length(C.lines) > 0
        pop!(C.lines)
    end


    while length(C.circles) > 0
        pop!(C.circles)
    end

    redraw(C)
end

"""
    display_points(C::Construction = master)

Print a table of the points in the construction.
"""
function display_points(C::Construction = master)
    np = length(C.points)
    for k = 1:np
        P = label_maker(k)
        println(P, "\t", C.points[P])
    end
    return nothing
end

"""
    display_objects(C::Construction = master)

Display all the circles and lines in the construction. 
"""
function display_objects(C::Construction = master)
    for X in C.lines
        println(X)
    end

    for X in C.circles
        println(X)
    end
    return nothing
end

"""
    add_point!(P::CP, C::Construction = master)::Bool

Add a point to a construction. Returns `true` if successful (it's a new point)
or `false` otherwise (if the point is already in the construction).
"""
function add_point!(P::CP, C::Construction = master)::Bool
    if P ∈ values(C.points)
        return false
    end

    k = length(C.points) + 1
    S = label_maker(k)
    C.points[S] = P

    println("New point $S: $P")

    return true
end



function add_line!(L::CL, C::Construction = master)
    if L ∈ C.lines
        return false
    end
    push!(C.lines, L)
    true
end

function add_circle!(Z::CC, C::Construction = master)
    if Z ∈ C.circles
        return false
    end
    push!(C.circles, Z)
    true
end








function _check_symbols(SS::Vector{Symbol}, C::Construction = master)::Bool
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
function ruler(P1::Symbol, P2::Symbol, C::Construction = master)

    if !_check_symbols([P1, P2], C)
        @info "Bad symbol"
        return false
    end

    d = C.points
    L = CL(d[P1], d[P2])

    if L ∈ C.lines # already have this line
        return false
    end

    for X in C.lines
        pts = X ∩ L
        for P in pts
            add_point!(P,C)
        end
    end

    for X in C.circles
        pts = X ∩ L
        for P in pts
            add_point!(P,C)
        end
    end


    add_line!(L, C)

    redraw()
end


"""
    compass(CTR::Symbol, A::Symbol, C::Construction = master)

Add a circle to the construction centered at `CTR` and passing through `A`.
"""
function compass(CTR::Symbol, A::Symbol, C::Construction = master)

    if !_check_symbols([CTR, A], C)
        return false
    end

    ctr = C.points[CTR]
    r = dist(ctr, C.points[A])

    Z = CC(ctr, r)
    _compass_work(Z, C)
end

"""
    compass(CTR::Symbol, A::Symbol, B::Symbol, C::Construction = master)

Add a circle to the construction centered at `CTR` with radius equal to the 
distance between `B` and `C`. 
"""
function compass(CTR::Symbol, A::Symbol, B::Symbol, C::Construction = master)
    if !_check_symbols([CTR, A, B], C)
        return false
    end

    r = dist(C.points[:A], C.points[:B])
    Z = CC(C.points[CTR], r)
    _compass_work(Z, C)
end



function _compass_work(Z::CC, C::Construction = master)
    if Z ∈ C.circles
        return false
    end

    for X in C.lines
        pts = X ∩ Z
        for P in pts
            add_point!(P)
        end
    end


    for X in C.circles
        pts = X ∩ Z
        for P in pts
            add_point!(P, C)
        end
    end

    add_circle!(Z, C)
    redraw()
end

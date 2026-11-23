"""
    label_maker(i::Int)::Symbol

Create symbols for constructions. `1` becomes `:A` through `26` becomes `:Z`. 
After that, `27` is `:AA` and so forth. 
"""
function label_maker(i::Int)::Symbol
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    n = length(alphabet)

    index = mod1(i, n)
    ticks = (i - 1) ÷ n

    result = alphabet[index] ^ (ticks + 1)

    return Symbol(result)
end

"""
    decode_label(code::Symbol)::Int

This is the inverse function of `label_maker`.
"""
function decode_label(code::Symbol)::Int
    code_str = string(code)
    letter = code_str[1]
    wrap = length(code_str)

    idx = (letter - 'A' + 1) + 26 * (wrap - 1)
    return idx
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

function show(io::IO, C::Construction)
    np = length(C.points)
    nc = length(C.circles)
    nl = length(C.lines)
    return print(io, "Construction with $np point(s), $nl line(s), and $nc circle(s)")
end

"""
    restart!(C::Construction = master)

Remove all objects from the construction except for the initial points `:A` and `:B`
that lie a unit distance apart.
"""
function restart!(C::Construction=master)
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

    return redraw(C)
end

### DISPLAYING OBJECTS

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

"""
    display_lines(C::Construction=master)

Display all the lines in the construction. 
"""
function display_lines(C::Construction=master)
    nl = length(C.lines)
    for i in 1:nl
        println("$i\t$(C.lines[i])")
    end
    return nothing
end

"""
    display_circles(C::Construction=master)

Display all the circles in the construction. 
"""
function display_circles(C::Construction=master)
    nc = length(C.circles)
    for i in 1:nc
        println("$i\t$(C.circles[i])")
    end
    return nothing
end

### FETCHING OBJECTS

"""
    get_point(P::Symbol, C::Construction=master)
    get_point(idx::Int, C::Construction=master)


Get the point named `P` or the point number `idx`. That is, 
`get_point(:A)` is the same as `get_point(1)`, `get_point(:B)` is the same
as `get_point(2)`, and so on. 
"""
function get_point(P::Symbol, C::Construction=master)
    if haskey(C.points, P)
        return C.points[P]
    end
    @info "No such point with name :$P"
end

function get_point(idx::Int, C::Construction=master)
    if idx < 1 || idx > length(C.points)
        @info "No such point at index $idx"
        return nothing
    end

    S = label_maker(idx)
    return get_point(S, C)
end

"""
    get_line(idx::Int, C::Construction = master)

Get the line with index `idx`.
"""
function get_line(idx::Int, C::Construction=master)
    nl = length(C.lines)
    if idx < 1 || idx > nl
        @info "No such line at index $idx"
        return nothing
    end
    return C.lines[idx]
end

"""
    get_line(idx::Int, C::Construction = master)

Get the line with index `idx`.
"""
function get_circle(idx::Int, C::Construction=master)
    nc = length(C.circles)
    if idx < 1 || idx > nc
        @info "No such circle at index $idx"
        return nothing
    end
    return C.circles[idx]
end

### ADDING OBJECTS WITHOUT ruler OR compass

"""
    add_point!(P::CP, C::Construction = master)::Bool

Add a point to a construction. 
"""
function add_point!(P::CP, C::Construction=master)
    if P ∈ values(C.points)
        return nothing
    end

    k = length(C.points) + 1
    S = label_maker(k)
    C.points[S] = P

    println("New point $S: $P")

    return redraw(C)
end

"""
    add_line!(L::CL, C::Construction = master)

Add a line to the construction.
"""
function add_line!(L::CL, C::Construction=master)
    if L ∈ C.lines
        return nothing
    end
    push!(C.lines, L)
    return redraw(C)
end

"""
    add_circle!(Z::CC, C::Construction = master)

Add a circle to the construction. 
"""
function add_circle!(Z::CC, C::Construction=master)
    if Z ∈ C.circles
        return nothing
    end
    push!(C.circles, Z)
    return redraw(C)
end

"""
    _check_symbols(SS::Vector{Symbol}, C::Construction = master)::Bool

Use this to check if a list of symbols (representing points) are all known
to the construction. 
"""
function _check_symbols(SS::Vector{Symbol}, C::Construction=master)::Bool
    for S in SS
        if !haskey(C.points, S)
            @info "No such point $S"
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
    if !_check_symbols([P1, P2], C)
        return nothing
    end

    d = C.points
    L = CL(d[P1], d[P2])

    if L ∈ C.lines # already have this line
        return nothing
    end

    for X in C.lines
        pts = X ∩ L
        for P in pts
            add_point!(P, C)
        end
    end

    for X in C.circles
        pts = X ∩ L
        for P in pts
            add_point!(P, C)
        end
    end

    add_line!(L, C)

    return redraw(C)
end

"""
    compass(CTR::Symbol, A::Symbol, C::Construction = master)

Add a circle to the construction centered at `CTR` and passing through `A`.
"""
function compass(CTR::Symbol, A::Symbol, C::Construction=master)
    if !_check_symbols([CTR, A], C)
        return nothing
    end

    ctr = C.points[CTR]
    r = dist(ctr, C.points[A])

    Z = CC(ctr, r)
    return _compass_work(Z, C)
end

"""
    compass(CTR::Symbol, A::Symbol, B::Symbol, C::Construction = master)

Add a circle to the construction centered at `CTR` with radius equal to the 
distance between `A` and `B`. 
"""
function compass(CTR::Symbol, A::Symbol, B::Symbol, C::Construction=master)
    if !_check_symbols([CTR, A, B], C)
        return nothing
    end

    r = dist(C.points[A], C.points[B])
    Z = CC(C.points[CTR], r)
    return _compass_work(Z, C)
end

function _compass_work(Z::CC, C::Construction=master)
    if Z ∈ C.circles
        return false
    end

    for X in C.lines
        pts = X ∩ Z
        for P in pts
            add_point!(P, C)
        end
    end

    for X in C.circles
        pts = X ∩ Z
        for P in pts
            add_point!(P, C)
        end
    end

    add_circle!(Z, C)
    return redraw(C)
end

### DELETION METHODS for Lines and Circles

"""
    delete_line!(L::CL, C::Construction)

Delete a line from a construction.
"""
function delete_line!(L::CL, C::Construction=master)
    if L ∈ C.lines
        idx = findfirst(x -> x == L, C.lines)
        deleteat!(C.lines, idx)
        redraw(C)
    else
        @info "No line $L in the construction"
    end
end

"""
    delete_circle!(X::CC, C::Construction)

Delete a circle `X` from a construction.
"""
function delete_circle!(X::CC, C::Construction=master)
    if X ∈ C.circles
        idx = findfirst(x -> x == X, C.circles)
        deleteat!(C.circles, idx)
        redraw(C)
    else
        @info "No circle $X in the construction"
    end
end

"""
    delete_point!(P::Symbol, C::Construction = master)

Delete point `P` from a construction. 
"""
function delete_point!(P::Symbol, C::Construction=master)
    if !_check_symbols([P], C)
        return nothing
    end

    np = length(C.points)  # number of points before deletion. 
    idx = decode_label(P)  # index number of the point P 

    delete!(C.points, P)   # remove P from the point list 

    # relabel all points with labels after P 

    for k in (idx + 1):np
        S = label_maker(k)   # old symbol name
        T = label_maker(k - 1) # new symbol name
        C.points[T] = C.points[S]
    end
    old_last = label_maker(np)
    delete!(C.points, old_last)
    return redraw(C)
end

function delete_point!(P::CP, C::Construction=master)
    if P ∉ values(C.points)
        @info "No point $P in this construction"
        return nothing
    end

    for S in keys(C.points)
        if C.points[S] == P
            delete_point!(S, C)
            return nothing
        end
    end
    @info "This should not happen in delete_point!($P)"
end

#### COPY/PASTE master

"""
    copy_from_master()::Construction

Create an idependent copy of the master construction. 

# Example
```
julia> X = copy_from_master()
Construction with 5 point(s), 1 line(s), and 3 circle(s)
```
"""
function copy_from_master()::Construction
    return deepcopy(Constructibles.master)
end

"""
    paste_into_master(X::Construction)

Make the master construction a copy of `X`.
"""
function paste_into_master(X::Construction)
    Constructibles.master = deepcopy(X)
    return redraw()
end

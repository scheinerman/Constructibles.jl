# drawing functions for constructions

function draw(P::CP)
    x = float(P.x)
    y = float(P.y)
    pt = Point(x, y)
    set_pointsize!(pt, 5)
    return draw(pt)
end

function draw(C::CC)
    x = float(C.ctr.x)
    y = float(C.ctr.y)
    r = float(C.rad)
    Z = Circle(x, y, r)
    return draw(Z)
end

function get_boundaries(C::Construction = master)::Vector{CN}
    LEFT = RIGHT = BOTTOM = TOP = CN(0)

    function extender(x::CN, y::CN)
        LEFT = (x < LEFT) ? x : LEFT
        RIGHT = (x > RIGHT) ? x : RIGHT
        BOTTOM = (y < BOTTOM) ? y : BOTTOM
        TOP = (y > TOP) ? y : TOP
    end

    for P in values(C.points)
        extender(P.x, P.y)
    end

    for Z in C.circles
        x = Z.ctr.x
        y = Z.ctr.y
        r = Z.rad

        extender(x-r, y-r)
        extender(x+r, y+r)
    end

    return [LEFT, RIGHT, BOTTOM, TOP]
end



function find_endpoints(theLine::CL, C::Construction = master)

    L, R, B, T = get_boundaries(C)

    Δ = CN(1//2)

    L -= Δ
    R += Δ
    B -= Δ
    T += Δ

    LL = CP(L, B)  # lower left corner
    LR = CP(R, B)  # lower right corner
    UL = CP(L, T)
    UR = CP(R, T)

    LEFT = CL(LL, UL)  # left boundary
    RIGHT = CL(LR, UR)
    TOP = CL(UL, UR)
    BOT = CL(LL, LR)

    end_points = CP[]

    for BDY in [LEFT, RIGHT, TOP, BOT]
        PP = BDY ∩ theLine   # where L meets a boundary line
        if length(PP) == 0
            continue
        end

        X = PP[1]  # this is where BDY meets L 
        if (L ≤ X.x ≤ R) && (B ≤ X.y ≤ T)
            push!(end_points, X)
        end
    end

    return unique!(end_points)
end







function draw(L::CL, C::Construction = master)
    PP = find_endpoints(L, C)
    if length(PP) < 2
        return nothing
    end

    A = PP[1]
    B = PP[2]

    ax = float(A.x)
    ay = float(A.y)
    bx = float(B.x)
    by = float(B.y)
    S = Segment(ax, ay, bx, by)
    return draw(S)
end

"""
    redraw(C::Construction = master)

Redraw the construction.
"""
function redraw(C::Construction = master)
    newdraw()
    for P in values(C.points)
        draw(P)
    end

    for X in C.circles
        draw(X)
    end

    for X in C.lines
        draw(X, C)
    end

    return finish()
end

"""
    show_labels(C::Construction = master)

Overlay the points in the construction with their names. The labels disappear
after a subsequent`redraw`, `compass`, or `ruler`.
"""
function show_labels(C::Construction = master)
    for k in keys(C.points)
        P = C.points[k]
        x = float(P.x)
        y = float(P.y)
        annotate!(x, y, (string(k), :red, 20))
    end
    return finish()
end

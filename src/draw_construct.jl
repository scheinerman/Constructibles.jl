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

function find_endpoints(L::CL)
    x1, x2 = xlims()
    y1, y2 = ylims()

    a1 = floor(Int, x1)
    a2 = ceil(Int, x2)
    b1 = floor(Int, y1)
    b2 = floor(Int, y2)

    LL = CP(a1, b1)  # lower left corner
    LR = CP(a2, b1)  # lower right corner
    UL = CP(a1, b2)
    UR = CP(a2, b2)

    # # DEBUG #
    # R = Rectangle(a1,b1,a2,b2)
    # draw(R)

    LEFT = CL(LL, UL)  # left boundary
    RIGHT = CL(LR, UR)
    TOP = CL(UL, UR)
    BOT = CL(LL, LR)

    end_points = CP[]

    for BDY in [LEFT, RIGHT, TOP, BOT]
        PP = BDY ∩ L   # where L meets a boundary line
        if length(PP) == 0
            continue
        end

        X = PP[1]  # this is where BDY meets L 
        if (a1 ≤ X.x ≤ a2) && (b1 ≤ X.y ≤ b2)
            push!(end_points, X)
        end
    end

    return unique!(end_points)
end

function draw(L::CL)
    PP = find_endpoints(L)
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

function redraw(C::Construction = master)
    newdraw()
    for P in values(C.points)
        draw(P)
    end

    for X in C.circles
        draw(X)
    end

    for X in C.lines
        draw(X)
    end

    return finish()
end

function draw_labels(C::Construction = master)
    for k in keys(C.points)
        P = C.points[k]
        x = float(P.x)
        y = float(P.y)
        annotate!(x, y, (string(k), :red, 20))
    end
    return finish()
end

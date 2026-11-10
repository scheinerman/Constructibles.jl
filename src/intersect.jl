"""
    intersect(L1::CL, L2::CL)::Vector{CP}
    intersect(L::CL, Z::CC)::Vector{CP}
    intersect(Z1::CC, Z2::CC)::Vector{CP}

Find the intersection of the respective constructible objects. 
The result is a list of 0, 1, or 2 constructible points. 

The `∩` operator may be used for intersection. 
"""
function intersect(L1::CL, L2::CL)::Vector{CP}
    result = CP[]

    if L1 == L2   # two lines are the same; no point determined
        return result
    end

    a, b, c = L1.a, L1.b, L1.c
    aa, bb, cc = L2.a, L2.b, L2.c

    if aa * b - a * bb == 0
        return result
    end

    x = (bb * c - b * cc) / (aa * b - a * bb)
    y = -(aa * c - a * cc) / (aa * b - a * bb)

    P = CP(x, y)

    return [P]
end

function intersect(L::CL, Z::CC)::Vector{CP}
    a, b, c = L.a, L.b, L.c
    u, v, r = Z.ctr.x, Z.ctr.y, Z.rad

    a, b, c, u, v, r

    Δ =
        -a^2 * u^2 - b^2 * v^2 + (a^2 + b^2) * r^2 - 2 * a * c * u - c^2 -
        2 * (a * b * u + b * c) * v

    if Δ < 0
        return CP[]
    end

    x1 = (b^2 * u - a * b * v - a * c - sqrt(Δ) * b) / (a^2 + b^2)
    y1 = -(a * b * u - a^2 * v + b * c - sqrt(Δ) * a) / (a^2 + b^2)

    P1 = CP(x1, y1)

    if Δ == 0
        return [P1]
    end

    x2 = (b^2 * u - a * b * v - a * c + sqrt(Δ) * b) / (a^2 + b^2)
    y2 = -(a * b * u - a^2 * v + b * c + sqrt(Δ) * a) / (a^2 + b^2)

    P2 = CP(x2, y2)

    result = [P1; P2]
    return result
end

intersect(Z::CC, L::CL)::Vector{CP} = L ∩ Z

function intersect(Z1::CC, Z2::CC)::Vector{CP}
    if Z1 == Z2
        return CP[]
    end

    a, b, r = Z1.ctr.x, Z1.ctr.y, Z1.rad
    c, d, s = Z2.ctr.x, Z2.ctr.y, Z2.rad

    Δ = (
        -a^4 - 2 * a^2 * b^2 - b^4 + 4 * a * c^3 - c^4 + 4 * b * d^3 - d^4 - r^4 - s^4 -
        2 * (3 * a^2 + b^2) * c^2 - 2 * (a^2 + 3 * b^2 - 2 * a * c + c^2) * d^2 +
        2 * (a^2 + b^2 - 2 * a * c + c^2 - 2 * b * d + d^2) * r^2 +
        2 * (a^2 + b^2 - 2 * a * c + c^2 - 2 * b * d + d^2 + r^2) * s^2 +
        4 * (a^3 + a * b^2) * c +
        4 * (a^2 * b + b^3 - 2 * a * b * c + b * c^2) * d
    )

    if Δ < 0
        return CP[]
    end

    half = CN(1//2)

    x1 =
        half * (
            a^3 + a * b^2 - a * c^2 + c^3 + (a + c) * d^2 - (a - c) * r^2 + (a - c) * s^2 -
            (a^2 - b^2) * c - 2 * (a * b + b * c) * d - sqrt(Δ) * (b - d)
        ) / (a^2 + b^2 - 2 * a * c + c^2 - 2 * b * d + d^2)
    y1 =
        half * (
            a^2 * b + b^3 - 2 * a * b * c + b * c^2 - b * d^2 + d^3 - (b - d) * r^2 +
            (b - d) * s^2 +
            (a^2 - b^2 - 2 * a * c + c^2) * d +
            sqrt(Δ) * (a - c)
        ) / (a^2 + b^2 - 2 * a * c + c^2 - 2 * b * d + d^2)

    P1 = CP(x1, y1)

    if Δ == 0
        return [P1]
    end

    x2 =
        half * (
            a^3 + a * b^2 - a * c^2 + c^3 + (a + c) * d^2 - (a - c) * r^2 + (a - c) * s^2 -
            (a^2 - b^2) * c - 2 * (a * b + b * c) * d + sqrt(Δ) * (b - d)
        ) / (a^2 + b^2 - 2 * a * c + c^2 - 2 * b * d + d^2)
    y2 =
        half * (
            a^2 * b + b^3 - 2 * a * b * c + b * c^2 - b * d^2 + d^3 - (b - d) * r^2 +
            (b - d) * s^2 +
            (a^2 - b^2 - 2 * a * c + c^2) * d - sqrt(Δ) * (a - c)
        ) / (a^2 + b^2 - 2 * a * c + c^2 - 2 * b * d + d^2)

    P2 = CP(x2, y2)

    return [P1, P2]
end

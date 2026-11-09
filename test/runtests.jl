using Test, Constructibles

a = 1 + sqrt(CN(2))

@test a > 0
@test a * a / a == a

φ = (1 + sqrt(CN(5))) / 2

@test iszero(φ^2 - φ - 1)

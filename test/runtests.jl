using Test, Constructibles, LinearAlgebraX


@testset "Basics" begin
    a = 1 + sqrt(CN(2))

    @test a > 0
    @test a * a / a == a

    @test (a-1)*(a+1) == a^2 - 1

    φ = (1 + sqrt(CN(5))) / 2

    @test iszero(φ^2 - φ - 1)

    M = CN.([1 3; 2 5])
    v = CN.([3, 5])

    @test M*v == CN.([18; 31])
    @test rankx(M) == 2
end

@testset "Geometry" begin 
    A = CP(0,0)
    B = CP(0,1)
    C = CP(1//2, 1)

    L1 = CL(A,B) # vertical line
    L2 = CL(A,C)
    @test length(L1 ∩ L2) == 1

    Z1 = CC(A,2)
    Z2 = CC(B,2)
    @test length(Z1∩Z2) == 2

    @test length(Z1 ∩ L1) == 2 

    Z = CC(A,1)
    L = CL(CP(1,0), CP(1,1))

    @test length(L ∩ Z) == 1

    @test CP(1,0) ∈ L 
    @test CP(1,0) ∈ Z

end
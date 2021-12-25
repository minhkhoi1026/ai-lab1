struct HierarchicalSoftmax
    λ # precision
    k # iters
    π # policy

    function HierarchicalSoftmax(𝒫::SimpleGame, λ, k)
        π = [SimpleGamePolicy(ai => 1.0 for ai in 𝒜i) for 𝒜i in 𝒫.𝒜]
        return new(λ, k, π)
    end
end

function solve_hierarchical_softmax(𝒫::SimpleGame, λ, k)
    M = HierarchicalSoftmax(𝒫, λ, k)
    π = M.π
    for k in 1:M.k
        π = [softmax_response(𝒫, π, i, M.λ) for i in 𝒫.ℐ]
    end
    return π
end

function print_hierarchical_softmax(π)
    for πi in π
        println("Agent")
        for i in πi.p
            print(i.first)
            print(" : ")
            println(i.second)
        end
        println()
    end
end
struct IteratedBestResponse
    k_max   # num iter
    π       # initial policy

    function IteratedBestResponse(𝒫::SimpleGame, k_max)
        π = [SimpleGamePolicy(ai => 1.0 for ai in 𝒜i) for 𝒜i in 𝒫.𝒜]
        return new(k_max, π)
    end
end

function solve_iter_best(𝒫::SimpleGame, k_max)
    M = IteratedBestResponse(𝒫, k_max)
    π = M.π
    for k in 1:M.k_max
        π = [best_response(𝒫, π, i) for i in 𝒫.ℐ]
    end
    return π
end

function print_iter_best(π)
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

mutable struct FictitiousPlay
    𝒫   # game
    i   # agent index
    N   # action count dict
    πi  # policy

    function FictitiousPlay(𝒫::SimpleGame, i)
        N = [Dict(aj => 0 for aj in 𝒫.𝒜[j]) for j in 𝒫.ℐ]
        πi = SimpleGamePolicy(ai => 1.0 for ai in 𝒫.𝒜[i])
        return new(𝒫, i, N, πi)
    end
end

(πi::FictitiousPlay)() = πi.πi()

(πi::FictitiousPlay)(ai) = πi.πi(ai)

function update!(πi::FictitiousPlay, a)
    N, 𝒫, ℐ, i = πi.N, πi.𝒫, πi.𝒫.ℐ, πi.i
    
    for (j, aj) in enumerate(a)
        N[j][aj] += 1
    end

    p(j) = SimpleGamePolicy(aj => u/sum(values(N[j])) for (aj,u) in N[j])
    π = [p(j) for j in ℐ]
    πi.πi = best_response(𝒫, π, i)
end

function stimulate(𝒫::SimpleGame, k_max)
    π = [FictitiousPlay(𝒫, i) for i in 𝒫.ℐ]

    for k = 1:k_max
        a = [πi() for πi in π]
        for πi in π
            update!(πi, a)
        end

        println()
        println("Iterate: ", k)
        for πi in π
            print("Agent: ")
            for i in πi.πi.p
                println(i.first)
            end
        end
    end
    return π
end

function print_stimulate(π::Array{FictitiousPlay})
    for πi in π
        println("Agent: ")
        for i in πi.πi.p
            println(i.first, " : ", i.second)
        end
    end
end


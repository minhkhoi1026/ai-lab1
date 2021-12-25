mutable struct GradientAscent
    𝒫
    i
    t
    πi

    function GradientAscent(𝒫::SimpleGame, i)
        uniform() = SimpleGamePolicy(ai => 1.0 for ai in 𝒫.𝒜[i])
        return new(𝒫, i, 1, uniform())
    end
end

(πi::GradientAscent)() = πi.πi()
(πi::GradientAscent)(ai) = πi.πi(ai)

function project_to_simplex(y)
    u = sort(copy(y), rev = true)
    i = maximum([j for j in eachindex(u)
                 if u[j] + (1 - sum(u[1:j])) / j > 0.0])
    δ = (1 - sum(u[j] for j = 1:i)) / i
    return [max(y[j] + δ, 0.0) for j in eachindex(u)]
end

function update!(πi::GradientAscent, a)
    𝒫, ℐ, 𝒜i, i, t = πi.𝒫, πi.𝒫.ℐ, πi.𝒫.𝒜[πi.i], πi.i, πi.t 
    jointπ(ai) = [SimpleGamePolicy(j == i ? ai : a[j]) for j in ℐ]
    r = [utility(𝒫, jointπ(ai), i) for ai in 𝒜i]
    π′ = [πi.πi(ai) for ai in 𝒜i]
    π = project_to_simplex(π′ + r/sqrt(t))
    πi.t = t + 1
    πi.πi = SimpleGamePolicy(ai => p for (ai,p) in zip(𝒜i,π))
end

function solve_gradient(𝒫::SimpleGame, k_max)
    π = [GradientAscent(𝒫, i) for i in 𝒫.ℐ]

    for i in 1:k_max
        a = [πi() for πi in π]
        for πi in π
            update!(πi, a)
        end
    end
    return π
end

function print_gradient(π::Array{GradientAscent})
    for πi in π
        println("Agent: ")
        for i in πi.πi.p
            println(i.first, " : ", i.second)
        end
    end
end

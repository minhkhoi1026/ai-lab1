mutable struct ControllerPolicy
    𝒫 # problem
    X # set of controller nodes
    ψ # action selection distribution
    η # successor selection distribution
end

function (π::ControllerPolicy)(x)
    𝒜, ψ = π.𝒫.𝒜, π.ψ
    dist = [ψ[x, a] for a in 𝒜]
    return rand(SetCategorical(𝒜, dist))
end

function update(π::ControllerPolicy, x, a, o)
    X, η = π.X, π.η 
    dist = [η[x, a, o, x′] for x′ in X]
    return rand(SetCategorical(X, dist))
end

function utility(π::ControllerPolicy, U, x, s)
    𝒮, 𝒜, 𝒪 = π.𝒫.𝒮, π.𝒫.𝒜, π.𝒫.𝒪
    T, O, R, γ = π.𝒫.T, π.𝒫.O, π.𝒫.R, π.𝒫.γ
    X, ψ, η = π.X, π.ψ, π.η
    U′(a, s′, o) = sum(η[x, a, o, x′] * U[x′, s′] for x′ in X)
    U′(a, s′) = T(s, a, s′) * sum(O(a, s′, o) * U′(a, s′, o) for o in 𝒪)
    U′(a) = R(s, a) + γ*sum(U′(a, s′) for s′ in 𝒮)
    return sum(ψ[x, a]*U′(a) for a in 𝒜)
end

function iterative_policy_evaluation(π::ControllerPolicy, k_max)
    𝒮, X = π.𝒫.𝒮, π.X
    U = Dict((x, s) => 0.0 for x in X, s in 𝒮)
    for k in 1:k_max
        U = Dict((x, s) => utility(π, U, x, s) for x in X, s in 𝒮)
    end
    return U
end

################################################################################################

struct ControllerPolicyIteration
    k_max   # number of iterationse
    val_max # number of evaluation iterations
end

function solve(M::ControllerPolicyIteration, 𝒫::POMDP)
    𝒜, 𝒪, k_max, eval_max = 𝒫.𝒜, 𝒫.𝒪, M.k_max, M.eval_max
    X = [1]
    ψ = Dict((x, a) => 1.0/length(𝒜) for x in X, a in 𝒜)
    η = Dict((x, a, o, x′) => 1.0 for x in X, a in 𝒜, o in 𝒪, x′ in X)
    π = ControllerPolicy(𝒫, X, ψ, η) 
    for i in 1:k_max
        prevX = copy(π.X)
        U = iterative_policy_evaluation(π, eval_max)
        policy_improvement!(π, U, prevX)
        prune!(π, U, prevX)
    end
    return π
end

function policy_improvement!(π::ControllerPolicy, U, prevX)
    𝒮, 𝒜, 𝒪 = π.𝒫.𝒮, π.𝒫.𝒜, π.𝒫.𝒪
    X, ψ, η = π.X, π.ψ, π.η
    repeatX𝒪 = fill(X, length(𝒪))
    assign𝒜X′ = vec(collect(product(𝒜,repeatX𝒪...)))
    for ax′ in assign𝒜X′
        x, a = maximum(X) + 1, ax′[1]
        push!(X,x)
        successor(o) = ax′[findfirst(isequal(o), 𝒪) + 1]
        U′(o, s′) = U[successor(o), s′]
        for s in 𝒮
            U[x, s] = lookahead(π.𝒫, U′, s, a)
        end
        for a′ in 𝒜
            ψ[x, a′] = a′==a ? 1.0 : 0.0
            for (o, x′) in product(𝒪, prevX)
                η[x, a′, o, x′] = x′==successor(o) ? 1.0 : 0.0
            end
        end
    end
    for(x, a, o, x′) in product(X, 𝒜, 𝒪, X)
        if !haskey(η, (x, a, o, x′))
            η[x, a, o, x′] = 0.0
        end
    end
end

################################################################################################

function prune!(π::ControllerPolicy, U, prevX)
    𝒮, 𝒜, 𝒪, X, ψ, η = π.𝒫.𝒮, π.𝒫.𝒜, π.𝒫.𝒪, π.X, π.ψ, π.η
    newX, removeX = setdiff(X,prevX), [] # prune dominated from previous nodes
    dominated(x, x′) = all(U[x, s] ≤ U[x′, s] for s in 𝒮)
    for (x, x′) in product(prevX, newX)
        if x′ ∉ removeX && dominated(x, x′)
            for s in 𝒮
                U[x, s] = U[x′, s]
            end
            for a in 𝒜
                ψ[x, a] = ψ[x′, a]
                for (o, x′′) in product(𝒪, X)
                    η[x, a, o, x′′] = η[x′, a, o, x′′]
                end
            end
            push!(removeX, x′)
        end
    end
    # prune identical from previous nodes
    identical_action(x, x′) = all(ψ[x, a] ≈ ψ[x′, a] for a in 𝒜)
    identical_successor(x, x′) = all(η[x, a, o, x′′] ≈ η[x′, a, o, x′′] for a in 𝒜, o in 𝒪, x′′ in X)
    identical(x, x′) = identical_action(x, x′) && identical_successor(x, x′)
    for (x, x′) in product(prevX,newX)
        if x′ ∉ removeX && identical(x, x′)
            push!(removeX, x′)
        end
    end
    # prune dominated from new nodes
    for (x,x′) in product(X, newX)
        if x′ ∉ removeX && dominated(x′, x) && x≠x′
            push!(removeX, x′)
        end
    end
    # update controller
    π.X = setdiff(X,removeX)
    π.ψ = Dict(k => v for (k, v) in ψ if k[1] ∉ removeX)
    π.η = Dict(k => v for (k,v) in η if k[1] ∉ removeX)
end

################################################################################################
struct NonlinearProgramming
    b # initial belief
    ℓ # number of nodes
end

function tensorform(𝒫::POMDP)
    𝒮, 𝒜, 𝒪, R, T, O = 𝒫.𝒮, 𝒫.𝒜, 𝒫.𝒪, 𝒫.R, 𝒫.T, 𝒫.O
    𝒮′ = eachindex(𝒮) 
    𝒜′ = eachindex(𝒜)
    𝒪′ = eachindex(𝒪)
    R′ = [R(s, a) for s in 𝒮, a in 𝒜]
    T′ = [T(s, a, s′) for s in 𝒮, a in 𝒜, s′ in 𝒮]
    O′ = [O(a, s′, o) for a in 𝒜, s′ in 𝒮, o in 𝒪]
    return 𝒮′, 𝒜′, 𝒪′, R′, T′, O′
end

function solve(M::NonlinearProgramming, 𝒫::POMDP)
    x1, X = 1, collect(1 : M.ℓ)
    𝒫, γ, b = 𝒫, 𝒫.γ, M.b
    𝒮, 𝒜, 𝒪, R, T, O = tensorform(𝒫)
    model = Model(Ipopt.Optimizer)
    @variable(model, U[X, 𝒮])
    @variable(model, ψ[X, 𝒜] ≥ 0)
    @variable(model, η[X, 𝒜, 𝒪, X] ≥ 0)
    @objective(model, Max, b⋅U[x1,:])
    @NLconstraint(model, [x=X, s=𝒮], 
        U[x, s] == (sum(ψ[x, a]*(R[s, a] + γ*sum(T[s, a, s′]*sum(O[a, s′, o]*
                    sum(η[x, a, o, x′]*U[x′, s′] for x′ in X) for o in 𝒪) for s′ in 𝒮)) for a in 𝒜)))
    @constraint(model, [x = X], sum(ψ[x,:])==1)
    @constraint(model, [x = X, a = 𝒜, o = 𝒪], sum(η[x, a, o, :])==1)
    optimize!(model)
    ψ′, η′ = value.(ψ), value.(η)
    return ControllerPolicy(𝒫, X, 
            Dict((x, 𝒫.𝒜[a]) => ψ′[x, a] for x in X, a in 𝒜),
            Dict((x, 𝒫.𝒜[a], 𝒫.𝒪[o], x′) => η′[x, a, o, x′] for x in X, a in 𝒜, o in 𝒪, x′ in X))
end



using JuMP, Ipopt

function solve_correlated(𝒫::SimpleGame)
    ℐ, 𝒜, R = 𝒫.ℐ, 𝒫.𝒜, 𝒫.R
    model = Model(Ipopt.Optimizer)
    @variable(model, π[joint(𝒜)] ≥ 0)
    @objective(model, Max, sum(sum(π[a]*R(a) for a in joint(𝒜))))
    @constraint(model, [i = ℐ, ai = 𝒜[i], ai′ = 𝒜[i]],
        sum(R(a)[i]*π[a] for a in joint(𝒜) if a[i] == ai)
        ≥ sum(R(override(a, ai′, i))[i]*π[a] for a in joint(𝒜) if a[i]==ai))
    @constraint(model, sum(π) == 1)
    optimize!(model)
    return JointCorrelatedPolicy(a => value(π[a]) for a in joint(𝒜))
end

function print_correlated(π::JointCorrelatedPolicy)
    for i in π.p
        print(i.first)
        print(" : ")
        println(i.second)
    end
end
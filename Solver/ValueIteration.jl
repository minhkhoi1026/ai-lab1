function solve_value_iteration(𝒫::MDP, k_max)
    U = [0.0 for s in 𝒫.𝒮]
    for k = 1:k_max
        U = [backup(𝒫, U, s) for s in 𝒫.𝒮]
    end
    return ValueFunctionPolicy(𝒫, U)
end
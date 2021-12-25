function joint(X::Array)
    return collect(Iterators.product(X...))
end

function override(π, πi, i) # override π[i] = πi
    return [i == j ? πi : πj for (j, πj) in enumerate(π)]
end

function utility(𝒫::SimpleGame, π, i)
    𝒜, R = 𝒫.𝒜, 𝒫.R
    p(a) = prod(πj(aj) for (πj,aj) in zip(π, a))
    return sum(R(a)[i] * p(a) for a in joint(𝒜))
end

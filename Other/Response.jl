function best_response(𝒫::SimpleGame, π, i)
    U(ai) = utility(𝒫, override(π, SimpleGamePolicy(ai), i), i)
    ai = argmax(U, 𝒫.𝒜[i])
    return SimpleGamePolicy(ai)
end

function softmax_response(𝒫::SimpleGame, π, i, λ) # λ precision parameter
    U(ai) = utility(𝒫, override(π, SimpleGamePolicy(ai), i), i)
    return SimpleGamePolicy(ai => exp(λ*U(ai)) for ai in 𝒫.𝒜[i])
end
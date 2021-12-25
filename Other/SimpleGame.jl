struct SimpleGame
    γ::Float32 # discount factor
    ℐ::Array  # agents
    𝒜::Array  # joint action space
    R::Function  # joint reward function
end
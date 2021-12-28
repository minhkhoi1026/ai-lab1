module MarkovGameProblems

export solve_mg_nash_q_learning, solve_mg_nash_equilibrium
export CirclePredatorPreyHexWorld, PredatorPreyHexWorld, MG

include("Other/SimpleGame.jl")
include("Other/Utilities.jl")
include("Other/SetCategorical.jl")
include("Other/Response.jl")
include("Other/MG.jl")
include("Other/MDP.jl")
include("Other/MG.jl")
include("Other/DiscreteMDP.jl")

# Policy
include("Policy/SimpleGamePolicy.jl")
include("Policy/MGPolicy.jl")

# Solver
include("Solver/MGNashEquilibrium.jl")
include("Solver/MGNashQLearning.jl")
include("Solver/NashEquilibrium.jl")

# Problems
include("Problems/PredatorPreyHexWorld.jl")
include("Problems/HexWorld.jl")

end # module
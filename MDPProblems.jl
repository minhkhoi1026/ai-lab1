module MDPProblems

export solve_value_iteration
export StandardHexWorld, StraightLineHexWorld, MDP, hex_direction

include("Other/MDP.jl")
include("Other/LookAhead.jl")
include("Other/SetCategorical.jl")
include("Other/DiscreteMDP.jl")

# Policy
include("Policy/ValueFunctionPolicy.jl")

# Solver
include("Solver/ValueIteration.jl")

# Problems
include("Problems/HexWorld.jl")

end # module
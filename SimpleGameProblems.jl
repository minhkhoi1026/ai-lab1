module SimpleGameProblems

export RockPaperScissors, TravelersDilenma
export solve_nash, solve_correlated, solve_iter_best, solve_hierarchical_softmax, stimulate, solve_gradient
export print_nash, print_correlated, print_iter_best, print_hierarchical_softmax, print_stimulate, print_gradient

include("Other/SimpleGame.jl")
include("Other/Utilities.jl")
include("Other/SetCategorical.jl")
include("Other/Response.jl")

# Policy
include("Policy/SimpleGamePolicy.jl")
include("Policy/JointCorrelatedPolicy.jl")

# Solver
include("Solver/NashEquilibrium.jl")
include("Solver/CorrelatedEquilibrium.jl")
include("Solver/IteratedBestResponse.jl")
include("Solver/HierarchicalSoftmax.jl")
include("Solver/FictitiousPlay.jl")
include("Solver/GradientAscent.jl")

# Problems
include("Problems/RockPaperScissors.jl")
include("Problems/TravelersDilenma.jl")

end # module
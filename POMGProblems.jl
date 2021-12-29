module POMGProblems

using RandomNumbers
using Distributions
using LinearAlgebra
using GridInterpolations
using Parameters
using JuMP
using GLPK

export
    POMDP, DiscretePOMDP, CryingBaby, BoolDistribution,
    POMG, MultiCaregiverCryingBaby
    solve_pomg_nash

import Base: <, ==, rand, vec

include("Other/SetCategorical.jl")
include("Other/POMDP.jl")
include("Other/DiscretePomdp.jl")
include("Other/POMG.jl")
include("Other/SimpleGame.jl")
include("Other/Belief.jl")

# Policy
include("Policy/ConditionalPlan.jl")
include("Policy/AlphaVectorPolicy.jl")
include("Policy/Controller.jl")
include("Policy/SimpleGamePolicy.jl")

# Solver
include("Solver/ConditionalPlanNonlinearProgramming.jl")
include("Solver/ControllerNonlinearProgramming.jl")
include("Solver/POMGNashEquilibrium.jl")
include("Solver/DynamicProgramming.jl")

# Problems
include("Problems/CryingBaby.jl")
include("Problems/Multicaregiver.jl")

end # module


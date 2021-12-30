module POMGProblems

using RandomNumbers
using Distributions
using LinearAlgebra 
using GridInterpolations
using Parameters
using JuMP
using GLPK
using Ipopt
using Shuffle

export
    POMDP, DiscretePOMDP, CryingBaby, 
    ValueIteration, BoolDistribution, solve_conditional_plan_nonlinear, NonlinearProgramming, solve_controller_nonlinear,
    POMG, MultiCaregiverCryingBaby,
    POMGNashEquilibrium, solve_pomg_nash, POMGDynamicProgramming, DynamicProgramming

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
include("Solver/NashEquilibrium.jl")
include("Solver/POMGNashEquilibrium.jl")
include("Solver/DynamicProgramming.jl")

# Problems
include("Problems/CryingBaby.jl")
include("Problems/Multicaregiver.jl")

include("Other/Utilities.jl")
end # module


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
    POMG, MultiCaregiverCryingBaby,
    ValueIteration, value_iteration, solve

import Base: <, ==, rand, vec

include("Other/SetCategorical.jl")

include("Other/POMDP.jl")
include("Other/DiscretePomdp.jl")
include("Other/POMG.jl")

include("Problems/CryingBaby.jl")
include("Problems/Multicaregiver.jl")

include("Other/Belief.jl")
include("Solver/ConditionalPlan.jl")
include("Solver/Controller.jl")

end # module


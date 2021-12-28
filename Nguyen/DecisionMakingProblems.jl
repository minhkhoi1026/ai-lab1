module DecisionMakingProblems

using RandomNumbers
using Distributions
using LinearAlgebra
using GridInterpolations
using Parameters

export
    POMDP, DiscretePOMDP, CryingBaby, BoolDistribution,
    POMG, MultiCaregiverCryingBaby,
    update

import Base: <, ==, rand, vec

include("helper/support_code.jl")
include("CryingBaby/pomdp.jl")
include("CryingBaby/discrete_pomdp.jl")
include("CryingBaby/crying_baby.jl")
include("helper/belief.jl")



end # module


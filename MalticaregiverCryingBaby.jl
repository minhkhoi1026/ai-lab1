using CSV
using DataFrames
using BenchmarkTools
include("POMGProblems.jl")
using .POMGProblems

""" 2. State, Action, Observation, belief state """ 
# State
SATED = 1
HUNGRY = 2

# Action
FEED = 1
IGNORE = 2
SING = 3

# Observation
CRYING = true
QUIET = false

# Belief state
b = [0.5, 0.5]

state = Dict(SATED => "SATED", HUNGRY => "HUNGRY")
action = Dict(FEED => "FEED", IGNORE => "IGNORE", SING => "SING")
observation = Dict(CRYING => "CRYING", QUIET => "QUIET")

#################################################################################################

""" Run Nash, DynamicProgramming """ 
function loopNash(M, 𝒫, loop::Int)
    data = Set()
    for i in 1:loop
        policy = solve_pomg_nash(M, 𝒫)
        push!(data, policy)
    end
    return data
end

function loopDynamicProgramming(M, 𝒫, loop::Int)
    data = Set()
    for i in 1:loop
        policy = DynamicProgramming(M, 𝒫)
        push!(data, policy)
    end
    return data
end

function writeCSV(data::Set, fileName)
    agent1 = []
    agent2 = []
    for loop in data
        push!(agent1, string(loop[1]))
        push!(agent2, string(loop[2]))
    end
    df = DataFrame(Agent1 = agent1, Agent2 = agent2)
    CSV.write(fileName, df)
end

#################################################################################################

mMCB = MultiCaregiverCryingBaby()
decprobMCB = POMG(mMCB)

pomgNE = POMGNashEquilibrium(b, 3)
pomgDP = POMGDynamicProgramming(b, 3)

#################################################################################################

@time begin
result = loopNash(pomgNE, decprobMCB, 20)
end
"""

@btime begin
result = loopDynamicProgramming(pomgDP, decprobMCB, 10)
end
"""

writeCSV(result, "result/nash.csv")



""" Visualize """
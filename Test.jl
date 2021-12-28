include("MarkovGameProblems.jl")
using .MarkovGameProblems
using Serialization

a = deserialize("predator_prey.txt") 

print(typeof(a))
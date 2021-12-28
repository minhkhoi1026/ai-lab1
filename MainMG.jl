include("MarkovGameProblems.jl")
using .MarkovGameProblems
using Serialization

const game = CirclePredatorPreyHexWorld()

println("MG Nash Q Learning")
@time begin
π = solve_mg_nash_q_learning(MG(game), 10000)
end
println("Solved MG Nash Q Learning")
serialize("predator_prey.txt", π)
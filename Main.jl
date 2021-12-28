include("SimpleGameProblems.jl")
using .SimpleGameProblems

game = RockPaperScissors()

# println("Nash")
# nash = solve_nash(game)
# print_nash(nash)

# println("Correlated")
# corr = solve_correlated(game)
# print_correlated(corr)

# println("Best response")
# best = solve_iter_best(game, 10)
# print_iter_best(best)

# println("Softmax")
# soft = solve_hierarchical_softmax(game, 0.9, 10)
# print_hierarchical_softmax(soft)

println("Stimulate")
sti = stimulate(game, 1000000)
print_stimulate(sti)

# println("Gradient")
# grad = solve_gradient(game, 20)
# print_gradient(grad)
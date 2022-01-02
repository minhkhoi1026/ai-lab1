include("MDPProblems.jl")
using .MDPProblems
include("./PlotHexWorld.jl")

game = StandardHexWorld()
game_mdp = MDP(game)
res = solve_value_iteration(game_mdp, 1000)
for s in 1:25
    println(res.U[s])
end
# optimal_utility = res.U

# umax, _ = findmax(optimal_utility)
# umin, _ = findmin(optimal_utility)
# rescaled_utility = map(u -> (u - umin)/(umax - umin), optimal_utility)
# colormap = cgrad(:RdBu_9)
# p = draw_hexgrid(game.hexes)
# for s in 1:length(game.hexes)
#     direction = res(s)
#     draw_hexbin(p, game.hexes, game.hexes[s], hex_direction[direction], colormap[rescaled_utility[s]])
# end

# display(p)
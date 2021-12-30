using plots

function plot_alpha_vectors(policy, p_hungry, label="QMDP")
	# calculate the maximum utility, which determines the action to take
	current_belief = [p_hungry, 1-p_hungry]
	feed_idx = Int(policy.action_map[1])+1
	ignore_idx = Int(policy.action_map[2])+1
	utility_feed = policy.alphas[feed_idx]' * current_belief # dot product
	utility_ignore = policy.alphas[ignore_idx]' * current_belief # dot product
	lw_feed, lw_ignore = 1, 1
	check_feed, check_ignore = "", ""
	if utility_feed >= utility_ignore
		current_utility = utility_feed
		lw_feed = 2
		check_feed = "✓"
	else
		current_utility = utility_ignore
		lw_ignore = 2
		check_ignore = "✓"
	end
	
	# plot the alpha vector hyperplanes
	plot(size=(600,340))
	plot!(Int.([FULLₛ, HUNGRYₛ]), policy.alphas[ignore_idx],
		  label="ignore ($label) $(check_ignore)", c=:red, lw=lw_ignore)
	plot!(Int.([FULLₛ, HUNGRYₛ]), policy.alphas[feed_idx],
		  label="feed ($label) $(check_feed)", c=:blue, lw=lw_feed)
	
	# plot utility of selected action
	rnd(x) = round(x,digits=3)
	scatter!([p_hungry], [current_utility], 
		     c=:black, ms=5, label="($(rnd(p_hungry)), $(rnd(current_utility)))")

	title!("Alpha Vectors")
	xlabel!("𝑝(hungry)")
	ylabel!("utility 𝑈(𝐛)")
	xlims!(0, 1)
	ylims!(-40, 5)
end
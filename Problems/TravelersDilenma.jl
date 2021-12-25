function get_reward_travelers(a)
    @assert(length(a) == 2)
    r_min = min(a[1], a[2])
    r = [r_min, r_min]

    if a[1] > a[2]
        r[1] -= 2
        r[2] += 2

    elseif a[1] < a[2]
        r[1] += 2
        r[2] -= 2
    end

    return r
end

function TravelersDilenma()
    DISCOUNT_FACTOR = 0.9
    NUM_AGENTS = 2
    ACTIONS = collect(2:100)

    return SimpleGame(
        DISCOUNT_FACTOR,
        collect(1:NUM_AGENTS),
        [ACTIONS for _ in 1:NUM_AGENTS],
        (a) -> get_reward_travelers(a)
    )
end
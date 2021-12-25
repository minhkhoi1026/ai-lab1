function is_win_over(a1::Symbol, a2::Symbol)
    r = false

    if a1 == :rock && a2 == :scissors
        r = true

    elseif a1 == :scissors && a2 == :paper
        r = true

    elseif a1 == :paper && a2 == :rock
        r = true
    end

    return r
end

function get_reward_rps(a)
    @assert(length(a) == 2)
    r = [-1, 1] # lose

    if a[1] == a[2] # draw
        r = [0, 0]

    elseif is_win_over(a[1], a[2]) # win
        r = [1, -1]
    end

    return r
end

function RockPaperScissors()
    DISCOUNT_FACTOR = 1.0
    NUM_AGENTS = 2
    ACTIONS = [:rock, :paper, :scissors]

    return SimpleGame(
        DISCOUNT_FACTOR,
        collect(1:NUM_AGENTS), # [1, 2]
        [ACTIONS for _ in 1:NUM_AGENTS], # [[:rock, :paper, :scissors], [:rock, :paper, :scissors]]
        (a) -> get_reward_rps(a) # [action1, action2] -> [int, int]
    )
end
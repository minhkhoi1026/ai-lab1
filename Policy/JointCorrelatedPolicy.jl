struct JointCorrelatedPolicy
    p::Dict

    function JointCorrelatedPolicy(p::Base.Generator)
        return JointCorrelatedPolicy(Dict(p))
    end

    function JointCorrelatedPolicy(d::Dict)
        return new(Dict(d))
    end
end

(π::JointCorrelatedPolicy)(a) = get(π.p, a, 0.0) # p.getOrDefault(ai, 0.0)

function (π::JointCorrelatedPolicy)()
    D = SetCategorical(collect(keys(π.p)), collect(values(π.p)))
    return rand(D)
end
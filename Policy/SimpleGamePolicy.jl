struct SimpleGamePolicy
    p::Dict

    function SimpleGamePolicy(p::Base.Generator)
        return SimpleGamePolicy(Dict(p))
    end

    function SimpleGamePolicy(d::Dict)
        vs = collect(values(d))
        vs ./= sum(vs)
        return new(Dict(k => v for (k,v) in zip(keys(d), vs)))
    end

    SimpleGamePolicy(ai) = new(Dict(ai => 1.0))
end

(πi::SimpleGamePolicy)(ai) = get(πi.p, ai, 0.0) # p.getOrDefault(ai, 0.0)

function (π::SimpleGamePolicy)()
    D = SetCategorical(collect(keys(π.p)), collect(values(π.p)))
    return rand(D)
end
using D3Trees

number = Vector([1])
children = Vector{Vector}()
text = Vector{String}()

# Action
FEED = 1
IGNORE = 2
SING = 3
Act = Dict(FEED => "FEED", IGNORE => "IGNORE", SING => "SING")

# Observation
CRYING = true
QUIET = false
Obs = Dict(CRYING => "Crying", QUIET => "Quiet")

function createTree(π, number::Array, children::Array, text::Array, observation::Bool)
    depth = number[1]
	if number[1] == 1
		o = ""
	else
    	o = Obs[observation]
	end
    push!(children, [])
    push!(text, o*"\n"*Act[π.a])
    if (length(π.subplans) == 0)
        return
    end
    
    number[1] += 1
    push!(children[depth], number[1])
    createTree(π.subplans[QUIET], number, children, text, QUIET)
    number[1] += 1
    push!(children[depth], number[1])
    createTree(π.subplans[CRYING], number, children, text, CRYING)
end

function drawConditionalPlanTree(π, number::Array, children::Array, text::Array, observation::Bool)
    createTree(π, number, children, text, observation)
    tree = D3Tree(children, 
        text = text,
        init_expand = 5)
    return tree
end
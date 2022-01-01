using D3Trees

number = Vector([1])
children = Vector{Vector}()
text = Vector{String}()
style = Vector{String}()

# Action
FEED = 1
IGNORE = 2
SING = 3
Act = Dict(FEED => "FEED", IGNORE => "IGNORE", SING => "SING")

# Observation
CRYING = true
QUIET = false
Obs = Dict(CRYING => "Crying", QUIET => "Quiet")

# Style
Sty = Dict(CRYING => "stroke:red", QUIET => "stroke:blue")

function createTree(π, number::Array, children::Array, text::Array, observation::Bool, style::Array)
    depth = number[1]
	if number[1] == 1
		o = ""
        s = ""
	else
    	o = Obs[observation]
        s = Sty[observation]
	end
    push!(children, [])
    push!(text, o*"\n"*Act[π.a])
    push!(style, s)
    if (length(π.subplans) == 0)
        return
    end
    
    number[1] += 1
    push!(children[depth], number[1])
    createTree(π.subplans[QUIET], number, children, text, QUIET, style)
    number[1] += 1
    push!(children[depth], number[1])
    createTree(π.subplans[CRYING], number, children, text, CRYING, style)
end

function drawConditionalPlanTree(π, number::Array, children::Array, text::Array, observation::Bool, style)
    createTree(π, number, children, text, observation, style)
    tree = D3Tree(children, 
        text = text,
        style = style,
        init_expand = 5)
    return tree
end
using Plots

HEIGHT = 500
WIDTH = 500
DIRECTION = [(+1, 0), (+1, -1), (0, -1), (-1, 0), (-1, +1), (0, +1)]

# Fine tuning for each case
DX = 0.0
DY = 0.4

function hex_to_pixel(hex::Tuple{Int, Int})
    x = hex[1] + 1 / 2 * hex[2]
    y = sqrt(3) /2 * hex[2]
    return (x, y)
end

function hexes_to_pixels(hexes::Array{Tuple{Int,Int}})
    hexes_pixel = Vector{Tuple{Float64, Float64}}()
    for i in hexes
        push!(hexes_pixel, hex_to_pixel(i))
    end
    return hexes_pixel
end

function normalize(hexes::Array{Tuple{Int,Int}}, hex::Tuple{Int,Int})
    hexes_pixel = hexes_to_pixels(hexes)
    hex_pixel = hex_to_pixel(hex)
    
    _max = -1

    for i in hexes_pixel
        _max = max(_max, i[1])
        _max = max(_max, i[2])
    end

    return (hex_pixel[1] / _max + DX), (hex_pixel[2] / _max + DY) 
end

function draw_hexgrid(hexes::Array{Tuple{Int,Int}}, MARKER_SIZE::Int)
    x = Vector{Float64}()
    y = Vector{Float64}()

    for hex in hexes
        hex_norm = normalize(hexes, hex)
        push!(x, hex_norm[1])
        push!(y, hex_norm[2])
    end

    p = scatter(x, y, m = (1.0, :hex, MARKER_SIZE), axis=nothing, legends=nothing, c=:white)
    plot!(p, size = (WIDTH, HEIGHT))
    xlims!(p, (-0.1, 1.1))
    ylims!(p, (-0.1, 1.1))
end

function draw_hexbin(plot::Plots.Plot, hexes::Array{Tuple{Int,Int}}, hex::Tuple{Int,Int}, 
    direct::Tuple{Int,Int}, color, MARKER_SIZE::Int)
    next_hex = (hex[1] + direct[1], hex[2] + direct[2])

    hex_norm = normalize(hexes, hex)
    next_hex_norm = normalize(hexes, next_hex)

    arrow_start = hex_norm
    arrow_end = (
        hex_norm[1] + (next_hex_norm[1] - hex_norm[1]) * 0.4,
        hex_norm[2] + (next_hex_norm[2] - hex_norm[2]) * 0.4)

    # Color the cell
    scatter!(
        plot, 
        [hex_norm[1]], 
        [hex_norm[2]], 
        m = (1.0, :hex, MARKER_SIZE), 
        c = color)

    # Draw the arrow
    plot!(
        plot, 
        [arrow_start[1], arrow_end[1]], 
        [arrow_start[2], arrow_end[2]], 
        arrow = true, 
        c = :black, 
        linewidth = 2)
    return plot
end
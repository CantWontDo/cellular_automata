package cellular_automata

import "core:fmt"
import "core:math"

Pixel :: struct
{
	x: int,
	y: int,
	index: int
}

// NOTE(rahul): Returning a value of -1 means the pixel is outside of world bounds.
init_pixel_coords :: proc(x: int, y: int, world_width: int, world_size: int, wrap_around: bool = false) -> (pixel: Pixel)
{
	
	wrap_x := x
	wrap_y := y

	world_height := world_size / world_width

	if wrap_around
	{
		if (wrap_x < 0) do wrap_x = world_width - 1 
		if (wrap_y < 0) do wrap_y = world_height - 1
		if (wrap_x > world_width - 1) do wrap_x = 0
		if (wrap_y > world_height - 1) do wrap_y = 0
	}
	else
	{
		wrap_x = math.clamp(wrap_x, 0, world_width - 1)
		wrap_y = math.clamp(wrap_y, 0, world_height - 1)
	}

	index := coord2index(wrap_x, wrap_y, world_width)

	if index < 0 || index > (world_size - 1)
	{
		pixel.index = -1
		fmt.printf("index %v out of range %v!\n", index, world_size - 1)
	}
	else
	{
		pixel.x = x
		pixel.y = y
		pixel.index = index
	}
	return pixel
}

// NOTE(rahul): Returning -1 means the index is out of world bounds.
init_pixel_index :: proc(index: int, world_width: int, world_size: int) -> (pixel: Pixel)
{
	if index < 0 || index > (world_size - 1)
	{
		pixel.index = -1
		fmt.printf("index %v out of range!\n", index)
	}
	else
	{
		pixel.x, pixel.y = index2Coord(index, world_width)
		pixel.index = index
	}
	return pixel
}
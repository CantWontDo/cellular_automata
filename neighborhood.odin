package pixel_sim

import "core:math"

Neighborhood :: struct
{
	me: Pixel,
	left: Pixel,
	up_left: Pixel,
	up: Pixel,
	up_right: Pixel,
	right: Pixel,
	down_right: Pixel,
	down: Pixel,
	down_left: Pixel,
}

wrap :: proc(val: int, max: int) -> (new_val: int)
{
	if val == -1
	{
		new_val = max
	}
	else if val == (max                                                      )
	{
		new_val = 0
	}
	else
	{
		new_val = val
	}
	return new_val
}

clamp :: proc(world: ^World, pixel: ^Pixel)
{
	pixel.x = math.clamp(pixel.x, 0, world.width)
	pixel.y = math.clamp(pixel.y, 0, world.height)

	pixel.index = coord2index(pixel.x, pixel.y, world.width)
}

get_neighborhood :: proc(world: ^World, pixel: ^Pixel) -> Neighborhood
{
	neighborhood: Neighborhood

	x := pixel.x
	y := pixel.y

	neighborhood.me = pixel^
	pixel_left 	   := init_pixel_coords(math.clamp(x - 1, 0, world.width), y, world.width, world.size)
	pixel_up_left    := init_pixel_coords(math.clamp(x - 1, 0, world.width), math.clamp(y - 1, 0, world.height), world.width, world.size)
	pixel_up 		   := init_pixel_coords(x, math.clamp(y - 1, 0, world.height), world.width, world.size)
	pixel_up_right   := init_pixel_coords(math.clamp(x + 1, 0, world.width), math.clamp(y - 1, 0, world.height), world.width, world.size)
	pixel_right 	   := init_pixel_coords(math.clamp(x + 1, 0, world.width), y, world.width, world.size)
	pixel_down_right := init_pixel_coords(math.clamp(x + 1, 0, world.width), math.clamp(y + 1, 0, world.height), world.width, world.size)
	pixel_down 	   := init_pixel_coords(x, math.clamp(y + 1, 0, world.height), world.width, world.size)
	pixel_down_left  := init_pixel_coords(math.clamp(x - 1, 0, world.width),  math.clamp(y + 1, 0, world.height), world.width, world.size)

	if pixel_left.index != -1
	{
		neighborhood.left = pixel_left
	}
	if pixel_right.index != -1
	{
		neighborhood.right = pixel_right
	}
	if pixel_up.index != -1
	{
		neighborhood.up = pixel_up
	}
	if pixel_down.index != -1
	{
		neighborhood.down = pixel_down
	}
	if pixel_up_left.index != -1
	{
		neighborhood.up_left = pixel_up_left
	}
	if pixel_up_right.index != -1
	{
		neighborhood.up_right = pixel_up_right
	}
	if pixel_down_left.index != -1
	{
		neighborhood.down_left = pixel_down_left
	}
	if pixel_down_right.index != -1
	{
		neighborhood.down_right = pixel_down_right
	}

	return neighborhood
}

get_neighborhood_wrap :: proc(world: ^World, pixel: ^Pixel) -> Neighborhood
{
	neighborhood: Neighborhood

	x := pixel.x
	y := pixel.y

	neighborhood.me = pixel^
	pixel_left 	   := init_pixel_coords(wrap(x - 1, world.width), y, world.width, world.size)
	pixel_up_left    := init_pixel_coords(wrap(x - 1, world.width), wrap(y - 1, world.height), world.width, world.size)
	pixel_up 		   := init_pixel_coords(x, wrap(y - 1, world.height), world.width, world.size)
	pixel_up_right   := init_pixel_coords(wrap(x + 1, world.width), wrap(y - 1, world.height), world.width, world.size)
	pixel_right 	   := init_pixel_coords(wrap(x + 1, world.width), y, world.width, world.size)
	pixel_down_right := init_pixel_coords(wrap(x+ 1, world.width), wrap(y + 1, world.height), world.width, world.size)
	pixel_down 	   := init_pixel_coords(x, wrap(y + 1, world.height), world.width, world.size)
	pixel_down_left  := init_pixel_coords(wrap(x - 1, world.width),  wrap(y + 1, world.height), world.width, world.size)

	if pixel_left.index != -1
	{
		neighborhood.left = pixel_left
	}
	if pixel_right.index != -1
	{
		neighborhood.right = pixel_right
	}
	if pixel_up.index != -1
	{
		neighborhood.up = pixel_up
	}
	if pixel_down.index != -1
	{
		neighborhood.down = pixel_down
	}
	if pixel_up_left.index != -1
	{
		neighborhood.up_left = pixel_up_left
	}
	if pixel_up_right.index != -1
	{
		neighborhood.up_right = pixel_up_right
	}
	if pixel_down_left.index != -1
	{
		neighborhood.down_left = pixel_down_left
	}
	if pixel_down_right.index != -1
	{
		neighborhood.down_right = pixel_down_right
	}

	return neighborhood
}


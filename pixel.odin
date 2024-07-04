package pixel_sim

import "core:fmt"

Pixel :: struct
{
	x: int,
	y: int,
	index: int
}

// NOTE(rahul): Returning a value of -1 means the pixel is outside of world bounds.
init_pixel_coords :: proc(x: int, y: int, world_width: int, world_size: int) -> (pixel: Pixel)
{
	index := coord2index(x, y, world_width)

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
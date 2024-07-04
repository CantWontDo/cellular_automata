package pixel_sim

import "core:math"

Neighborhood :: struct
{
	me: Pixel,
	down_right: Pixel,
	down_left: Pixel,
	up_right: Pixel,
	up_left: Pixel,
	up: Pixel,
	down: Pixel,
	right: Pixel,
	left: Pixel,
}

get_neighborhood :: proc(world: ^World, pixel: ^Pixel, wrap_around: bool = false) -> Neighborhood
{
	neighborhood: Neighborhood

	x := pixel.x
	y := pixel.y

	neighborhood.me = init_pixel_coords(x, y, world.width, world.size)

	neighbor := 0
	for row := (y - 1); row <= (y + 1); row += 1
	{
		for col := (x - 1); col <= (x + 1); col += 1
		{
			if col == x && row == y
			{
				continue
			}

			neighbor_col := col
			neighbor_row := row

			if wrap_around
			{
				if (neighbor_col < 0) do neighbor_col = world.width - 1 
				if (neighbor_row < 0) do neighbor_row = world.height - 1
				if (neighbor_col > world.width - 1) do neighbor_col = 0
				if (neighbor_row > world.height - 1) do neighbor_row = 0
			}
			else
			{
				neighbor_col = math.clamp(neighbor_col, 0, world.width - 1)
				neighbor_row = math.clamp(neighbor_row, 0, world.height - 1)
			}

			if row == y - 1
			{
				if col == x - 1
				{
					neighborhood.up_left = init_pixel_coords(col, row, world.width, world.size)
				}
				else if col == x 
				{

					neighborhood.up = init_pixel_coords(col, row, world.width, world.size)
				}
				else if col == x + 1
				{

					neighborhood.up_right = init_pixel_coords(col, row, world.width, world.size)
				}
			}
			else if row == y 
			{

				if col == x - 1
				{

					neighborhood.left = init_pixel_coords(col, row, world.width, world.size)
				}
				else if col == x + 1
				{
					
					neighborhood.right = init_pixel_coords(col, row, world.width, world.size)
				}
			}
			else if row == y + 1
			{

				if col == x - 1
				{

					neighborhood.down_left = init_pixel_coords(col, row, world.width, world.size)
				}
				else if col == x 
				{

					neighborhood.down = init_pixel_coords(col, row, world.width, world.size)
				}
				else if col == x + 1
				{
					
					neighborhood.down_right = init_pixel_coords(col, row, world.width, world.size)
				}
			}
		}
	}
	return neighborhood
}

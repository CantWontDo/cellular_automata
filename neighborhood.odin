package pixel_sim

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

get_neighborhood :: proc(world: ^World, pixel: ^Pixel) -> Neighborhood
{
	neighborhood: Neighborhood

	x := pixel.x
	y := pixel.y

	neighborhood.me = pixel^
	pix_left 	   := init_pixel_coords(x - 1, y, world.width, world.size)
	pix_up_left    := init_pixel_coords(x - 1, y - 1, world.width, world.size)
	pix_up 		   := init_pixel_coords(x, y - 1, world.width, world.size)
	pix_up_right   := init_pixel_coords(x + 1, y - 1, world.width, world.size)
	pix_right 	   := init_pixel_coords(x + 1, y, world.width, world.size)
	pix_down_right := init_pixel_coords(x + 1, y + 1, world.width, world.size)
	pix_down 	   := init_pixel_coords(x, y + 1, world.width, world.size)
	pix_down_left  := init_pixel_coords(x - 1, y + 1, world.width, world.size)

	if pix_left.index != -1
	{
		neighborhood.left = pix_left
	}
	if pix_right.index != -1
	{
		neighborhood.right = pix_right
	}
	if pix_up.index != -1
	{
		neighborhood.up = pix_up
	}
	if pix_down.index != -1
	{
		neighborhood.down = pix_down
	}
	if pix_up_left.index != -1
	{
		neighborhood.up_left = pix_up_left
	}
	if pix_up_right.index != -1
	{
		neighborhood.up_right = pix_up_right
	}
	if pix_down_left.index != -1
	{
		neighborhood.down_left = pix_down_left
	}
	if pix_down_right.index != -1
	{
		neighborhood.down_right = pix_down_right
	}

	return neighborhood
}


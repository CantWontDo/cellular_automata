package pixel_sim
import rl "vendor:raylib"

COLOR_ON :: rl.GRAY
COLOR_OFF :: rl.BLACK

Life :: struct
{
	on: bool,
	next: bool
}

life_world: []Life

life_create_world :: proc(world_size: int)
{
	life_world = make([]Life, world_size)
}

life_init_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	life := life_world[pixel.index]
}

life_select_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	life := &(life_world[pixel.index])
	life.on = true	
	life.next = true
}

life_deselect_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	life := &(life_world[pixel.index])
	life.next = false
	life.on = false
}

neighbor_count :: proc (neighborhood: ^Neighborhood) -> (neighbor: int)
{
	pix_left 	   := life_world[neighborhood.left.index]
	pix_up_left    := life_world[neighborhood.up_left.index]
	pix_up 		   := life_world[neighborhood.up.index]
	pix_up_right   := life_world[neighborhood.up_right.index]
	pix_right 	   := life_world[neighborhood.right.index]
	pix_down_right := life_world[neighborhood.down_right.index]
	pix_down 	   := life_world[neighborhood.down.index]
	pix_down_left  := life_world[neighborhood.down_left.index]

	neighbor += int(pix_left.on)
	neighbor += int(pix_up_left.on)
	neighbor += int(pix_up.on)
	neighbor += int(pix_up_right.on)
	neighbor += int(pix_right.on)
	neighbor += int(pix_down_right.on)
	neighbor += int(pix_down.on)
	neighbor += int(pix_down_left.on)

	return neighbor
}

life_tick_pixel :: proc(world: ^World, pixel: ^Pixel)
{	
	neighborhood := get_neighborhood_wrap(world, pixel)
	neighbor_count := neighbor_count(&neighborhood)

	life := life_world[pixel.index]

	if life.on
	{
		if neighbor_count < 2
		{
			life.next = false
		}
		else if neighbor_count == 2 || neighbor_count == 3
		{
			life.next = true
		}
		else if neighbor_count > 3
		{
			life.next = false
		}
	}
	else
	{
		if neighbor_count == 3
		{
			life.next = true
		}
	}
}

life_update_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	life := life_world[pixel.index]
	life.on = life.next
}

life_draw_pixel :: proc(pixel: ^Pixel)
{
	life := &life_world[pixel.index]

	color := life.on ? COLOR_ON : COLOR_OFF
	draw(pixel, color)
}

life_delete_world :: proc()
{
	delete(life_world)
}

life_reset_world :: proc()
{
	for &life in life_world
	{
		life.next = false
	}
}
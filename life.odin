package cellular_automata
import rl "vendor:raylib"

import "core:fmt"
import "core:testing"

COLOR_ON :: rl.GRAY

Life :: struct
{
	on: bool,
	next: bool
}

life_world: []Life

life_create_world :: proc(world: ^World)
{
	if life_world == nil
	{
		life_world = make([]Life, world.size)
	}
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
	neighborhood := get_neighborhood(world, pixel, true)
	neighbor_count := neighbor_count(&neighborhood)

	life := &life_world[pixel.index]

	if life.on
	{
		if neighbor_count < 2
		{
			life.next = false
		}
		if neighbor_count == 2 || neighbor_count == 3
		{
			life.next = true
		}
		if neighbor_count > 3
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
	life := &life_world[pixel.index]
	life.on = life.next
}

life_draw_pixel :: proc(pixel: ^Pixel)
{
	life := &life_world[pixel.index]

	if life.on
	{
		draw(pixel, COLOR_ON)
	}
	else
	{
		draw(pixel, COLOR_BACKGROUND)
	}

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
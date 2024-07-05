package cellular_automata
import rl "vendor:raylib"

import "core:math/rand"
import "core:fmt"

COLOR_SAND :: rl.Color{255, 211, 51, 255}

Sand :: struct
{
	on: bool,
	next: bool,
}

sand_world: []Sand

sand_create_world :: proc(world: ^World)
{
	if sand_world == nil
	{
		sand_world = make([]Sand, world.size)

		for index in 0..<world.size
		{
			pixel := init_pixel_index(index, world.width, world.size)
			world.init_pixel(world, &pixel)
		}
	}
}

sand_init_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	sand := sand_world[pixel.index]
	sand.next = true
}

sand_select_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	sand := &(sand_world[pixel.index])
	sand.next = true
}

sand_deselect_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	sand := &(sand_world[pixel.index])
	sand.next = false
	sand.on = false
}

sand_tick_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	sand := &sand_world[pixel.index]
	neighborhood := get_neighborhood(world, pixel)

	down := &sand_world[neighborhood.down.index]

	if sand.on
	{
		if !down.on && neighborhood.down.index != -1
		{
			down.next = true
			sand.on = false
			sand.next = false
		}
	}
}

sand_update_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	sand := &sand_world[pixel.index]
	sand.on = sand.next
}

sand_draw_pixel :: proc(pixel: ^Pixel)
{
	sand := &sand_world[pixel.index]

	if sand.on
	{
		draw(pixel, COLOR_SAND)
	}
	else
	{
		draw(pixel, COLOR_BACKGROUND)
	}
}

sand_delete_world :: proc()
{
	delete(sand_world)
}

sand_reset_world :: proc()
{
	for &sand in sand_world
	{
		sand.next = false
		sand.on = false
	}
}
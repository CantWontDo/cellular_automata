package cellular_automata
import rl "vendor:raylib"

import "core:math"
import "core:math/rand"

import "core:fmt"

AntSpot :: struct
{
	is_white: bool,
	will_flip: bool,
}

ant_world: []AntSpot

ant_pixel: Pixel

ant_direction: int

ant_create_world :: proc(world: ^World)
{
	if ant_world == nil
	{
		ant_world = make([]AntSpot, world.size)
		for index in 0..<world.size
		{
			pixel := init_pixel_index(index, world.width, world.size)
			world.init_pixel(world, &pixel)
		}
	}
}

ant_init_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	ant_spot := &ant_world[pixel.index]
	if pixel.x == world.width / 2 && pixel.y == world.height / 2
	{
		ant_pixel = pixel^
		ant_direction = int(rand.float32() * 4) + 1
		if ant_direction == 5
		{
			ant_direction = 1
		}
		fmt.println(ant_direction)
	}
}

ant_select_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	// do nothing
}

ant_deselect_pixel :: proc(pixel: ^Pixel, arg1: int)
{	
	// do nothing
}

turn_left :: proc()
{
	// 1: Up, 2: Right, 3: Down, 4: Left
	ant_direction -= 1

	if ant_direction < 1
	{
		// This lets me reverse directions by adding 2.
		ant_direction += 4
	}
}

turn_right :: proc()
{
	// 1: Up, 2: Right, 3: Down, 4: Left
	ant_direction += 1

	if ant_direction > 4
	{		
		// This lets me reverse directions by adding 2.
		ant_direction -= 4
	}
}

move_ant :: proc(world: ^World)
{
	// 1: Up, 2: Right, 3: Down, 4: Left
	
	offset_y, offset_x := 0, 0
	switch ant_direction
	{
		case 1: 
		{
			offset_y = -1
		}
		case 2: 
		{
			offset_x = 1
		}
		case 3: 
		{
			offset_y = 1
		}
		case 4: 
		{
			offset_x = -1
		}
	}

	ant_pixel = init_pixel_coords(ant_pixel.x + offset_x, ant_pixel.y + offset_y, world.width, world.size, true)

}

ant_tick_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	ant_spot := &ant_world[pixel.index]
	if ant_pixel.index == pixel.index
	{
		ant_spot.will_flip = true

		if ant_spot.is_white
		{
			turn_left()
		}
		else
		{
			turn_right()
		}
		move_ant(world)
	}
	else
	{
		ant_spot.will_flip = false
	}
}

ant_update_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	ant_spot := &ant_world[pixel.index]

	if ant_spot.will_flip
	{
		ant_spot.is_white = !ant_spot.is_white
	}
}

ant_draw_pixel :: proc(pixel: ^Pixel)
{
	ant_spot := &ant_world[pixel.index]

	if pixel.index == ant_pixel.index
	{
		draw(pixel, rl.RED)
	}
	if ant_spot.is_white
	{
		draw(pixel, rl.GRAY)
	}
	else
	{
		draw(pixel, COLOR_BACKGROUND)
	}
}

ant_delete_world :: proc()
{
	delete(ant_world)
}

ant_reset_world :: proc()
{
	for &ant_spot in ant_world
	{
		ant_spot.is_white = false
	}
}
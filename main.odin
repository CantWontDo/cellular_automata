package pixel_sim

import "core:fmt"
import "core:math/rand"
import "core:math"
import rl "vendor:raylib"
import "core:time"

PIXEL_SCALE :: 5

SPEED_0 :: 1
SPEED_1 :: 15
SPEED_2 :: 30
SPEED_3 :: 60
SPEED_4 :: 120
SPEED_5 :: 240
SPEED_6 :: 480

COLOR_CURSOR :: rl.WHITE

select_pixels :: proc(world: ^World, radius: int, arg1: int, deselect: bool)
{
 	index, succeeded := mouse2index(world)

 	if succeeded
 	{	
		pixel := init_pixel_index(index, world.width, world.size)
		for other_index in 0..<world.size
		{
			other_pixel := init_pixel_index(other_index, world.width, world.size)
			dist := world_get_dist(&pixel, &other_pixel)
			if dist <= radius
			{
				if deselect
				{
					world.deselect_pixel(&other_pixel, arg1)
				}
				else
				{
					world.select_pixel(&other_pixel, arg1)
				}	
			}
		}
	}
}

get_speed :: proc(tick_level: int) -> int
{
	switch tick_level
	{
		case 0:
		{
			return SPEED_0
		}
		case 1:
		{
			return SPEED_1
		}
		case 2:
		{
			return SPEED_2
		}
		case 3:
		{
			return SPEED_3
		}
		case 4:
		{
			return SPEED_4
		}
		case 5:
		{
			return SPEED_5
		}
		case 6:
		{
			return SPEED_6
		}
	}
	return 0
}

get_type :: proc(level: int) -> WorldType
{
	switch level
	{
		case 0: return .Paint
		case 1: return .Life
		case 2: return .Ant
		case 3: return .Sand
	}
	return .Paint
}

draw_mouse :: proc(world: ^World, radius: int)
{
 	index, succeeded := mouse2index(world)

 	if succeeded
 	{	
		pixel := init_pixel_index(index, world.width, world.size)
		for other_index in 0..<world.size
		{
			other_pixel := init_pixel_index(other_index, world.width, world.size)
			dist := world_get_dist(&pixel, &other_pixel)
			if dist == radius
			{
				draw(&other_pixel, COLOR_CURSOR)
			}
		}
	}
}

draw :: proc(pixel: ^Pixel, color: rl.Color)
{
	rl.DrawRectangleV({f32(pixel.x), f32(pixel.y)} * PIXEL_SCALE, {PIXEL_SCALE, PIXEL_SCALE}, color)
}

main :: proc()
{
	world: World 

	rl.DisableCursor()
	rl.HideCursor()

	width : i32 = 1280
	height : i32 = 720

	rl.InitWindow(width, height, "Hello")
	init_world(&world, int(width), int(height))

	tick_counter: int

	paused: bool

	frames_to_tick := 60

	tick_level := 0

	radius := 0

	radius_level := 0

	type := 3

	for !rl.WindowShouldClose()
	{
		rl.BeginDrawing()
		rl.ClearBackground({12, 10, 16, 255})

		if rl.IsKeyPressed(.SPACE)
		{
			paused = !paused
		}

		if rl.IsKeyPressed(.DOWN)
		{
			tick_level -= 1

			tick_level = math.clamp(tick_level, 0, 6)
			frames_to_tick = get_speed(tick_level)
			fmt.printf("tick_level: %v, frames_to_tick: %v\n", tick_level, frames_to_tick)
		}
		if rl.IsKeyPressed(.UP)
		{
			tick_level += 1

			tick_level = math.clamp(tick_level, 0, 6)
			frames_to_tick = get_speed(tick_level)
			fmt.printf("tick_level: %v, frames_to_tick: %v\n", tick_level, frames_to_tick)
		}

		radius += int(rl.GetMouseWheelMove())
		if radius < 0
		{
			radius = 0
		}

		if rl.IsKeyPressed(.RIGHT)
		{
			radius += 1
		}
		if rl.IsKeyPressedRepeat(.RIGHT)
		{
			radius += 4
		}

		last_type := type
		if rl.IsKeyPressed(.LEFT_SHIFT)
		{
			type += 1
			if type > len(WorldType)
			{
				type = 1
			}
		}

		if last_type != type
		{
			new_type := get_type(type)
			change_world(&world, new_type)
		}

		if rl.IsMouseButtonDown(.LEFT)
		{
			select_pixels(&world, radius, 255, false)
		}
		if rl.IsMouseButtonDown(.RIGHT) 
		{
			select_pixels(&world, radius, 255, true)
		}

		if rl.IsKeyPressed(.BACKSPACE)
		{
			world.reset_world()
		}

		if !paused
		{
			tick_counter += 1
		}

		if tick_counter >= frames_to_tick
		{
			start := time.now()
			for index in 0..<world.size
			{
				pixel := init_pixel_index(index, world.width, world.size)
				world.tick_pixel(&world, &pixel)
			}
			end := time.now()

			ms := (end._nsec - start._nsec) / 1000
			fmt.printf("ms to tick: %v\n", ms)
			tick_counter = 0
		}

		start := time.now()
		for index in 0..<world.size {
			pixel := init_pixel_index(index, world.width, world.size)
			world.update_pixel(&world, &pixel)
			world.draw_pixel(&pixel)
		}	
		end := time.now()
		ms := (end._nsec - start._nsec) / 1000
		if tick_counter == 0
		{
			fmt.printf("ms to update and draw: %v\n", ms)
		}
		draw_mouse(&world, radius)	

		rl.EndDrawing()
	}
}

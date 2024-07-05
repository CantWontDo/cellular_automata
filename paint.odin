package cellular_automata
import rl "vendor:raylib"

import "core:math/rand"

COLOR_CLEAR :: rl.Color{0, 0, 0, 0}

Paint :: struct
{
	color: rl.Color
}

paint_world: []Paint

paint_create_world :: proc(world: ^World)
{
	if paint_world == nil
	{
		paint_world = make([]Paint, world.size)
	}
}

paint_init_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	paint := paint_world[pixel.index]

	paint.color = COLOR_CLEAR
}

paint_select_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	paint := &(paint_world[pixel.index])
	paint.color = rl.RED
}

paint_deselect_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	paint := &(paint_world[pixel.index])
	paint.color = COLOR_BACKGROUND
}

paint_tick_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	// nothing really to do here :/
}

paint_update_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	paint := paint_world[pixel.index]
}

paint_draw_pixel :: proc(pixel: ^Pixel)
{
	paint := &paint_world[pixel.index]

	draw(pixel, paint.color)
}

paint_delete_world :: proc()
{
	delete(paint_world)
}

paint_reset_world :: proc()
{
	for &paint in paint_world
	{
		paint.color = rl.BLACK
	}
}
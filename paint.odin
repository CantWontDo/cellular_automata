package pixel_sim
import rl "vendor:raylib"

import "core:math/rand"
import "core:fmt"

Paint :: struct
{
	color: rl.Color
}

paint_world: []Paint

paint_create_world :: proc(world_size: int)
{
	paint_world = make([]Paint, world_size)
}

paint_init_pixel :: proc(world: ^World, pixel: ^Pixel)
{
	paint := paint_world[pixel.index]

	paint.color = rl.BLACK
}

paint_select_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	paint := &(paint_world[pixel.index])
	paint.color = rl.RED
}

paint_deselect_pixel :: proc(pixel: ^Pixel, arg1: int)
{
	paint := &(paint_world[pixel.index])
	paint.color = rl.BLACK
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
	fmt.println("deleted paint pixel")
	delete(paint_world)
}
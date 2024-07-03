package pixel_sim
import "core:fmt"

CreateWorldCallback :: proc(world_size: int)
InitPixelCallback ::  proc(world: ^World, pixel: ^Pixel)
SelectPixelCallback :: proc(pixel: ^Pixel, arg1: int)
DeselectPixelCallback :: proc(pixel: ^Pixel, arg1: int)
TickPixelCallback :: proc(world: ^World, pixel: ^Pixel)
UpdatePixelCallback :: proc(world: ^World, pixel: ^Pixel)
DrawPixelCallback :: proc(pixel: ^Pixel)
DeleteWorldCallback :: proc()

WorldType :: enum
{
	Paint	
}

World :: struct
{
	width: int,
	height: int,
	size: int,
	init_pixel: InitPixelCallback,
	tick_pixel: TickPixelCallback,
	update_pixel: UpdatePixelCallback,
	draw_pixel: DrawPixelCallback,
	select_pixel: SelectPixelCallback,
	deselect_pixel: DeselectPixelCallback,
	create_world: CreateWorldCallback,
	delete_world: DeleteWorldCallback
}

init_world :: proc(world: ^World, width: int = 1280, height: int = 720)
{
	world.width = width / PIXEL_SCALE
	world.height = height / PIXEL_SCALE

	world.size = world.width * world.height 

	if world.size == 0
	{
		world.size = 1
	}

	change_world(world, .Paint, true)

	for index in 0..<world.size
	{
		pixel := init_pixel_index(index, world.width, world.size)
		world.init_pixel(world, &pixel)
	}
}

change_world :: proc(world: ^World, type: WorldType, first_time: bool = false)
{
	if !first_time
	{
		world.delete_world()
	}	
	switch type
	{
		case .Paint:
		{
			world.create_world = paint_create_world
			world.init_pixel = paint_init_pixel
			world.select_pixel = paint_select_pixel
			world.deselect_pixel = paint_deselect_pixel
			world.tick_pixel = paint_tick_pixel
			world.update_pixel = paint_update_pixel
			world.draw_pixel = paint_draw_pixel
			world.delete_world = paint_delete_world
		}
	}

	world.create_world(world.size)
}

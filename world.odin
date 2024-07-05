package cellular_automata
import "core:fmt"

CreateWorldCallback :: proc(world: ^World)
InitPixelCallback ::  proc(world: ^World, pixel: ^Pixel)
SelectPixelCallback :: proc(pixel: ^Pixel, arg1: int)
DeselectPixelCallback :: proc(pixel: ^Pixel, arg1: int)
TickPixelCallback :: proc(world: ^World, pixel: ^Pixel)
UpdatePixelCallback :: proc(world: ^World, pixel: ^Pixel)
DrawPixelCallback :: proc(pixel: ^Pixel)
DeleteWorldCallback :: proc()
ResetWorldCallback :: proc()

WorldType :: enum
{
	Paint,
	Life,
	Ant,
	Sand
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
	delete_world: DeleteWorldCallback,
	reset_world: ResetWorldCallback
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

	change_world(world, .Sand)

	for index in 0..<world.size
	{
		pixel := init_pixel_index(index, world.width, world.size)
		world.init_pixel(world, &pixel)
	}
}

change_world :: proc(world: ^World, type: WorldType)
{
	fmt.println(type)
	switch type
	{
		case .Paint:
		{
			world.create_world =   paint_create_world
			world.init_pixel =     paint_init_pixel
			world.select_pixel =   paint_select_pixel
			world.deselect_pixel = paint_deselect_pixel
			world.tick_pixel =     paint_tick_pixel
			world.update_pixel =   paint_update_pixel
			world.draw_pixel =     paint_draw_pixel
			world.delete_world =   paint_delete_world
			world.reset_world =    paint_reset_world
		}
		case .Life:
		{
			world.create_world =   life_create_world
			world.init_pixel =     life_init_pixel
			world.select_pixel =   life_select_pixel
			world.deselect_pixel = life_deselect_pixel
			world.tick_pixel =     life_tick_pixel
			world.update_pixel =   life_update_pixel
			world.draw_pixel =     life_draw_pixel
			world.delete_world =   life_delete_world
			world.reset_world =    life_reset_world
		}
		case .Ant:
		{
			world.create_world =   ant_create_world
			world.init_pixel =     ant_init_pixel
			world.select_pixel =   ant_select_pixel
			world.deselect_pixel = ant_deselect_pixel
			world.tick_pixel =     ant_tick_pixel
			world.update_pixel =   ant_update_pixel
			world.draw_pixel =     ant_draw_pixel
			world.delete_world =   ant_delete_world
			world.reset_world =    ant_reset_world
		}
		case .Sand:
		{
			world.create_world =   sand_create_world
			world.init_pixel =     sand_init_pixel
			world.select_pixel =   sand_select_pixel
			world.deselect_pixel = sand_deselect_pixel
			world.tick_pixel =     sand_tick_pixel
			world.update_pixel =   sand_update_pixel
			world.draw_pixel =     sand_draw_pixel
			world.delete_world =   sand_delete_world
			world.reset_world =    sand_reset_world
		}
	}

	world.create_world(world)
}

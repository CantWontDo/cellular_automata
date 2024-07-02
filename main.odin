package pixel_sim

import "core:fmt"
import "core:math/rand"
import "core:math"
import rl "vendor:raylib"



PIXEL_SCALE :: 10

SPEED_0 :: 1
SPEED_1 :: 15
SPEED_2 :: 30
SPEED_3 :: 60
SPEED_4 :: 120
SPEED_5 :: 240
SPEED_6 :: 480

SIZE_0 :: 0
SIZE_1 :: 1
SIZE_2 :: 2
SIZE_3 :: 3
SIZE_4 :: 4
SIZE_5 :: 5
SIZE_6 :: 10
SIZE_7 :: 20

COLOR_ON :: rl.GRAY
COLOR_OFF :: rl.BLACK

Pixel :: struct
{
	color : rl.Color,
	x: int,
	y: int,
	on: bool,
	next: bool
}

World :: struct
{
	pixels: []Pixel,
	width: int,
	height: int,
	size: int
}

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

coord2index :: proc(x: int, y: int, width: int) -> int
{
	return (y * width) + x
}

index2y :: proc(index: int, width: int) -> int
{
	return index / width
}

index2x :: proc(index: int width: int) -> int
{
	return index % width
}

index2Coord :: proc(index: int, width: int) -> (x: int, y: int)
{
	return (index % width), (index / width)
}

initworld :: proc(world: ^World, width: int = 1280, height: int = 720)
{
	world.width = width
	world.height = height

	world.size = world.width * world.height 

	if world.size == 0
	{
		world.size = 1
	}

	world.pixels = make([]Pixel, world.size)

	for &pixel, index in world.pixels
	{
		initpix(&pixel, index % world.width, index / world.width)
	}
}

mouse2world :: proc() -> (x: int, y: int)
{
	mouse_coords := rl.GetMousePosition()
	return int(mouse_coords.x) / PIXEL_SCALE, int(mouse_coords.y) / PIXEL_SCALE
}

mouse2worldvec :: proc() -> rl.Vector2
{
	mouse_coords := rl.GetMousePosition()
	return {f32(int(mouse_coords.x) / PIXEL_SCALE), f32(int(mouse_coords.y) / PIXEL_SCALE)}
}

world_get_dist :: proc(pixel: ^Pixel, other_pixel: ^Pixel) -> int
{
	delta_x := other_pixel.x - pixel.x
	delta_y := other_pixel.y - pixel.y

	return int(math.sqrt(f32((delta_x * delta_x) + (delta_y * delta_y))))
}

mouse2index :: proc(world: ^World) -> (int, bool)
{
	if rl.CheckCollisionPointRec(rl.GetMousePosition(), {0, 0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())})
	{
		x, y := mouse2world()

		x = math.clamp(x, 0, world.width)
		y = math.clamp(y, 0, world.height)

		index := coord2index(x, y, world.width)

		index = math.clamp(index, 0, world.size - 1)

		return index, true
	}

	return -1, false
}

snap2world :: proc(x: f32, y: f32) -> rl.Vector2
{
	return {math.floor(x / PIXEL_SCALE), math.floor(y / PIXEL_SCALE)}
}

get_neighborhood :: proc(world: ^World, pixel: ^Pixel) -> Neighborhood
{
	neighborhood: Neighborhood

	x := pixel.x
	y := pixel.y

	index := coord2index(x, y, world.width)

	left := -1
	right := 1
	up := -world.width
	down := world.width

	neighborhood.me = pixel^
	pix_left 	   := index + left
	pix_up_left    := index + left + up
	pix_up 		   := index + up
	pix_up_right   := index + right + up
	pix_right 	   := index + right
	pix_down_right := index + right + down
	pix_down 	   := index + down
	pix_down_left  := index + left + down

	if pix_left >= 0 && pix_left <= (world.size - 1) && index2x(pix_left, world.width) == (x + left)
	{
		neighborhood.left = world.pixels[pix_left]
	}
	if pix_right >= 0 && pix_right <=(world.size - 1) && index2x(pix_right, world.width) == (x + right)
	{
		neighborhood.right = world.pixels[pix_right]
	}
	if pix_up >= 0 && pix_up <= (world.size - 1) && index2y(pix_up, world.width) == (y - 1)
	{
		neighborhood.up = world.pixels[pix_up]
	}
	if pix_down >= 0 && pix_down <=(world.size - 1) && index2y(pix_down, world.width) == (y + 1)
	{
		neighborhood.down = world.pixels[pix_down]
	}
	if pix_up_left >= 0 && pix_up_left <= (world.size - 1) && index2y(pix_up_left, world.width) == (y - 1) && index2x(pix_up_left, world.width) == (x + left)
	{
		neighborhood.up_left = world.pixels[pix_up_left]
	}
	if pix_up_right >= 0 && pix_up_right <= (world.size - 1) && index2y(pix_up_right, world.width) == (y - 1) && index2x(pix_up_right, world.width) == (x + right)
	{
		neighborhood.up_right = world.pixels[pix_up_right]
	}
	if pix_down_left >= 0 && pix_down_left <= (world.size - 1) && index2y(pix_down_left, world.width) == (y + 1) && index2x(pix_down_left, world.width) == (x + left)
	{
		neighborhood.down_left = world.pixels[pix_down_left]
	}
	if pix_down_right >= 0 && pix_down_right <= (world.size - 1) && index2y(pix_down_right, world.width) == (y + 1) && index2x(pix_down_right, world.width) == (x + right)
	{
		neighborhood.down_right = world.pixels[pix_down_right]
	}

	return neighborhood
}

neighbor_count :: proc(neighborhood: ^Neighborhood) -> int
{
	neighbors: int

	neighbors += int(neighborhood.up.on)
	neighbors += int(neighborhood.up_left.on)
	neighbors += int(neighborhood.up_right.on)
	neighbors += int(neighborhood.right.on)
	neighbors += int(neighborhood.down_right.on)
	neighbors += int(neighborhood.down.on)
	neighbors += int(neighborhood.down_left.on)
	neighbors += int(neighborhood.left.on)

	return neighbors
}

initpix :: proc(pixel: ^Pixel, x: int, y: int)
{
	pixel.color = rl.BLACK
	pixel.x = x
	pixel.y = y

}

select_pixels :: proc(world: ^World, radius: int, live: bool = true)
{

 	index, succeeded := mouse2index(world)

 	if succeeded
 	{
		pix: ^Pixel = &world.pixels[index]	
		for &other_pixel in world.pixels
		{
			if world_get_dist(pix, &other_pixel) <= radius
			{
				other_pixel.next = live
			}
		}
	}
}

tickpix :: proc(world: ^World, pixel: ^Pixel)
{
	// TODO(rahul): add options for sim

	// Flood Fill
	 neighborhood := get_neighborhood(world, pixel)
	// if (neighborhood.up.on ||
	// 	neighborhood.up_right.on ||
	// 	neighborhood.right.on ||
	// 	neighborhood.down_right.on ||
	// 	neighborhood.down.on ||
	// 	neighborhood.down_left.on ||
	// 	neighborhood.left.on ||
	// 	neighborhood.up_left.on)
	// {
	// 	pixel.next = true
	// }
	// else if (!pixel.on)
	// {
	// 	pixel.next = false
	// }

	neighbors := neighbor_count(&neighborhood)

	if pixel.on
	{
		if neighbors < 2
		{
			pixel.next = false
		}
		else if neighbors == 2 || neighbors == 3
		{
			pixel.next = true
		}
		else if neighbors > 3
		{
			pixel.next = false
		}
	}
	else
	{
		if neighbors == 3
		{
			pixel.next = true
		}
	}
}

updatepix :: proc(pixel: ^Pixel)
{
	pixel.on = pixel.next
}

drawpix :: proc(pixel: ^Pixel)
{	if pixel.on
	{
		pixel.color = COLOR_ON
	}
	else
	{
		pixel.color = COLOR_OFF
	}

	rl.DrawRectangleV({f32(pixel.x), f32(pixel.y)} * PIXEL_SCALE, {PIXEL_SCALE, PIXEL_SCALE}, pixel.color)
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

get_radius :: proc(radius_level: int) -> int
{
	switch radius_level
	{
		case 0:
		{
			return SIZE_0
		}
		case 1:
		{
			return SIZE_1
		}
		case 2:
		{
			return SIZE_2
		}
		case 3:
		{
			return SIZE_3
		}
		case 4:
		{
			return SIZE_4
		}
		case 5:
		{
			return SIZE_5
		}
		case 6:
		{
			return SIZE_6
		}
		case 7:
		{
			return SIZE_7
		}
	}
	return 0
}

drawmouse :: proc(world: ^World, radius: int, color: rl.Color = rl.WHITE)
{
	index, succeeded := mouse2index(world)

 	if succeeded
 	{
		pix: ^Pixel = &world.pixels[index]	
		for &other_pixel in world.pixels
		{
			if world_get_dist(pix, &other_pixel) <= radius
			{
				rl.DrawRectangleV({f32(other_pixel.x), f32(other_pixel.y)} * PIXEL_SCALE, {PIXEL_SCALE, PIXEL_SCALE}, color)
			}
		}
	}
}

main :: proc()
{
	world: World 
	initworld(&world, 1280 / PIXEL_SCALE, 720 / PIXEL_SCALE)	

	rl.DisableCursor()
	rl.InitWindow(1280, 720, "Hello")

	tick_counter: int

	paused: bool

	frames_to_tick := 60

	tick_level := 3

	radius := 0

	radius_level := 0

	for !rl.WindowShouldClose()
	{
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		if rl.IsMouseButtonDown(.LEFT)
		{
			select_pixels(&world, radius)
		}
		else if rl.IsMouseButtonDown(.RIGHT)
		{
			select_pixels(&world, radius, false)
		}

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

		if rl.IsKeyPressed(.LEFT)
		{
			radius_level -= 1

			radius_level = math.clamp(radius_level, 0, 6)
			radius = get_radius(radius_level)
			fmt.printf("radius_level: %v, radius: %v\n", radius_level, radius)
		}
		if rl.IsKeyPressed(.RIGHT)
		{
			radius_level += 1

			radius_level = math.clamp(radius_level, 0, 6)
			radius = get_radius(radius_level)
			fmt.printf("radius: %v, radius: %v\n", radius_level, radius)
		}

		if !paused
		{
			tick_counter += 1
		}

		if tick_counter >= frames_to_tick
		{
			for &pixel in world.pixels
			{
				tickpix(&world, &pixel)
			}
			tick_counter = 0
		}

		for &pixel in world.pixels
		{
			updatepix(&pixel)
			drawpix(&pixel)
		}	

		drawmouse(&world, radius)
		rl.EndDrawing()
	}
}

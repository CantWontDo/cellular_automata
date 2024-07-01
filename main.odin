package chess

import "core:fmt"
import "core:math/rand"
import "core:math"
import rl "vendor:raylib"
import "core:os"

PIXEL_SCALE :: 10

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

mouse2world :: proc(mouseCoords: rl.Vector2, world: ^World) -> (x: int, y: int)
{
	return int(mouseCoords.x) / PIXEL_SCALE, int(mouseCoords.y) / PIXEL_SCALE
}

snap2world :: proc(x: f32, y: f32) -> rl.Vector2
{
	return {math.floor(x / PIXEL_SCALE), math.floor(y / PIXEL_SCALE)}
}

get_neighborhood :: proc(world: ^World, pixel: ^Pixel) -> Neighborhood
{
	// TODO(rahul): Fix wrap around.

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

	if (pix_left >= 0 && pix_left <= (world.size - 1))
	{
		neighborhood.left = world.pixels[pix_left]
	}
	if (pix_right >= 0 && pix_right <=(world.size - 1))
	{
		neighborhood.right = world.pixels[pix_right]
	}
	if (pix_up >= 0 && pix_up <= (world.size - 1))
	{
		neighborhood.up = world.pixels[pix_up]
	}
	if (pix_down >= 0 && pix_down <=(world.size - 1))
	{
		neighborhood.down = world.pixels[pix_down]
	}
	if (pix_up_left >= 0 && pix_up_left <= (world.size - 1))
	{
		neighborhood.up_left = world.pixels[pix_up_left]
	}
	if (pix_up_right >= 0 && pix_up_right <= (world.size - 1))
	{
		neighborhood.up_right = world.pixels[pix_up_right]
	}
	if (pix_down_left >= 0 && pix_down_left <= (world.size - 1))
	{
		neighborhood.down_left = world.pixels[pix_down_left]
	}
	if (pix_down_right >= 0 && pix_down_right <= (world.size - 1))
	{
		neighborhood.down_right = world.pixels[pix_down_right]
	}

	return neighborhood
}

initpix :: proc(pixel: ^Pixel, x: int, y: int)
{
	pixel.color = rl.BLACK
	pixel.x = x
	pixel.y = y
}

updateworld :: proc(world: ^World)
{
	x, y := mouse2world(rl.GetMousePosition(), world)

	index := coord2index(x, y, world.width)

	pix: ^Pixel = &world.pixels[index]

	mousepix(pix)
}

mousepix :: proc(pixel: ^Pixel)
{
	pixel.next = true
}

updatepix :: proc(world: ^World, pixel: ^Pixel)
{
	// TODO(rahul): Fix weird bug which causes holes.
	neighborhood := get_neighborhood(world, pixel)

	if (neighborhood.up.on ||
		neighborhood.up_right.on ||
		neighborhood.right.on ||
		neighborhood.down_right.on ||
		neighborhood.down.on ||
		neighborhood.down_left.on ||
		neighborhood.left.on ||
		neighborhood.up_left.on)
	{
		pixel.next = true
	}
	else
	{
		pixel.next = false
	}

}

tickpix :: proc(pixel: ^Pixel)
{
	pixel.on = pixel.next
}

drawpix :: proc(pixel: ^Pixel)
{	if pixel.on
	{
		pixel.color = rl.WHITE
	}
	else
	{
		pixel.color = rl.BLACK
	}

	rl.DrawRectangleV({f32(pixel.x), f32(pixel.y)} * PIXEL_SCALE, {PIXEL_SCALE, PIXEL_SCALE}, pixel.color)
}

main :: proc()
{
	world: World 
	initworld(&world, 1280 / PIXEL_SCALE, 720 / PIXEL_SCALE)	


	rl.InitWindow(1280, 720, "Hello")

	for !rl.WindowShouldClose()
	{
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		if rl.IsMouseButtonDown(.LEFT)
		{
			updateworld(&world)
		}

		if rl.IsKeyPressed(.SPACE)
		{		
			for &pixel in world.pixels
			{
				updatepix(&world, &pixel)
			}	
		}

		for &pixel in world.pixels
		{
			tickpix(&pixel)
			drawpix(&pixel)
		}	
		rl.EndDrawing()
	}
}

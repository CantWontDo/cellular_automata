package pixel_sim
import rl "vendor:raylib"
import "core:math"

COLOR_BACKGROUND :: rl.Color{12, 10, 16, 255}

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

	return int(math.round((math.sqrt(f32((delta_x * delta_x) + (delta_y * delta_y))))))
}

mouse2index :: proc(world: ^World) -> (int, bool)
{
	if rl.CheckCollisionPointRec(rl.GetMousePosition(), {0, 0, f32(rl.GetRenderWidth()), f32(rl.GetRenderHeight())})
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
package chess

import rl "vendor:raylib"
import "core:fmt"

SpecialEffect :: enum {
    None,
    Fancy,
}


draw_button :: proc(text: cstring, location: [2]f32, dimensions: [2]f32, main_color: rl.Color, secondary_color: rl.Color, special_effect := SpecialEffect.None) {
    switch special_effect {
        case .None:  rl.DrawRectangleRounded(rl.Rectangle{location.x, location.y, dimensions.x, dimensions.y}, 0.3, 10, main_color)
        case .Fancy: rl.DrawRectangleGradientH(i32(location.x), i32(location.y), i32(dimensions.x), i32(dimensions.y), main_color, secondary_color)
    }
    font_size := dimensions.y / 4
    fmt.println("FONT SIZE: %d", font_size)
    text_size := rl.MeasureTextEx(rl.GetFontDefault(), text, font_size, 1)
    text_width, text_height := text_size[0], text_size[1]
    for text_width > dimensions.x {
        font_size = font_size * 0.8
        fmt.println("FONT SIZE: %d", font_size)
        if font_size < 5 {
            panic("Text provided to button is too long or the button is too small.")
        }
        text_size := rl.MeasureTextEx(rl.GetFontDefault(), text, font_size, 1)
        text_width, text_height := text_size[0], text_size[1]
        fmt.println("TEXT WIDTH: %d", text_width)
        fmt.println("DIMENSION X: %d", dimensions.x)
    }
    width_diff := i32(dimensions.x - text_width)
    rl.DrawText(text, i32(location.x) + width_diff/3, i32(location.y)+(i32(dimensions.y) - i32(text_height))/2, i32(font_size), rl.BLACK)
}
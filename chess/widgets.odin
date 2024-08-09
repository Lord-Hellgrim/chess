package chess

import rl "vendor:raylib"


SpecialEffect :: enum {
    None,
    Fancy,
}


draw_button :: proc(text: cstring, location: [2]f32, dimensions: [2]f32, main_color: rl.Color, secondary_color: rl.Color, special_effect := SpecialEffect.None) {
    rl.DrawRectangleRounded(rl.Rectangle{location.x, location.y, dimensions.x, dimensions.y}, 0.3, 10, main_color)
    font_size := dimensions.y /4
    text_size := rl.MeasureTextEx(rl.GetFontDefault(), text, font_size, 1)
    text_width, text_height := text_size[0], text_size[1]
    for text_width > dimensions.x {
        font_size = font_size * 0.9
        if font_size < 5 {
            panic("Text provided to button is too long or the button is too small.")
        }
    }
    width_diff := i32(dimensions.x - text_width)
    rl.DrawText(text, i32(location.x)+width_diff/3, i32(location.y)+(i32(dimensions.y) - i32(text_height))/2, i32(font_size), rl.BLACK)

}
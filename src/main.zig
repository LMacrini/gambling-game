const std = @import("std");
const lib = @import("gambling_game_lib");
const clay = @import("zclay");
const rl = @import("raylib");

pub fn main() !void {
    rl.setConfigFlags(.{
        // TODO: decide if i want anti-aliasing
        // .msaa_4x_hint = true,
        .window_resizable = true,
    });

    rl.initWindow(512, 512, "Gambling Game");
    rl.setWindowMinSize(100, 100);
    rl.setTargetFPS(60);
    defer rl.closeWindow();

    while (!rl.windowShouldClose()) {


        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
    }
}

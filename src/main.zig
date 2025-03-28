const std = @import("std");
const rl = @import("raylib");
const cl = @import("zclay");
const renderer = @import("renderer");

fn loadFont(comptime path: []const u8, font_id: u8, font_size: u16) !void {
    renderer.raylib_fonts[font_id] = try rl.loadFontFromMemory(".otf", @embedFile(path), font_size, null);
    rl.setTextureFilter(renderer.raylib_fonts[font_id].?.texture, .bilinear);
}

fn createLayout() cl.ClayArray(cl.RenderCommand) {
    cl.beginLayout();
    cl.UI()(.{
        .id = .ID("background"),
        .background_color = cl.Color{255, 0, 0, 255},
        .layout = .{
            .sizing = .grow,
            .padding = .{
                .left = 10,
                .right = 10,
                .top = 10,
                .bottom = 10,
            },
        },
    })({
        cl.UI()(.{
            .id = .ID("rectangle"),
            .background_color = cl.Color{0, 0, 255, 255},
            .layout = .{
                .sizing = .grow,
            },
        })({});
    });
    return cl.endLayout();
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const min_memory_size: u32 = cl.minMemorySize();
    const memory = try allocator.alloc(u8, min_memory_size);
    defer allocator.free(memory);
    const arena = cl.createArenaWithCapacityAndMemory(memory);
    _ = cl.initialize(arena, .{ .w = 512, .h = 512, }, .{});
    cl.setMeasureTextFunction(void, {}, renderer.measureText);

    rl.setConfigFlags(.{
        // TODO: decide if i want anti-aliasing
        // .msaa_4x_hint = true,
        .window_resizable = true,
    });

    rl.initWindow(512, 512, "Gambling Game");
    rl.setWindowMinSize(100, 100);
    rl.setTargetFPS(60);
    defer rl.closeWindow();

    try loadFont("resources/FiraMonoNerdFontMono-Regular.otf", 0, 32);

    var debug_mode = false;
    while (!rl.windowShouldClose()) {
        if (rl.isKeyPressed(.d)) {
            debug_mode = !debug_mode;
            cl.setDebugModeEnabled(debug_mode);
        }

        cl.setLayoutDimensions(.{
            .w = @floatFromInt(rl.getScreenWidth()),
            .h = @floatFromInt(rl.getScreenHeight()),
        });

        var render_commands = createLayout();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
        try renderer.clayRaylibRender(&render_commands, allocator);
    }
}

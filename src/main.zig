const std = @import("std");
const io = std.io;
const fs = std.fs;
const process = std.process;
const PreopenList = std.fs.wasi.PreopenList;
const PreopenType = std.fs.wasi.PreopenType;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() anyerror!void {
    const allocator = &gpa.allocator;

    // Extract cli args.
    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);

    if (args.len < 3) {
        const stderr = io.getStdErr().outStream();
        try stderr.print("not enough arguments: you need to specify the input and output file paths", .{});
        return;
    }
    const input_fn = args[1];
    const output_fn = args[2];

    // Fetch preopens from the VM.
    var preopens = PreopenList.init(allocator);
    defer preopens.deinit();
    try preopens.populate();

    if (preopens.find(PreopenType{ .Dir = "." })) |pr| {
        const dir = fs.Dir{ .fd = pr.fd };

        // We open the file for reading only
        var file = try dir.openFile(input_fn, .{});
        const contents = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
        defer allocator.free(contents);

        // Now, create a file for writing and copy the read contents in.
        var out = try dir.createFile(output_fn, .{});
        try out.writeAll(contents);
    } else {
        const stderr = io.getStdErr().outStream();
        try stderr.print("capabilities insufficient: '.' dir not found", .{});
    }
}

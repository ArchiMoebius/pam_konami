const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSafe });

    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .pic = true,
        .strip = true,
    });

    const lib = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "pam_konami",
        .root_module = lib_mod,
    });

    lib.linkSystemLibrary("pam");

    b.installArtifact(lib);
}

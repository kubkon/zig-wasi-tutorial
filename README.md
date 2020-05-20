# zig-wasi-tutorial

Zig's take on the official [WASI tutorial]. Hopefully, this tutorial will serve as a
decent intro to WASI from Zig lang.

[WASI tutorial]: https://github.com/bytecodealliance/wasmtime/blob/master/docs/WASI-tutorial.md

## Building

At the time of writing (May 19th, 2020), WASI support in Zig has only just been merged into upstream.
Therefore, to build the tutorial you'll need to get your hands on the nightly Zig which can be found
[here](https://ziglang.org/download/).

After you've successfully installed nightly Zig, simply run

```
$ zig build
```

Note that for your convenience, I've made `wasm32-wasi` target the default in `build.zig`, so there's
no need to specify the target manually.

You should now have the compiled WASI module in `zig-cache/bin/main.wasm`.

[Zig's official repo]: https://github.com/ziglang/zig

## Running

If you haven't already, go and get yourself a fresh copy of [`wasmtime`].

[`wasmtime`]: https://github.com/bytecodealliance/wasmtime/releases

Next, create some sample input

```
$ echo "WASI is really cool!" > in.txt
```

Run it using `wasmtime`

```
$ wasmtime --dir=. zig-cache/bin/main.wasm in.txt out.txt
```

As a result, you should now have `out.txt` file created with the same contents as `in.txt`.

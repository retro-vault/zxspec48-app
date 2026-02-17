# zxspec48-app

Minimal ZX Spectrum 48K C project with Docker-based SDCC builds, using a custom `crt0` and SDCC's default z80 libraries.

## What this project does

- Builds inside Docker (no local SDCC install required).
- Uses SDCC for compile + link (no generated linker script).
- Uses `--code-loc` to place code at a chosen load address.
- Uses `--no-std-crt0` and provides our own startup in `src/crt0.s`.
- Uses SDCC libc (`printf`, `puts`, `malloc`, etc.) with platform hooks implemented in `crt0.s`.

## Build

`make` runs the build in Docker using image `wischner/sdcc-z80-zx-spectrum:latest`.

```sh
make
```

Output artifacts:

- `build/<TARGET>/<TARGET>.ihx`
- `build/<TARGET>/<TARGET>.bin`
- `bin/<TARGET>.tap`

Default target name is `zxspec48-app`.

## Useful build parameters

Change program name:

```sh
make TARGET=myapp
```

Change load address used for linking and TAP header:

```sh
make LOAD_ADDR_HEX=0x9000
```

## Runtime design (why this works)

`src/crt0.s` is the runtime glue between ZX ROM and SDCC libc:

1. Saves registers and sets a private stack.
2. Opens Spectrum stream channel (`CHAN-OPEN`) so console I/O goes to screen.
3. Runs SDCC GSINIT (global/static initialization) and calls `___sdcc_heap_init`.
4. Calls `_main`.
5. Restores registers and returns.

It also provides symbols required by SDCC library:

- Heap symbols:
  - `___sdcc_heap` (heap start, in `_HEAP`)
  - `___sdcc_heap_end = 0xffff` (heap end)
- Stdio hooks:
  - `_putchar` (ROM `RST 0x10`)
  - `_getchar` (ROM key input routine)

Because these hooks are present, standard C I/O from SDCC libc links and runs against Spectrum ROM services.

## Project layout

- `Makefile`: host/Docker entrypoint.
- `src/Makefile`: compile/link pipeline (`.c/.s -> .rel -> .ihx -> .bin -> .tap`).
- `src/crt0.s`: startup + SDCC runtime hooks.
- `src/main.c`: sample C program using stdio.

## VS Code / FUSE

A `.vscode` setup is included for emulator launch. If GUI access from Docker is needed, allow X access first:

```sh
xhost +SI:localuser:$(whoami)
```

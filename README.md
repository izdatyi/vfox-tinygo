# vfox-tinygo

[TinyGo](https://tinygo.org/) plugin for [Version Fox (vfox)](https://vfox.dev/).

TinyGo is a Go compiler for small places: microcontrollers, WebAssembly (WASM/WASI), and command-line tools.

## Prerequisites

TinyGo requires standard Go to be installed on your system. You can install it using vfox:

```shell
vfox add golang
vfox install golang@latest
vfox use golang
```

## Installation

```shell
# Add tinygo plugin
vfox add tinygo

# Search available versions
vfox search tinygo

# Install latest version
vfox install tinygo@latest

# Install a specific version
vfox install tinygo@0.41.1

# Use installed version
vfox use tinygo
```

## Supported Platforms

- **Windows**: `amd64`
- **macOS (Darwin)**: `arm64` (Apple Silicon), `amd64` (Intel)
- **Linux**: `amd64`, `arm64`, `arm` (ARMv6/ARMv7/Raspberry Pi)

## Environment Variables

The plugin automatically configures:
- `PATH`: includes `<tinygo-sdk-path>/bin`
- `TINYGOROOT`: points to `<tinygo-sdk-path>`

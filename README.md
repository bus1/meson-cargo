meson-cargo
===========

Meson Integration of Cargo based Rust Code

The meson-cargo project provides Meson-Build integration of Cargo-based Rust
code. It fully integrates crates.io dependency resolution into the Meson build
system, including vendoring support, offline builds, meson-dist assembly, as
well as independent cargo project management.

This project is meant to be included as Meson subproject and then provides
hooks to include your custom Cargo.toml in the build. All output artifacts can
then be used in your Meson build configuration and be linked into other Meson
targets.

Since Meson does not provide external module support, nor custom functions, the
integration has a suboptimal API and requires integrators to take some extra
steps. However, this can be easily remedied in the future if Meson starts
providing more user-friendly external module support.

### Project

 * **Website**: <https://bus1.eu/lib/meson-cargo>
 * **Bug Tracker**: <https://github.com/bus1/meson-cargo/issues>

### Requirements

The requirements for this project are:

 * `cargo >= 1.64`
 * `coreutils`
 * `jq >= 1.6`
 * `meson >= 1.0`

### Repository:

 - **web**:   <https://github.com/bus1/meson-cargo>
 - **https**: `https://github.com/bus1/meson-cargo.git`
 - **ssh**:   `git@github.com:bus1/meson-cargo.git`

### License:

 - **MIT** OR **Apache-2.0** OR **LGPL-2.1-or-later**
 - See AUTHORS file for details.

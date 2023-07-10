#
# Lib-only Tests for meson-cargo
#
# This test creates a simple C library that links to a Rust library for
# its implementation. It uses meson-cargo to build the Rust library. No
# other Rust crates are built.
#

project(
        'lib-only',
        'c',
        default_options: [
                'c_std=c11',
        ],
        license: 'Apache',
        meson_version: '>=1.0.0',
        version: '1.0.0',
)

#
# Basic dependency setup
#

cc = meson.get_compiler('c')

dep_cstdaux = dependency('libcstdaux-1')
mod_cargo = subproject('meson-cargo-1')

add_project_arguments(dep_cstdaux.get_variable('cflags').split(' '), language: 'c')

#
# Configure cargo integration
#

static_rlib = custom_target(
        'rlib-static',
        kwargs: mod_cargo.get_variable('build_dict') + {
                'input': meson.project_source_root() / 'Cargo.toml',
                'output': ['librlib.a'],
        },
)

dep_rlib = declare_dependency(
        include_directories: include_directories('.'),
        link_with: static_rlib,
        version: meson.project_version(),
)

meson.add_dist_script(
        mod_cargo.get_variable('dist_cmd') + [
                meson.project_source_root() / 'Cargo.toml',
        ],
)

run_target(
        'vendor',
        kwargs: mod_cargo.get_variable('vendor_dict') + {
                'command': mod_cargo.get_variable('vendor_cmd') + [
                        meson.project_source_root() / 'Cargo.toml',
                ],
        },
)

#
# C Library
#

static_clib = static_library(
        'clib-static',
        [
                'clib.c',
        ],
        dependencies: [dep_cstdaux, dep_rlib],
        pic: true,
)

dep_clib = declare_dependency(
        include_directories: include_directories('.'),
        link_with: static_clib,
        dependencies: [dep_cstdaux, dep_rlib],
        version: meson.project_version(),
)

#
# Tests
#

test_bin = executable('test-bin', ['test.c'], dependencies: [dep_cstdaux, dep_clib])
test('Test Binary', test_bin)

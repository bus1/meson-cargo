#
# Bin-only Tests for meson-cargo
#
# This test creates a simple Rust binary, but nothing else. The Rust binary is
# built via Cargo but installed and managed via Meson.
#

project(
        'bin-only',
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
mod_cargo = subproject('meson-cargo-1')

#
# Configure cargo integration
#

cargo = custom_target(
        'cargo',
        kwargs: mod_cargo.get_variable('build_dict') + {
                'build_by_default': true,
                'env': mod_cargo.get_variable('build_env') + {
                        'MCARGO_TARGETS': '--bins',
                },
                'input': meson.project_source_root() / 'Cargo.toml',
                'output': ['rbin'],
        },
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
# Tests
#

test('Test Binary', find_program('./test.sh'), args: [cargo[0].full_path()])

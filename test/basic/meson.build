#
# Basic Testing of meson-cargo
#
# This test is a simple C-program that calls into a function implemented
# in rust, using crates.io dependencies for a full test setup.
#

project(
        'test-basic',
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
sub_cmesoncargo = subproject('meson-cargo-1')

add_project_arguments(dep_cstdaux.get_variable('cflags').split(' '), language: 'c')

#
# Configure cargo integration
#

static_rtestlib = custom_target(
        'rtestlib-static',
        kwargs: sub_cmesoncargo.get_variable('build_dict') + {
                'input': meson.project_source_root() / 'Cargo.toml',
                'output': 'libr_testlib.a',
        },
)

dep_rtestlib = declare_dependency(
        include_directories: include_directories('.'),
        link_with: static_rtestlib,
        version: meson.project_version(),
)

meson.add_dist_script(
        sub_cmesoncargo.get_variable('dist_cmd') + [
                meson.project_source_root() / 'Cargo.toml',
        ],
)

run_target(
        'vendor',
        kwargs: sub_cmesoncargo.get_variable('vendor_dict') + {
                'command': sub_cmesoncargo.get_variable('vendor_cmd') + [
                        meson.project_source_root() / 'Cargo.toml',
                ],
        },
)

#
# Test library
#

static_testlib = static_library(
        'testlib-static',
        [
                'testlib.c',
        ],
        dependencies: [dep_cstdaux, dep_rtestlib],
        pic: true,
)

dep_testlib = declare_dependency(
        include_directories: include_directories('.'),
        link_with: static_testlib,
        dependencies: [dep_cstdaux, dep_rtestlib],
        version: meson.project_version(),
)

#
# Tests
#

test_basic = executable('test-basic', ['test-basic.c'], dependencies: [dep_cstdaux, dep_testlib])
test('Basic Test', test_basic)

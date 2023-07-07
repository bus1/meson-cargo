#
# Global Project Setup
#

project(
        'meson-cargo',
        'c',
        license: 'Apache',
        meson_version: '>=1.0.0',
        version: '1.0.0',
)
project_description = 'Meson Integration of Cargo based Rust Code'

#
# Dependency Resolution
#

bin_cargo = find_program(
        'cargo',
        native: true,
        required: true,
        version: '>=1.64',
)
bin_cp = find_program(
        'cp',
        native: true,
        required: true,
)
bin_jq = find_program(
        'jq',
        native: true,
        required: true,
        version: '>=1.6',
)

bin_build = find_program(
        './src/build.sh',
        native: true,
        required: true,
)
bin_dist = find_program(
        './src/dist.sh',
        native: true,
        required: true,
)
bin_vendor = find_program(
        './src/vendor.sh',
        native: true,
        required: true,
)

#
# Config: profile
#

use_profile = get_option('profile')
if use_profile == ''
        use_buildtype = get_option('buildtype')
        if use_buildtype == 'debug'
                use_profile = 'dev'
        elif use_buildtype == 'debugoptimized' or use_buildtype == 'release'
                use_profile = 'release'
        endif
endif

#
# Config: target
#

use_target = get_option('target')

#
# Config: vendor
#

use_vendor = get_option('vendor')
if use_vendor == 'auto'
        use_wrap_mode = get_option('wrap_mode')
        use_vendor = use_wrap_mode == 'nodownload' ? 'yes' : 'no'
endif

#
# Config: vendordir
#

use_vendordir = get_option('vendordir')

#
# Build Target
#

build_cmd = [bin_build, '@OUTDIR@', '@INPUT0@']
build_env = {
        'MCARGO_BIN_CARGO': bin_cargo.full_path(),
        'MCARGO_BIN_CP': bin_cp.full_path(),
        'MCARGO_BIN_JQ': bin_jq.full_path(),
        'MCARGO_CRATE_TYPE': 'staticlib',
        'MCARGO_OFFLINE': use_vendor,
        'MCARGO_TARGET_DIR': meson.project_build_root() / 'cargo-target',
        'MCARGO_VENDOR_DIR': meson.global_source_root() / use_vendordir,
} + (use_profile == '' ? {} : {
        'MCARGO_PROFILE': use_profile,
}) + (use_target == '' ? {} : {
        'MCARGO_TARGET': use_target,
})

build_dict = {
        'build_always_stale': true,
        'command': build_cmd,
        'console': true,
        'env': build_env,
}

#
# Vendoring Target
#

vendor_cmd = [bin_vendor]
vendor_env = {
        'MCARGO_BIN_CARGO': bin_cargo.full_path(),
        'MCARGO_VENDOR_DIR': meson.global_source_root() / use_vendordir,
}

vendor_dict = {
        'command': vendor_cmd,
        'env': vendor_env,
}

#
# Dist Target
#

dist_cmd = [bin_dist, bin_cargo.full_path(), use_vendordir]

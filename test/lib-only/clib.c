/*
 * clib Implementation
 *
 * This is the implementation of the C library of this test, which links to the
 * Rust library for the actual code implementation.
 */

#include <c-stdaux.h>
#include <stdlib.h>
#include "clib.h"

/* defined in the Rust library */
extern uint32_t rlib_add71(uint32_t v);

_c_public_ uint32_t clib_add71(uint32_t v) {
        return rlib_add71(v);
}

#pragma once

/*
 * clib Header
 *
 * The public header of the C library of this test, providing prototypes for
 * all functionality exposed by it. Internally, it links to the rust library
 * and uses it to implement its functionality.
 */

#ifdef __cplusplus
extern "C" {
#endif

#include <inttypes.h>

uint32_t clib_add71(uint32_t v);

#ifdef __cplusplus
}
#endif

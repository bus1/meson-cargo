/*
 * Testlib Source
 *
 * The implementation of Testlib and all of its functionality. We import
 * c-stdaux as dependency to test that other meson-dependencies work fine.
 */

#include <c-stdaux.h>
#include <stdlib.h>
#include "testlib.h"

/* defined in r-testlib */
extern uint32_t rtestlib_add71(uint32_t v);

_c_public_ uint32_t testlib_add71(uint32_t v) {
        return rtestlib_add71(v);
}

/*
 * Tests for the C library
 */

#include <c-stdaux.h>
#include <stdlib.h>
#include "clib.h"

static void test_add71(void) {
        c_assert(clib_add71(0) == 71);
}

int main(void) {
        test_add71();
        return 0;
}

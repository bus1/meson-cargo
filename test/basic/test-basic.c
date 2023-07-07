/*
 * Basic Tests for Testlib
 */

#include <c-stdaux.h>
#include <stdlib.h>
#include "testlib.h"

static void test_add71(void) {
        c_assert(testlib_add71(0) == 71);
}

int main(void) {
        test_add71();
        return 0;
}

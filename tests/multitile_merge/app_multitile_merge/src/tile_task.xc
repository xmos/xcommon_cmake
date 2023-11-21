#include <print.h>
#include <timer.h>

#ifndef THIS_XCORE_TILE
#error THIS_XCORE_TILE must be defined
#endif

void tile_task() {
    delay_microseconds(THIS_XCORE_TILE);
    printintln(THIS_XCORE_TILE);
}

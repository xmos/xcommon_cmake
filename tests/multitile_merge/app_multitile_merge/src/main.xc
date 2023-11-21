#include <platform.h>
#include <xs1.h>

void tile_task();

int main() {
    par {
        on tile[0]: tile_task();
        on tile[1]: tile_task();
    }
    return 0;
}

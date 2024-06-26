#include "static0.h"

int main()
{
    static0();
    static0_archive(); // Calls static1_archive()
    return 0;
}

#include "static0.h"

int main()
{
    static0(); // Calls static1_archive()
    static0_archive();
    return 0;
}

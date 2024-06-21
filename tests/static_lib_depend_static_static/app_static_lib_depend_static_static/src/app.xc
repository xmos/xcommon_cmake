#include "static0.h"

int main()
{
    static0();          // Calls:
                        //         static1()
                        //         static1_archive()
    static0_archive();  // Calls:
                        //         static1();
                        //         static1_archive()

    return 0;
}

#include <print.h>

int main() {
#if defined(__XS2A__)
    printstrln("xs2");
#elif defined(__XS3A__)
    printstrln("xs3");
#else
    #error "Unsupported architecture"
#endif

    return 0;
}

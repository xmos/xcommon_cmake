#include "print.h"
#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)
#ifndef MSG
#error MSG not defined
#endif
int main() {
  printstrln(STRINGIFY(MSG));
  return 0;
}

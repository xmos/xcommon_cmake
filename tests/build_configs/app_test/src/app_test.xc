#include "print.h"
#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)
int main() {
  printstrln(STRINGIFY(MSG));
  return 0;
}

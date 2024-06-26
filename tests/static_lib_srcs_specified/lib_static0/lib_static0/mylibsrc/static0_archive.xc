#include "static0.h"

void static0A_archive_xc();
void static0B_archive_c();
void static0B_archive_cxx();

void static0_archive() {
    static0A_archive_xc();
    static0B_archive_c();
    static0B_archive_cxx();
}

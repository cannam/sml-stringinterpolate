
#include <stdio.h>

int strfromd(char *str, int64_t sz, const char *format, double d)
{
    return snprintf(str, sz, format, d);
}



#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

int32_t string_from_double(char *str, int64_t sz, double d)
{
    return snprintf(str, sz, "%.6lg", d);
}

int32_t string_from_float(char *str, int64_t sz, float f)
{
    return snprintf(str, sz, "%.6g", f);
}

int32_t string_from_int64(char *str, int64_t sz, int64_t i)
{
#ifdef PRId64
    return snprintf(str, sz, "%" PRId64, i);
#else
    return snprintf(str, sz, "%lld", i);
#endif
}


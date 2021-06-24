
#include <ryu/ryu.h>

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

int32_t string_from_double(char *str, int64_t sz, double d)
{
    /* ryu hard-codes 25 for its string allocation for double */
    if (sz < 25) {
        snprintf(str, sz, "#ERROR#");
    } else {
        d2s_buffered(d, str);
    }
}

int32_t string_from_float(char *str, int64_t sz, float f)
{
    /* ryu hard-codes 16 for its string allocation for float */
    if (sz < 16) {
        snprintf(str, sz, "#ERROR#");
    } else {
        f2s_buffered(f, str);
    }
}

int32_t string_from_int64(char *str, int64_t sz, int64_t i)
{
#ifdef PRId64
    return snprintf(str, sz, "%" PRId64, i);
#else
    return snprintf(str, sz, "%lld", i);
#endif
}


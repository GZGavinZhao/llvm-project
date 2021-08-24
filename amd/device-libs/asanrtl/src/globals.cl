/*===--------------------------------------------------------------------------
 *                   ROCm Device Libraries
 *
 * This file is distributed under the University of Illinois Open Source
 * License. See LICENSE.TXT for details.
 *===------------------------------------------------------------------------*/

#include "globals.h"

static bool
is_aligned_by_granularity(uptr addr) {
    return (addr & (SHADOW_GRANULARITY - 1)) == 0;
}

// round up size to the nearest multiple of boundary.
static uptr
round_upto(uptr size, uptr boundary) {
    return (size + boundary - 1) & ~(boundary - 1);
}

// round down size to the nearest multiple of boundary.
static uptr
round_downto(uptr size, uptr boundary) {
    return size & ~(boundary - 1);
}

// fill shadow bytes of range [aligned_beg, aligned_beg+aligned_size)
// with value.
NO_SANITIZE_ADDR
static void
fill_shadowof(uptr aligned_beg, uptr aligned_size, u8 value) {
    __global u8 *shadow_beg = (__global u8*)MEM_TO_SHADOW(aligned_beg);
    __global u8 *shadow_end = (__global u8*)(MEM_TO_SHADOW(aligned_beg + aligned_size - SHADOW_GRANULARITY) + 1);
    u64 nbytes     = shadow_end - shadow_beg;
    for (; nbytes; nbytes--, shadow_beg++)
       *shadow_beg = value;
}

// poison the redzones around the global only if global is shadow granularity aligned.
NO_SANITIZE_ADDR
static void
poison_redzones(__global const struct device_global *g) {
    if (!is_aligned_by_granularity(g->beg))
      return;
    if (!is_aligned_by_granularity(g->size_with_redzone))
      return;

    uptr aligned_size = round_upto(g->size, SHADOW_GRANULARITY);
    uptr redzone_beg  = g->beg + aligned_size;
    uptr redzone_size = g->size_with_redzone - aligned_size;
    fill_shadowof(redzone_beg, redzone_size, kAsanGlobalRedzoneMagic);

    // poison partial redzones if any.
    // since SHADOW_GRANULARITY is 8 bytes we require only one shadow byte
    // to keep partially addressable bytes information.
    if (g->size != aligned_size) {
      uptr aligned_addr = g->beg + round_downto(g->size, SHADOW_GRANULARITY);
      __global u8 *shadow_addr = (__global u8*)MEM_TO_SHADOW(aligned_addr);
      *shadow_addr      = (u8) (g->size % SHADOW_GRANULARITY);
    }
}

// This function is called by one-workitem constructor kernel.
NO_SANITIZE_ADDR
void
__asan_register_globals(__global struct device_global *dglobals, uptr n) {
    for (uptr i = 0; i < n; i++)
       poison_redzones(&dglobals[i]);
}

// unpoison global and redzones around it only if global is shadow granularity aligned.
NO_SANITIZE_ADDR
static void
unpoison_global(__global const struct device_global *g) {
    if (!is_aligned_by_granularity(g->beg))
      return;
    if (!is_aligned_by_granularity(g->size_with_redzone))
      return;
    fill_shadowof(g->beg, g->size_with_redzone, 0);
}

// This function is called by one-workitem destructor kernel.
NO_SANITIZE_ADDR
void
__asan_unregister_globals(__global struct device_global *dglobals, uptr n) {
    for (uptr i = 0; i < n; i++)
       unpoison_global(&dglobals[i]);
}

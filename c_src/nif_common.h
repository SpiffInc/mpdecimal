#ifndef NIF_COMMON_H
#define NIF_COMMON_H

#include "erl_nif.h"
#include "mpdecimal.h"

// #define NIF_DEBUG

typedef struct {
  mpd_context_t* ctx;
  ErlNifResourceType* resource_mpd_t_pp;
} priv_data_t;

#endif


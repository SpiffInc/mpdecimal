#ifndef NIF_COMMON_H
#define NIF_COMMON_H

#include "erl_nif.h"
#include "mpdecimal.h"

// #define NIF_DEBUG

// For use in NIF definitions.
#define RESOURCE_MPD_T_PP \
  ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp

typedef struct {
  mpd_context_t* ctx;
  ErlNifResourceType* resource_mpd_t_pp;
} priv_data_t;

#endif


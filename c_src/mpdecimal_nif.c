#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef _WIN32
#include <unistd.h>
#endif

#include "erl_nif.h"
#include "mpdecimal.h"
#include "nif_common.h"
#include "nif_function.h"
#include "nif_function_register.h"

// Configure the mpdecimal library to use the memory allocator provided by the
// BEAM VM.
static inline void setup_mpd_mem_alloc(void)
{
  mpd_mallocfunc = enif_alloc;
  mpd_reallocfunc = enif_realloc;

  // Configure the mpdecimal library to emulate mpd_calloc since enif_calloc is
  // not implemented.
  mpd_callocfunc = mpd_callocfunc_em;

  mpd_free = enif_free;
}

static void mpd_custom_traphandler(mpd_context_t* ctx)
{
  (void) ctx;
}

// Destructor for the "mpd_t" resource type.
static void dtor_mpd_t(ErlNifEnv* env, void* obj)
{
  // TODO: Remove this debugging statement.
  printf("dtor %p\r\n", obj);
  (void) env;
  mpd_del(*((mpd_t**) obj));
} 

int load(ErlNifEnv* caller_env, void** priv_data, ERL_NIF_TERM load_info)
{
  setup_mpd_mem_alloc();

  // The default trap handler for the mpdecimal library raises SIGFPE. While
  // the BEAM VM happens to ignore SIGFPE (as of OTP 21), it's a bit cleaner
  // not to rely on this behavior and call a custom trap handler that does not
  // raise SIGFPE at all.
  mpd_traphandler = mpd_custom_traphandler;

  priv_data_t* p_data = *priv_data = enif_alloc(sizeof(priv_data_t));
  if (p_data == NULL) {
    return 1;
  }
  
  // Open the "mpd_t" resource type so that it can be passed in and out of NIF
  // functions.
  p_data->resource_mpd_t = enif_open_resource_type(caller_env,
                                                   NULL,
                                                   "mpd_t",
                                                   dtor_mpd_t,
                                                   ERL_NIF_RT_CREATE,
                                                   NULL);
  if (p_data->resource_mpd_t == NULL) {
    return 1;
  }
  
  mpd_context_t* ctx = p_data->ctx = mpd_alloc(1, sizeof(mpd_context_t));
  if (ctx == NULL) {
    return 1;
  }

  // Configure the mpdecimal library context to match the Elixir Decimal
  // library default context configuration:
  //  - precision       28 Digits
  //  - rounding mode   Half Up
  //  - traps           Invalid Operation, Division by Zero
  mpd_init(ctx, 28);
  ctx->round = MPD_ROUND_HALF_UP;
  ctx->traps = MPD_IEEE_Invalid_operation | MPD_Division_by_zero;

  return 0;
}

int upgrade(ErlNifEnv* caller_env, void** priv_data, void** old_priv_data, ERL_NIF_TERM load_info)
{
  *priv_data = *old_priv_data;
  return 0;
}

void unload(ErlNifEnv* caller_env, void* priv_data)
{
  enif_free(priv_data);
  return;
}

ERL_NIF_INIT(Elixir.MPDecimal.Nif, funcs, load, /* reload (deprecated) */ NULL, upgrade, unload)


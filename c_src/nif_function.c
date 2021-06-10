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

// TODO: Documentation
// i.e. Get resources from function parameters.
#define NIF_GET_RESOURCE_0IN                                                  \
  if (argc != 0) {                                                            \
    return enif_make_badarg(env);                                             \
  }

#define NIF_GET_RESOURCE_1IN                                                                                 \
  const mpd_t* a;                                                                                            \
  if ((argc != 1) ||                                                                                         \
      !enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &a)) { \
    return enif_make_badarg(env);                                                                            \
  }

#define NIF_GET_RESOURCE_2IN                                                                                 \
  const mpd_t* a;                                                                                            \
  const mpd_t* b;                                                                                            \
  if ((argc != 2) ||                                                                                         \
      !enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &a) || \
      !enif_get_resource(env, argv[1], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &b)) { \
    return enif_make_badarg(env);                                                                            \
  }

#define NIF_GET_RESOURCE(argc_in) NIF_GET_RESOURCE_##argc_in##IN

#define MPD_CONTEXT_TRAP_CHECK                                                \
  if (ctx.newtrap) {                                                          \
    return nif_make_error_tuple(env, &ctx);                                   \
  }

// TODO: Immutable resuorces are used in keeping with the Erlang paradigm.
// TODO: Note that the result is created here, keeping with the Erlang paradigm of immutable data.
// Out arguments are always created here, new.
// Only the functions that work with Erlang data types are supported.
#define MPD_NEW(result)                                                                                     \
  mpd_t* result = enif_alloc_resource(((priv_data_t*) enif_priv_data(env))->resource_mpd_t, sizeof(mpd_t)); \
  ERL_NIF_TERM result_term = enif_make_resource(env, result);                                               \
  enif_release_resource((void*) result);                                                                    \
  result = mpd_new(&ctx);                                                                                   \
  MPD_CONTEXT_TRAP_CHECK


// 0IN_1OUT is an alias for mpd_new()
#define MPD_FUNCTION_0IN_1OUT(function)                                       \
  MPD_NEW(result)                                                             \

#define MPD_FUNCTION_1IN_1OUT(function)                                       \
  MPD_NEW(result)                                                             \
  (void) (mpd_##function)(result, a, &ctx);

#define MPD_FUNCTION_2IN_1OUT(function)                                       \
  MPD_NEW(result)                                                             \
  printf("About to call mpd function.\r\n"); \
  (void) (mpd_##function)(result, a, b, &ctx);

#define MPD_FUNCTION(function, argc_in, argc_out)                             \
  MPD_FUNCTION_##argc_in##IN_##argc_out##OUT(function)                        \
  MPD_CONTEXT_TRAP_CHECK

#define NIF_FUNCTION_DEFINE(function, argc_in, argc_out)                      \
NIF_FUNCTION_HEADER(function)                                                 \
{                                                                             \
  NIF_GET_RESOURCE(argc_in)                                                   \
  mpd_context_t ctx = nif_copy_context(env);                                  \
  MPD_FUNCTION(function, argc_in, argc_out)                                   \
  return enif_make_tuple2(env,                                                \
                          enif_make_atom(env, "ok"),                          \
                          result_term);                                       \
}

static ERL_NIF_TERM nif_make_error_tuple(ErlNifEnv* env, mpd_context_t* ctx)
{
  char signal_list_string[MPD_MAX_SIGNAL_LIST];
  mpd_ssize_t signal_list_strlen;
  ERL_NIF_TERM signal_list_term;
  
  signal_list_strlen = mpd_lsnprint_signals(signal_list_string, MPD_MAX_SIGNAL_LIST, ctx->newtrap, NULL);
  if (signal_list_strlen == -1) {
    // In the case of failure, create an empty string.
    signal_list_string[0] = '\0';
    signal_list_strlen = 0;
  }

  memcpy(enif_make_new_binary(env, signal_list_strlen, &signal_list_term),
         signal_list_string,
         signal_list_strlen);

  return enif_make_tuple2(env, enif_make_atom(env, "error"), signal_list_term);
}

// Ensure Thread Safety
// Create a copy of the (previously-initialized) MPD context on the stack.
// Hereafter, any function calls into the mpdecimal library interact with this
// copy of the context, which is used only by the current thread.
static inline mpd_context_t nif_copy_context(ErlNifEnv* env)
{
  return *(((priv_data_t*) enif_priv_data(env))->ctx);
}

// TODO: Implement nif_get_resource_mpd_t?

#define MPDECIMAL_FUNCTION NIF_FUNCTION_DEFINE
#include "mpdecimal_function.h"
#undef MPDECIMAL_FUNCTION


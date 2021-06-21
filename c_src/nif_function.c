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
  const mpd_t** a;                                                                                           \
  if ((argc != 1) ||                                                                                         \
      !enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &a)) { \
    return enif_make_badarg(env);                                                                            \
  }

#define NIF_GET_RESOURCE_2IN                                                                                 \
  const mpd_t** a;                                                                                           \
  const mpd_t** b;                                                                                           \
  if ((argc != 2) ||                                                                                         \
      !enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &a) || \
      !enif_get_resource(env, argv[1], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &b)) { \
    return enif_make_badarg(env);                                                                            \
  }

#define NIF_GET_RESOURCE_3IN                                                                                 \
  const mpd_t** a;                                                                                           \
  const mpd_t** b;                                                                                           \
  const mpd_t** c;                                                                                           \
  if ((argc != 3) ||                                                                                         \
      !enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &a) || \
      !enif_get_resource(env, argv[1], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &b) || \
      !enif_get_resource(env, argv[2], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &c)) { \
    return enif_make_badarg(env);                                                                            \
  }

#define NIF_GET_RESOURCE(argc_in) NIF_GET_RESOURCE_##argc_in##IN

#define MPD_CONTEXT_TRAP_CHECK                                                \
  if (ctx.newtrap) {                                                          \
    return nif_make_error_tuple(env, &ctx);                                   \
  }

// TODO: Immutable resourrces are used in keeping with the Erlang paradigm.
// TODO: Note that the result is created here, keeping with the Erlang paradigm of immutable data.
// Out arguments are always created here, new.
// Only the functions that work with Erlang data types are supported.
#define MPD_NEW(result)                                                                                        \
  mpd_t** result = enif_alloc_resource(((priv_data_t*) enif_priv_data(env))->resource_mpd_t, sizeof(mpd_t**)); \
  *result = mpd_new(&ctx);                                                                                     \
  ERL_NIF_TERM result##_term = enif_make_resource(env, result);                                                \
  enif_release_resource(result);                                                                               \
  MPD_CONTEXT_TRAP_CHECK

// TODO: Call mpd_finalize()?

// TODO: This may not be needed at all.
// 0IN_1OUT is an alias for mpd_new()
#define MPD_FUNCTION_0IN_1OUT(function)                                       \
  MPD_NEW(result)                                                             \
  return result_term;

#define MPD_FUNCTION_1IN_1OUT(function)                                       \
  MPD_NEW(result)                                                             \
  (void) (mpd_##function)(*result, *a, &ctx);                                 \
  MPD_CONTEXT_TRAP_CHECK                                                      \
  return result_term;

#define MPD_FUNCTION_2IN_1OUT(function)                                       \
  MPD_NEW(result)                                                             \
  (void) (mpd_##function)(*result, *a, *b, &ctx);                             \
  MPD_CONTEXT_TRAP_CHECK                                                      \
  return result_term;

#define MPD_FUNCTION_2IN_2OUT(function)                                       \
  MPD_NEW(q)                                                                  \
  MPD_NEW(r)                                                                  \
  (void) (mpd_##function)(*q, *r, *a, *b, &ctx);                              \
  MPD_CONTEXT_TRAP_CHECK                                                      \
  return enif_make_tuple2(env, q_term, r_term);

#define MPD_FUNCTION_3IN_1OUT(function)                                       \
  MPD_NEW(result)                                                             \
  (void) (mpd_##function)(*result, *a, *b, *c, &ctx);                         \
  MPD_CONTEXT_TRAP_CHECK                                                      \
  return result_term;

#define MPD_FUNCTION(function, argc_in, argc_out)                             \
  MPD_FUNCTION_##argc_in##IN_##argc_out##OUT(function)

#define NIF_FUNCTION_DEFINE(function, argc_in, argc_out)                      \
NIF_FUNCTION_HEADER(function)                                                 \
{                                                                             \
  NIF_GET_RESOURCE(argc_in)                                                   \
  mpd_context_t ctx = nif_copy_context(env);                                  \
  MPD_FUNCTION(function, argc_in, argc_out)                                   \
}

static ERL_NIF_TERM enif_make_boolean(ErlNifEnv* env, int i)
{
  return (i != 0) ? enif_make_atom(env, "true")
                  : enif_make_atom(env, "false");
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

#define NIF_FUNCTION NIF_FUNCTION_DEFINE
#include "nif_interface.h"
#undef NIF_FUNCTION 

NIF_FUNCTION_HEADER(cmp)
{
  NIF_GET_RESOURCE(2)
  mpd_context_t ctx = nif_copy_context(env);

  int result = mpd_cmp(*a, *b, &ctx);
  MPD_CONTEXT_TRAP_CHECK

  return enif_make_int(env, result);
}

NIF_FUNCTION_HEADER(is_mpdecimal)
{
  if (argc != 1) {
    return enif_make_badarg(env);
  }

  const mpd_t** a;
  int result = enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &a);

  return enif_make_boolean(env, result);
}

NIF_FUNCTION_HEADER(isnan)
{
  NIF_GET_RESOURCE_1IN
  int result = mpd_isnan(*a);

  return enif_make_boolean(env, result);
}

NIF_FUNCTION_HEADER(ispositive)
{
  NIF_GET_RESOURCE_1IN
  int result = mpd_ispositive(*a);
  return enif_make_boolean(env, result);
}

NIF_FUNCTION_HEADER(isinfinite)
{
  NIF_GET_RESOURCE_1IN
  int result = mpd_isinfinite(*a);
  return enif_make_boolean(env, result);
}

NIF_FUNCTION_HEADER(isinteger)
{
  NIF_GET_RESOURCE_1IN
  int result = mpd_isinteger(*a);
  return enif_make_boolean(env, result);
}

NIF_FUNCTION_HEADER(set_i64)
{
  ErlNifSInt64 integer;

  if ((argc != 1) ||
      !enif_get_int64(env, argv[0], &integer)) {
    return enif_make_badarg(env);
  }

  mpd_context_t ctx = nif_copy_context(env);
  MPD_NEW(result)

  mpd_set_i64(*result, integer, &ctx);
  MPD_CONTEXT_TRAP_CHECK

  return result_term;
}

NIF_FUNCTION_HEADER(set_string)
{
  ErlNifBinary s_binary;

  if ((argc != 1) ||
      !enif_inspect_binary(env, argv[0], &s_binary)) {
    return enif_make_badarg(env);
  }

  mpd_context_t ctx = nif_copy_context(env);
  MPD_NEW(result)

  mpd_set_string(*result, (char*) s_binary.data, &ctx);
  MPD_CONTEXT_TRAP_CHECK
 
  return result_term; 
}

NIF_FUNCTION_HEADER(to_sci)
{
  NIF_GET_RESOURCE_1IN

  mpd_context_t ctx = nif_copy_context(env);

  char* res;
  mpd_ssize_t res_strlen;
  res_strlen = mpd_to_sci_size(&res, *a, /* fmt */ 0);

  if (res == NULL) {
    // Manually add MPD_Malloc_error since mpd_to_sci_size is not context
    // sensitive.
    mpd_addstatus_raise(&ctx, MPD_Malloc_error);
    return nif_make_error_tuple(env, &ctx);
  }

  // Package the string into an Erlang binary.
  ERL_NIF_TERM res_term;
  memcpy(enif_make_new_binary(env, res_strlen, &res_term),
         res,
         res_strlen);
  mpd_free(res);

  return res_term;
}

NIF_FUNCTION_HEADER(to_eng)
{
  NIF_GET_RESOURCE_1IN

  mpd_context_t ctx = nif_copy_context(env);

  char* res;
  mpd_ssize_t res_strlen;
  res_strlen = mpd_to_eng_size(&res, *a, /* fmt */ 0);

  if (res == NULL) {
    // Manually add MPD_Malloc_error since mpd_to_sci_size is not context
    // sensitive.
    mpd_addstatus_raise(&ctx, MPD_Malloc_error);
    return nif_make_error_tuple(env, &ctx);
  }

  // Package the string into an Erlang binary.
  ERL_NIF_TERM res_term;
  memcpy(enif_make_new_binary(env, res_strlen, &res_term),
         res,
         res_strlen);
  mpd_free(res);

  return res_term;
}


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

#define NIF_GET_RESOURCE_1IN                                                                                    \
  const mpd_t** a;                                                                                              \
  if ((argc != 1) ||                                                                                            \
      !enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, (void**) &a)) { \
    return enif_make_badarg(env);                                                                               \
  }

#define NIF_GET_RESOURCE_2IN                                                                                    \
  const mpd_t** a;                                                                                              \
  const mpd_t** b;                                                                                              \
  if ((argc != 2) ||                                                                                            \
      !enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, (void**) &a) || \
      !enif_get_resource(env, argv[1], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, (void**) &b)) { \
    return enif_make_badarg(env);                                                                               \
  }

#define NIF_GET_RESOURCE_3IN                                                                                    \
  const mpd_t** a;                                                                                              \
  const mpd_t** b;                                                                                              \
  const mpd_t** c;                                                                                              \
  if ((argc != 3) ||                                                                                            \
      !enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, (void**) &a) || \
      !enif_get_resource(env, argv[1], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, (void**) &b) || \
      !enif_get_resource(env, argv[2], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, (void**) &c)) { \
    return enif_make_badarg(env);                                                                               \
  }

#define NIF_GET_RESOURCE(argc_in) NIF_GET_RESOURCE_##argc_in##IN

#define MPD_CONTEXT_TRAP_CHECK                                                \
  if (ctx.newtrap) {                                                          \
    return make_tuple_mpd_error(env, &ctx);                                   \
  }

// TODO: Immutable resources are used in keeping with the Erlang paradigm.
// TODO: Note that the result is created here, keeping with the Erlang paradigm of immutable data.
// Out arguments are always created here, new.
// Only the functions that work with Erlang data types are supported.
#define MPD_NEW(result)                                                                                           \
  mpd_t** result = enif_alloc_resource(((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, sizeof(mpd_t**)); \
  *result = mpd_new(&ctx);                                                                                        \
  ERL_NIF_TERM result##_term = enif_make_resource(env, result);                                                   \
  enif_release_resource(result);                                                                                  \
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

static ERL_NIF_TERM make_boolean(ErlNifEnv* env, int i)
{
  return (i != 0) ? enif_make_atom(env, "true")
                  : enif_make_atom(env, "false");
}

// TODO: Custom error name table.
// MPD_Malloc_error -> something else

// TODO: Consider how the error conditions that may occur interact with the context model used by the Elixir mpdecimal library.

// TODO: Rename this function.
static ERL_NIF_TERM make_tuple_mpd_error(ErlNifEnv* env, mpd_context_t* ctx)
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

// TODO
// create: enif_alloc_resource, populate resource, and enif_make_resource
// In the event that there is a memory allocation error on mpd_new, the Erlang
// term is still created and eligible for garbage collection. The destructor
// will not fail since it is legal to call free on NULL. It is desirable to
// call enif_make_resource before checking for mpd_new failure because
// enif_release_resource makes the resource eligible for garbage collection,
// and it must be called after enif_make_resource.
static ERL_NIF_TERM create_resource_mpd_t_pp(ErlNifEnv* env,
                                             mpd_context_t* ctx,
                                             mpd_t*** resource,
                                             ERL_NIF_TERM* resource_term)
{
  *resource = enif_alloc_resource(RESOURCE_MPD_T_PP, sizeof(mpd_t**));
  if (resource == NULL) {
    // TODO: Return an Erlang memory allocation error instead of an MPD memory
    // allocation error.
    mpd_addstatus_raise(ctx, MPD_Malloc_error);
    return make_tuple_mpd_error(env, ctx);
  }

  **resource = mpd_new(ctx);

  *resource_term = enif_make_resource(env, *resource);
  enif_release_resource(resource);

  if (ctx->newtrap) {
    return make_tuple_mpd_error(env, ctx);
  }

  return enif_make_atom(env, "ok");
}

// Ensure Thread Safety
// Create a copy of the (previously-initialized) MPD context on the stack.
// Hereafter, any function calls into the mpdecimal library interact with this
// copy of the context, which is used only by the current thread.
static inline mpd_context_t nif_copy_context(ErlNifEnv* env)
{
  return *(((priv_data_t*) enif_priv_data(env))->ctx);
}

// TODO: Implement nif_get_resource_mpd_t_pp?

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
  int result = enif_get_resource(env, argv[0], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, (void**) &a);

  return make_boolean(env, result);
}

NIF_FUNCTION_HEADER(isnan)
{
  NIF_GET_RESOURCE_1IN
  int result = mpd_isnan(*a);

  return make_boolean(env, result);
}

NIF_FUNCTION_HEADER(ispositive)
{
  NIF_GET_RESOURCE_1IN
  int result = mpd_ispositive(*a);
  return make_boolean(env, result);
}

NIF_FUNCTION_HEADER(isinfinite)
{
  NIF_GET_RESOURCE_1IN
  int result = mpd_isinfinite(*a);
  return make_boolean(env, result);
}

NIF_FUNCTION_HEADER(isinteger)
{
  NIF_GET_RESOURCE_1IN
  int result = mpd_isinteger(*a);
  return make_boolean(env, result);
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
    return make_tuple_mpd_error(env, &ctx);
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
    return make_tuple_mpd_error(env, &ctx);
  }

  // Package the string into an Erlang binary.
  ERL_NIF_TERM res_term;
  memcpy(enif_make_new_binary(env, res_strlen, &res_term),
         res,
         res_strlen);
  mpd_free(res);

  return res_term;
}


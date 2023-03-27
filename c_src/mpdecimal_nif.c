#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef _WIN32
#include <unistd.h>
#endif

#include "erl_nif.h"

#include "mpdecimal.h"

// #define NIF_DEBUG

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

int load(ErlNifEnv* caller_env, void** priv_data, ERL_NIF_TERM load_info) {
  setup_mpd_mem_alloc();

  // The default trap handler raises SIGFPE. While the BEAM VM happens to
  // ignore SIGFPE (as of OTP 21), it's a bit safer not to rely on this
  // behavior and just not raise SIGFPE at all.
  mpd_traphandler = mpd_custom_traphandler;

  mpd_context_t* ctx = *priv_data = mpd_sh_alloc(sizeof(mpd_context_t), 1, 1);

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

int upgrade(ErlNifEnv* caller_env, void** priv_data, void** old_priv_data, ERL_NIF_TERM load_info) {
  *priv_data = *old_priv_data;
  return 0;
}

void unload(ErlNifEnv* caller_env, void* priv_data) {
  enif_free(priv_data);
  return;
}

#ifdef NIF_DEBUG
static void nif_debug_print_data_hex(const unsigned char* data, size_t size)
{
  const unsigned char* end = data + size;
  while (data < end) {
  	printf("0x%02x ", *(data++));
  }
  printf("\r\n");
}

static void nif_debug_print_parameter(const char* name, const ERL_NIF_TERM* term, const ErlNifBinary* binary)
{
  printf(              "%s\r\n" \
                       "  raw       ", name);
  nif_debug_print_data_hex(binary->data, binary->size);

  enif_fprintf(stdout, "\r\n" \
                       "  binary    %T\r\n" \
                       "    size    %d bytes\r\n\n",
                       *term,
                       binary->size);

  printf(              "  cstring   %s\r\n" \
                       "    length  %zu characters\r\n\n",
                       binary->data,
                       strlen((char*) binary->data));
}
#endif

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

static ERL_NIF_TERM mpdecimal_ln(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  ERL_NIF_TERM result_term;
  char* result_string;
  mpd_ssize_t result_strlen;

  ErlNifBinary input_binary;
  
  mpd_context_t ctx;
  mpd_t* input;
  mpd_t* result;

  // Convert parameters into Erlang binaries.
  if (argc != 1 ||
  	  !enif_inspect_binary(env, argv[0], &input_binary)) {
    return enif_make_badarg(env);
  }

#ifdef NIF_DEBUG
  printf("----Parameters----\r\n");
  nif_debug_print_parameter("input", &argv[0], &input_binary);
#endif

  // Ensure Thread Safety
  // Create a copy of the (previously-initialized) MPD context on the stack.
  // Hereafter, any function calls into the mpdecimal library interact with
  // this copy of the context, which is used only by the current thread.
  ctx = *((mpd_context_t*) enif_priv_data(env));

  input = mpd_new(&ctx);
  if (ctx.newtrap) {
    return nif_make_error_tuple(env, &ctx);
  }
  
  // Expects the binary to contain a cstring, properly formatted with the null
  // terminator by Elixir code.
  mpd_set_string(input, (char*) input_binary.data, &ctx);
  if (ctx.newtrap) {
    mpd_del(input);
    return nif_make_error_tuple(env, &ctx);
  }

  result = mpd_new(&ctx);
  if (ctx.newtrap) {
    mpd_del(input);
    return nif_make_error_tuple(env, &ctx);
  }

  mpd_ln(result, input, &ctx);
  mpd_del(input);
  if (ctx.newtrap) {
    mpd_del(result);
    return nif_make_error_tuple(env, &ctx);
  }

  result_strlen = mpd_to_sci_size(&result_string, result, /* fmt */ 1);
  
  mpd_del(result);

  if (result_string == NULL) {
    // Manually add MPD_Malloc_error since mpd_to_sci_size is not context
    // sensitive.
    mpd_addstatus_raise(&ctx, MPD_Malloc_error);
    return nif_make_error_tuple(env, &ctx);
  }

  // Package the result string into an Erlang binary.
  memcpy(enif_make_new_binary(env, result_strlen, &result_term),
         result_string,
         result_strlen);
  mpd_free(result_string);

  return enif_make_tuple2(env, enif_make_atom(env, "ok"), result_term);
}

static ERL_NIF_TERM mpdecimal_power(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  ERL_NIF_TERM result_term;
  char* result_string;
  mpd_ssize_t result_strlen;

  ErlNifBinary base_binary;
  ErlNifBinary exp_binary;
  
  mpd_context_t ctx;
  mpd_t* base;
  mpd_t* exp;
  mpd_t* result;

  // Convert parameters into Erlang binaries.
  if (argc != 2 ||
  	  !enif_inspect_binary(env, argv[0], &base_binary) ||
  	  !enif_inspect_binary(env, argv[1], &exp_binary)) {
    return enif_make_badarg(env);
  }

#ifdef NIF_DEBUG
  printf("----Parameters----\r\n");
  nif_debug_print_parameter("base", &argv[0], &base_binary);
  nif_debug_print_parameter("exp", &argv[1], &exp_binary);
#endif

  // Ensure Thread Safety
  // Create a copy of the (previously-initialized) MPD context on the stack.
  // Hereafter, any function calls into the mpdecimal library interact with
  // this copy of the context, which is used only by the current thread.
  ctx = *((mpd_context_t*) enif_priv_data(env));

  base = mpd_new(&ctx);
  if (ctx.newtrap) {
    return nif_make_error_tuple(env, &ctx);
  }
  
  // Expects the binary to contain a cstring, properly formatted with the null
  // terminator by Elixir code.
  mpd_set_string(base, (char*) base_binary.data, &ctx);
  if (ctx.newtrap) {
    mpd_del(base);
    return nif_make_error_tuple(env, &ctx);
  }

  exp = mpd_new(&ctx);
  if (ctx.newtrap) {
    mpd_del(base);
    return nif_make_error_tuple(env, &ctx);
  }

  // Expects the binary to contain a cstring, properly formatted with the null
  // terminator by Elixir code.
  mpd_set_string(exp, (char*) exp_binary.data, &ctx);
  if (ctx.newtrap) {
    mpd_del(base);
    mpd_del(exp);
    return nif_make_error_tuple(env, &ctx);
  }

  result = mpd_new(&ctx);
  if (ctx.newtrap) {
    mpd_del(base);
    mpd_del(exp);
    return nif_make_error_tuple(env, &ctx);
  }

  mpd_pow(result, base, exp, &ctx);
  mpd_del(base);
  mpd_del(exp);
  if (ctx.newtrap) {
    mpd_del(result);
    return nif_make_error_tuple(env, &ctx);
  }

  result_strlen = mpd_to_sci_size(&result_string, result, /* fmt */ 1);
  
  mpd_del(result);

  if (result_string == NULL) {
    // Manually add MPD_Malloc_error since mpd_to_sci_size is not context
    // sensitive.
    mpd_addstatus_raise(&ctx, MPD_Malloc_error);
    return nif_make_error_tuple(env, &ctx);
  }

  // Package the result string into an Erlang binary.
  memcpy(enif_make_new_binary(env, result_strlen, &result_term),
         result_string,
         result_strlen);
  mpd_free(result_string);

  return enif_make_tuple2(env, enif_make_atom(env, "ok"), result_term);
}

static ErlNifFunc funcs[] = {
  // {name, arity, fptr}
  {"ln", 1, mpdecimal_ln},
  {"power", 2, mpdecimal_power}
};


ERL_NIF_INIT(Elixir.MPDecimal.Nif, funcs, load, /* reload (deprecated) */ NULL, upgrade, unload)

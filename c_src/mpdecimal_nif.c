#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef _WIN32
#include <unistd.h>
#endif

#include "erl_nif.h"

#include "mpdecimal.h"

#define NIF_DEBUG

// TODO: Pass the precision in as an argument in load_info.
int load(ErlNifEnv* caller_env, void** priv_data, ERL_NIF_TERM load_info) {
	// Use the memory allocator provided by the Erlang VM for all mpd memory.
	mpd_mallocfunc = enif_alloc;
	mpd_reallocfunc = enif_realloc;
	// Since enif_calloc is not implemented, emulate mpd_calloc.
	mpd_callocfunc = mpd_callocfunc_em;
	mpd_free = enif_free;

 	mpd_context_t* ctx = *priv_data = mpd_sh_alloc(sizeof(mpd_context_t), 1, 1);

	// Initialize the MPD context with 28 digits of precision.
	mpd_init(ctx, 28);
	ctx->traps = MPD_Errors;
	if (ctx->status || ctx->newtrap) {
		return 1;
	}
  
	return 0;
}

void unload(ErlNifEnv* caller_env, void* priv_data) {
	enif_free(priv_data);
	return;
}

int upgrade(ErlNifEnv* caller_env, void** priv_data, void** old_priv_data, ERL_NIF_TERM load_info) {
	return load(caller_env, old_priv_data, load_info);
}

#ifdef NIF_DEBUG
static void printf_data_hex(const unsigned char* data, size_t size)
{
	const unsigned char* end = data + size;
	while (data < end) {
		printf("0x%02x ", *(data++));
	}
	printf("\r\n");
}
#endif

static ERL_NIF_TERM mpdecimal_power(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
	// TODO: Review which of these should be dynamically allocated vs. allocated on the stack.
	mpd_context_t* ctx = (mpd_context_t*) enif_priv_data(env);
	mpd_t* base;
	mpd_t* exponent;
	mpd_t* result;
	char*  result_string;
#ifdef NIF_DEBUG
	char status_string[MPD_MAX_FLAG_STRING];
#endif
  ErlNifBinary base_binary;
  ErlNifBinary exponent_binary;
  ERL_NIF_TERM return_value;

	// Convert parameters into Erlang binaries.
  if (argc != 2 ||
		  !enif_inspect_binary(env, argv[0], &base_binary) ||
		  !enif_inspect_binary(env, argv[1], &exponent_binary)) {
    return enif_make_badarg(env);
  }

#ifdef NIF_DEBUG
	printf("----Parameters----\r\n");
  enif_fprintf(stdout, "base (binary): %T\r\n", argv[0]);
	printf("  - size: %zu\r\n", base_binary.size);
	printf("  - encoding: ");
	printf_data_hex(base_binary.data, base_binary.size);

  enif_fprintf(stdout, "exponent (binary): %T\r\n", argv[1]);
	printf("  - size: %zu\r\n", exponent_binary.size);
	printf("  - encoding: ");
	printf_data_hex(exponent_binary.data, exponent_binary.size);
#endif

  base = mpd_new(ctx);
	exponent = mpd_new(ctx);

	mpd_set_string(base, (char*) base_binary.data, ctx);
#ifdef NIF_DEBUG
	mpd_snprint_flags(status_string, MPD_MAX_FLAG_STRING, ctx->status);
  result_string = mpd_to_sci(base, 1);
  printf("base (mpd):   %s\r\n", result_string);
	printf("  - status: %s\r\n", status_string);
#endif

	mpd_set_string(exponent, (char*) exponent_binary.data, ctx);
#ifdef NIF_DEBUG
	mpd_snprint_flags(status_string, MPD_MAX_FLAG_STRING, ctx->status);
  result_string = mpd_to_sci(exponent, 1);
  printf("power (mpd):  %s\r\n", result_string);
	printf("  - status: %s\r\n", status_string);
#endif

#ifdef NIF_DEBUG
	printf("\r\n----Perfoming the calculation----\r\n");
#endif

	// TODO: Use the quiet version of mpd_pow in order to avoid polluting the
	// shared context. (This makes us thread safe.)
 	result = mpd_new(ctx);
	mpd_pow(result, base, exponent, ctx);

  // Convert result to cstring.
	result_string = mpd_to_sci(result, 1);
#ifdef NIF_DEBUG
  printf("result (mpd): %s\r\n", result_string);
	mpd_snprint_flags(status_string, MPD_MAX_FLAG_STRING, ctx->status);
	printf("  - status: %s\r\n", status_string);
#endif
  unsigned char* bin_ptr = enif_make_new_binary(env, strlen(result_string), &return_value);
  memcpy(bin_ptr, result_string, strlen(result_string));

	mpd_del(base);
	mpd_del(exponent);
	mpd_del(result);
	mpd_free(result_string);

	return return_value;
}

static ErlNifFunc nif_funcs[] = {
  // {erl_function_name, erl_function_arity, c_function}
  {"power", 2, mpdecimal_power}
};

ERL_NIF_INIT(Elixir.MPDecimal.Nif, nif_funcs, load, /* reload deprecated since OTP20 */ NULL, upgrade, unload)

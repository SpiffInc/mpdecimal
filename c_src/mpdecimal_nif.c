#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef _WIN32
#include <unistd.h>
#endif

// #define NIF_DEBUG

#include "erl_nif.h"

#include "mpdecimal.h"

static mpd_context_t ctx;

static int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
	// TODO: Because the MPD context is persistent, status flags and error
	// conditions will accumulate across multiple calls into this library. Do we
	// need to do maintenance of any kind on these flags?
	mpd_init(&ctx, 28);
	ctx.traps = 0;
  return 0;
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
  mpd_t *a, *b;
	mpd_t *result;
	char *rstring;
#ifdef NIF_DEBUG
	char status_str[MPD_MAX_FLAG_STRING];
#endif
  ErlNifBinary base;
  ErlNifBinary power;
  ERL_NIF_TERM return_value;

	// Convert parameters into Erlang binaries.
  if (argc != 2 ||
		  !enif_inspect_binary(env, argv[0], &base) ||
		  !enif_inspect_binary(env, argv[1], &power)) {
    return enif_make_badarg(env);
  }

#ifdef NIF_DEBUG
	printf("----Parameters----\r\n");
  enif_fprintf(stdout, "base (binary): %T\r\n", argv[0]);
	printf("  - size: %zu\r\n", base.size);
	printf("  - encoding: ");
	printf_data_hex(base.data, base.size);

  enif_fprintf(stdout, "power (binary): %T\r\n", argv[1]);
	printf("  - size: %zu\r\n", power.size);
	printf("  - encoding: ");
	printf_data_hex(power.data, power.size);
#endif

#ifdef NIF_DEBUG
	printf("\r\n----Converting parameters from Erlang binary to cstring----\r\n");
#endif
	// This relies on the property that the Erlang binary encoding uses only
	// single-byte ASCII-compatible values.
	// 
	// TODO: Add checks to validate that the string contains only valid ASCII
	// characters. (i.e. Assert that the above property is true.)
	//
	// Allocate the same number of bytes as used by the Erlang binary, plus one
	// for the null terminator.
	char* base_cstring = (char*) enif_alloc((base.size + 1)*sizeof(char));
	char* power_cstring = (char*) enif_alloc((power.size + 1)*sizeof(char));
	strncpy(base_cstring, (char*) base.data, base.size);
	strncpy(power_cstring, (char*) power.data, power.size);
	// Manually add null terminator to each string.
	base_cstring[base.size] = '\0';
	power_cstring[power.size] = '\0';

#ifdef NIF_DEBUG
	printf("base (cstring):  %s\r\n", base_cstring);
	printf("  - encoding: ");
	printf_data_hex((unsigned char*) base_cstring, base.size + 1);
	printf("power (cstring): %s\r\n", power_cstring);
	printf("  - encoding: ");
	printf_data_hex((unsigned char*) power_cstring, power.size + 1);
#endif

#ifdef NIF_DEBUG
	printf("\r\n----Converting parameters from cstring to mpd----\r\n");
	mpd_snprint_flags(status_str, MPD_MAX_FLAG_STRING, ctx.status);
	printf("Inital mpd status: %s\r\n", status_str);
#endif
  a = mpd_new(&ctx);
	b = mpd_new(&ctx);
	mpd_set_string(a, base_cstring, &ctx);
#ifdef NIF_DEBUG
	mpd_snprint_flags(status_str, MPD_MAX_FLAG_STRING, ctx.status);
  rstring = mpd_to_sci(a, 1);
  printf("base (mpd):   %s\r\n", rstring);
	printf("  - status: %s\r\n", status_str);
#endif
	mpd_set_string(b, power_cstring, &ctx);
#ifdef NIF_DEBUG
	mpd_snprint_flags(status_str, MPD_MAX_FLAG_STRING, ctx.status);
  rstring = mpd_to_sci(b, 1);
  printf("power (mpd):  %s\r\n", rstring);
	printf("  - status: %s\r\n", status_str);
#endif

#ifdef NIF_DEBUG
	printf("\r\n----Perfoming the calculation----\r\n");
#endif
  result = mpd_new(&ctx);
	mpd_pow(result, a, b, &ctx);

  // Convert result to cstring.
	rstring = mpd_to_sci(result, 1);
#ifdef NIF_DEBUG
  printf("result (mpd): %s\r\n", rstring);
	mpd_snprint_flags(status_str, MPD_MAX_FLAG_STRING, ctx.status);
	printf("  - status: %s\r\n", status_str);
#endif
  unsigned char* bin_ptr = enif_make_new_binary(env, strlen(rstring), &return_value);
  memcpy(bin_ptr, rstring, strlen(rstring));

  // Clean up mpdecimal memory.
	mpd_del(a);
	mpd_del(b);
	mpd_del(result);
	mpd_free(rstring);

	// Clean up memory that was allocated locally.
	enif_free(base_cstring);
	enif_free(power_cstring);
	
	return return_value;
}

static ErlNifFunc nif_funcs[] = {
  // {erl_function_name, erl_function_arity, c_function}
  {"power", 2, mpdecimal_power}
};

ERL_NIF_INIT(Elixir.MPDecimal.Nif, nif_funcs, load, NULL, NULL, NULL)

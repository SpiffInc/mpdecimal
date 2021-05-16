#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef _WIN32
#include <unistd.h>
#endif

#define NIF_DEBUG

#include "erl_nif.h"

#include "mpdecimal.h"

static mpd_context_t ctx;

static int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
  mpd_init(&ctx, 28);
	ctx.traps = 0;
  return 0;
}

static ERL_NIF_TERM mpdecimal_power(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  mpd_t *a, *b;
	mpd_t *result;
	char *rstring;
	char status_str[MPD_MAX_FLAG_STRING];
  ErlNifBinary base;
  ErlNifBinary power;
  ERL_NIF_TERM return_value;

  if(argc != 2 ||
    !enif_is_binary(env, argv[0]) ||
    !enif_is_binary(env, argv[1])) {
    return enif_make_badarg(env);
  }

  #ifdef NIF_DEBUG
  enif_fprintf(stdout, "base  (as binary): %T\r\n", argv[0]);
  enif_fprintf(stdout, "power (as binary): %T\r\n", argv[1]);
  #endif

  // convert elixir string arguments into mpdecimal structs
  enif_inspect_binary(env, argv[0], &base);
  enif_inspect_binary(env, argv[1], &power);

  #ifdef NIF_DEBUG
  fprintf(stdout, "base  (as cstring): %s\r\n  - binary size: %d\r\n  - cstring strlen: %d\r\n", base.data, base.size, strlen(base.data));
  fprintf(stdout, "power (as cstring): %s\r\n  - binary size: %d\r\n  - cstring strlen: %d\r\n", power.data, power.size, strlen(power.data));

	fprintf(stdout, "base encoding:  ");
	unsigned char* index = base.data;
	do {
		fprintf(stdout, "0x%02x ", *index);
	} while (*(index++) != 0);
	fprintf(stdout, "\r\n");

	fprintf(stdout, "power encoding: ");
	index = power.data;
	do {
		fprintf(stdout, "0x%02x ", *index);
	} while (*(index++) != 0);
	fprintf(stdout, "\r\n");
  #endif

	// This relies on the property that the Erlang binary encoding uses only
	// single-byte ASCII-compatible values.
	// 
	// TODO: Check whether the source of this data (Elixir Decimal library)
	// guarantees this property.
	char* base_cstring = (char*) malloc((base.size + 1)*sizeof(char));
	char* power_cstring = (char*) malloc((power.size + 1)*sizeof(char));
	strncpy(base_cstring, base.data, base.size);
	strncpy(power_cstring, power.data, power.size);

  a = mpd_new(&ctx);
	b = mpd_new(&ctx);
	mpd_set_string(a, base_cstring, &ctx);
	mpd_set_string(b, power_cstring, &ctx);

  #ifdef NIF_DEBUG
  rstring = mpd_to_sci(a, 1);
  enif_fprintf(stdout, "mpd base: %s\r\n", rstring);
  rstring = mpd_to_sci(b, 1);
  enif_fprintf(stdout, "mpd power: %s\r\n", rstring);
  #endif

  // run the calculation
  result = mpd_new(&ctx);
	mpd_pow(result, a, b, &ctx);

  // convert result to an elixir string
	rstring = mpd_to_sci(result, 1);
  #ifdef NIF_DEBUG
  enif_fprintf(stdout, "mpd result: %s\r\n", rstring);
  #endif
	mpd_snprint_flags(status_str, MPD_MAX_FLAG_STRING, ctx.status);
  unsigned char* bin_ptr = enif_make_new_binary(env, strlen(rstring), &return_value);
  strcpy(bin_ptr, rstring);

  // cleanup mpdecimal memory
	mpd_del(a);
	mpd_del(b);
	mpd_del(result);
	mpd_free(rstring);

	// Clean up locally-used memory.
	free(base_cstring);
	free(power_cstring);
	
	return return_value;
}

static ErlNifFunc nif_funcs[] = {
  // {erl_function_name, erl_function_arity, c_function}
  {"power", 2, mpdecimal_power}
};

ERL_NIF_INIT(Elixir.MPDecimal.Nif, nif_funcs, load, NULL, NULL, NULL)

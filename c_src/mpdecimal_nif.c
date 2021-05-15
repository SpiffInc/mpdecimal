#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef _WIN32
#include <unistd.h>
#endif

#include "erl_nif.h"

#include "mpdecimal.h"

static ERL_NIF_TERM mpdecimal_zero(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  const char* version = mpd_version();
	enif_fprintf(stdout,"libmpdec version: %s\n",version);
  return enif_make_int(env, 0);
}

static ERL_NIF_TERM mpdecimal_power(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  mpd_context_t ctx;
  mpd_t *a, *b;
	mpd_t *result;
	char *rstring;
	char status_str[MPD_MAX_FLAG_STRING];
  ErlNifBinary base;
  ErlNifBinary power;
  ERL_NIF_TERM return_value;

  // convert elixir string arguments into mpdecimal structs
  enif_inspect_binary(env, argv[0], &base);
  enif_inspect_binary(env, argv[1], &power);

  printf("%s ^ %s\n", base.data, power.data);

  // setup context
  mpd_init(&ctx, 28);
	ctx.traps = 0;
  a = mpd_new(&ctx);
	b = mpd_new(&ctx);
	mpd_set_string(a, base.data, &ctx);
	mpd_set_string(b, power.data, &ctx);

  // run the calculation
  result = mpd_new(&ctx);
	mpd_pow(result, a, b, &ctx);

  // convert result to an elixir string
	rstring = mpd_to_sci(result, 1);
	mpd_snprint_flags(status_str, MPD_MAX_FLAG_STRING, ctx.status);
	printf("%s  %s\n", rstring, status_str);
  unsigned char* bin_ptr = enif_make_new_binary(env, strlen(rstring), &return_value);
  strcpy(bin_ptr, rstring);

  // cleanup mpdecimal memory
	mpd_del(a);
	mpd_del(b);
	mpd_del(result);
	mpd_free(rstring);

	return return_value;
}

static ErlNifFunc nif_funcs[] = {
  // {erl_function_name, erl_function_arity, c_function}
  {"power", 2, mpdecimal_power},
  {"zero", 0, mpdecimal_zero}
};

ERL_NIF_INIT(Elixir.MPDecimal.Nif, nif_funcs, NULL, NULL, NULL, NULL)

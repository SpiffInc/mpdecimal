#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef _WIN32
#include <unistd.h>
#endif

#include "erl_nif.h"

static ERL_NIF_TERM mpdecimal_zero(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  int a = 42;
  return enif_make_int(env, a);
}

static ErlNifFunc nif_funcs[] = {
  // {erl_function_name, erl_function_arity, c_function}
  {"mpdecimal_zero", 0, mpdecimal_zero}
};

ERL_NIF_INIT(Elixir.MPDecimal, nif_funcs, NULL, NULL, NULL, NULL)
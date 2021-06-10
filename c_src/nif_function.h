#ifndef NIF_FUNCTION_H
#define NIF_FUNCTION_H

#define NIF_FUNCTION_NAME(function) mpdecimal_##function

#define NIF_FUNCTION_HEADER(function) \
ERL_NIF_TERM NIF_FUNCTION_NAME(function)(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])

#define NIF_FUNCTION_DECLARE(function, argc_in, argc_out, retc) \
  NIF_FUNCTION_HEADER(function);

#define MPDECIMAL_FUNCTION NIF_FUNCTION_DECLARE
#include "mpdecimal_function.h"
#undef MPDECIMAL_FUNCTION

#endif


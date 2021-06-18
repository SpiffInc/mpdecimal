#ifndef NIF_FUNCTION_H
#define NIF_FUNCTION_H

#define NIF_FUNCTION_NAME(function) mpdecimal_##function

#define NIF_FUNCTION_HEADER(function) \
ERL_NIF_TERM NIF_FUNCTION_NAME(function)(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])

#define NIF_FUNCTION_DECLARE(function, argc_in, argc_out) \
  NIF_FUNCTION_HEADER(function);

#define NIF_FUNCTION_CUSTOM_DECLARE(function, argc_in) \
  NIF_FUNCTION_HEADER(function);

#define NIF_FUNCTION NIF_FUNCTION_DECLARE
#include "nif_interface.h"
#undef NIF_FUNCTION

#define NIF_FUNCTION NIF_FUNCTION_CUSTOM_DECLARE
#include "nif_interface_custom.h"
#undef NIF_FUNCTION

#endif


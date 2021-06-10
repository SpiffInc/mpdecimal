#ifndef NIF_FUNCTION_REGISTER_H
#define NIF_FUNCTION_REGISTER_H

#include "nif_function.h"

#define ERL_FUNCTION_NAME(function) "##function##"

#define NIF_FUNCTION_REGISTER(function, argc_in, argc_out, retc) \
  {ERL_FUNCTION_NAME(function), argc_in, NIF_FUNCTION_NAME(function)},

ErlNifFunc funcs[] = {
  // {name, arity, fptr}
#define MPDECIMAL_FUNCTION NIF_FUNCTION_REGISTER
#include "mpdecimal_function.h"
#undef MPDECIMAL_FUNCTION
};

#endif


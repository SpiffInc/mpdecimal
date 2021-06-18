#ifndef NIF_FUNCTION_REGISTER_H
#define NIF_FUNCTION_REGISTER_H

#include "nif_function.h"

#define STRING(function) #function

#define ERL_FUNCTION_NAME(function) STRING(_##function)

#define NIF_FUNCTION_REGISTER(function, argc_in, argc_out) \
  {ERL_FUNCTION_NAME(function), argc_in, NIF_FUNCTION_NAME(function)},

#define NIF_FUNCTION_CUSTOM_REGISTER(function, argc_in) \
  {ERL_FUNCTION_NAME(function), argc_in, NIF_FUNCTION_NAME(function)},

ErlNifFunc funcs[] = {
  // {name, arity, fptr}
#define NIF_FUNCTION NIF_FUNCTION_REGISTER
#include "nif_interface.h"
#undef NIF_FUNCTION

#define NIF_FUNCTION NIF_FUNCTION_CUSTOM_REGISTER
#include "nif_interface_custom.h"
#undef NIF_FUNCTION
};

#endif


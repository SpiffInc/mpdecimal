#ifdef NIF_DEBUG
#define NIF_DEBUG_PARAM_1                       \
  printf("----Parameter----\r\n");              \
  nif_debug_print_parameter("a", &argv[0], &a);

#define NIF_DEBUG_PARAM_2                       \
  printf("----Parameters----\r\n");             \
  nif_debug_print_parameter("a", &argv[0], &a); \
  nif_debug_print_parameter("b", &argv[1], &b);
#else
#define NIF_DEBUG_PARAM_1
#define NIF_DEBUG_PARAM_2
#endif

#define NIF_PROCESS_PARAM_1                     \
  ErlNifBinary a;                               \
  if ((argc != 1) ||                            \
      !enif_inspect_binary(env, argv[0], &a)) { \
    return enif_make_badarg(env);               \
  }                                             \
  NIF_DEBUG_PARAM_1

#define NIF_PROCESS_PARAM_2                     \
  ErlNifBinary a;                               \
  ErlNifBinary b;                               \
  if ((argc != 2) ||                            \
      !enif_inspect_binary(env, argv[0], &a) || \
      !enif_inspect_binary(env, argv[1], &b)) { \
    return enif_make_badarg(env);               \
  }                                             \
  NIF_DEBUG_PARAM_2

// Convert parameters into Erlang binaries.
#define NIF_PROCESS_PARAM(n) NIF_PROCESS_PARAM_##n

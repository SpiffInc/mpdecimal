#ifdef NIF_DEBUG
#define NIF_DEBUG_PARAM_1                                                     \
  printf("----Parameter----\r\n");                                            \
  nif_debug_print_parameter("a", &argv[0], &a_binary);

#define NIF_DEBUG_PARAM_2                                                     \
  printf("----Parameters----\r\n");                                           \
  nif_debug_print_parameter("a", &argv[0], &a_binary);                        \
  nif_debug_print_parameter("b", &argv[1], &b_binary);
#else
#define NIF_DEBUG_PARAM_1
#define NIF_DEBUG_PARAM_2
#endif

#define NIF_PROCESS_PARAM_1                                                   \
  const ErlNifBinary a_binary;                                                \
  const mpd_t* a;                                                             \
  if ((argc != 1) ||                                                          \
      !enif_inspect_binary(env, argv[0], (ErlNifBinary*) &a_binary)) {        \
    return enif_make_badarg(env);                                             \
  }                                                                           \
  NIF_DEBUG_PARAM_1                                                           \
  a = (mpd_t*) a_binary.data;

#define NIF_PROCESS_PARAM_2                                                   \
  const ErlNifBinary a_binary;                                                \
  const ErlNifBinary b_binary;                                                \
  const mpd_t* a;                                                             \
  const mpd_t* b;                                                             \
  if ((argc != 2) ||                                                          \
      !enif_inspect_binary(env, argv[0], (ErlNifBinary*) &a_binary) ||        \
      !enif_inspect_binary(env, argv[1], (ErlNifBinary*) &b_binary)) {        \
    return enif_make_badarg(env);                                             \
  }                                                                           \
  NIF_DEBUG_PARAM_2                                                           \
  a = (mpd_t*) a_binary.data;                                                 \
  b = (mpd_t*) b_binary.data;

// Convert parameters into Erlang binaries.
#define NIF_PROCESS_PARAM(n) NIF_PROCESS_PARAM_##n

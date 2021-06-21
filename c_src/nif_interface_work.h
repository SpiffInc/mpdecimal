// Start with single input, single output functions.
// MPD_NIF(function, input, output)

//-----------------------------------------------------------------------------
// Quiet Functions
//-----------------------------------------------------------------------------
/*
mpd_adjexp              // in: const mpd_t*                         out: mpd_ssize_t
mpd_alloc               // Not Exported (Memory Model)
mpd_arith_sign          // in: const mpd_t*                         out: int
mpd_as_uint128_triple   // TODO
mpd_basiccontext        // TODO
mpd_calloc              // Not Exported (Memory Model)
mpd_class               // in: const mpd_t*                         out: const char*
mpd_clear_flags         // Not Exported (Low Level)
mpd_cmp_total           // in: mpd_t*, mpd_t*                       out: int
mpd_cmp_total_mag       // in: mpd_t*, mpd_t*                       out: int
mpd_compare_total       // in: mpd_t*, mpd_t*                       out: mpd_t*
mpd_compare_total_mag   // in: mpd_t*, mpd_t*                       out: mpd_t*
mpd_copy_flags          // Not Exported (Low Level)
mpd_defaultcontext      // TODO
mpd_del                 // Not Exported (Memory Model)
mpd_digits_to_size      // Not Exported (Low Level)
mpd_etiny               // in: const mpd_context_t*                 out: mpd_ssize_t
mpd_etop                // in: const mpd_context_t*                 out: mpd_ssize_t
mpd_exp_digits          // in: mpd_ssize_t                          out: int
mpd_fprint              // Not Exported (Debug)
mpd_from_uint128_triple // TODO
mpd_getclamp            // in: const mpd_context_t*                 out: int
mpd_getcr               // in: const mpd_context_t*                 out: int
mpd_getemax             // in: const mpd_context_t*                 out: mpd_ssize_t
mpd_getemin             // in: const mpd_context_t*                 out: mpd_ssize_t
mpd_getprec             // in: const mpd_context_t*                 out: size_t
mpd_getround            // in: const mpd_context_t*                 out: int
mpd_getstatus           // in: const mpd_context_t*                 out: uint32_t
mpd_gettraps            // in: const mpd_context_t*                 out: mpd_ssize_t
mpd_ieee_context        // in: mpd_context_t*, int                  out: int
mpd_iscanonical         // in: const mpd_t*                         out: int
mpd_isconst_data        // Not Exported (Memory Model)
mpd_isdynamic           // Not Exported (Memory Model)
mpd_isdynamic_data      // Not Exported (Memory Model)
*/

#define NIF_TYPE_C_RET_INT int

#define NIF_TYPE_C_ARG_CONST_MPD_T_P const mpd_t**

#define NIF_GET_ERL_IN_RESOURCE_MPD_T(argn, arg_var) \
  enif_get_resource(env, argv[argn], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &arg_var)

#define NIF_GET_ARG(argn, arg_var, arg_ERL_type) \
  NIF_GET_##arg_ERL_type(argn, arg_var)

#define MPD_NIF_HEADER_1RET_1ARG(ret_var, ret_C_type, arg0_var, arg0_C_type, arg0_ERL_type) \
  NIF_TYPE_##ret_C_type ret_var;                                                            \
  NIF_TYPE_##arg0_C_type arg0_var;                                                          \
  if ((argc != 1) ||                                                                        \
      NIF_GET_ARG(0, arg0_var, arg0_ERL_type)) {                                            \
    return enif_make_badarg(env);                                                           \
  }

#define MPD_FUNCTION_1RET_1ARG(function, ret_var, arg_var) \
  ret_var = (function)(arg_var);

#define MPD_NIF_RETURN__C_RET_INT__ERL_OUT_BOOLEAN(ret_var) \
  return enif_make_boolean(env, ret_var);

#define MPD_NIF_RETURN(ret_var, ret_C_type, ret_ERL_type) \
  MPD_NIF_RETURN__##ret_C_type##__##ret_ERL_type(ret_var)

#define MPD_NIF_DEFINE(function, ret_var, ret_C_type, ret_ERL_type, arg0_var, arg0_C_type, arg0_ERL_type) \
  MPD_NIF_HEADER_1RET_1ARG(ret_var, ret_C_type, arg0_var, arg0_C_type, arg0_ERL_type)                     \
  MPD_FUNCTION_1RET_1ARG(function, ret_var, arg0_var)                                                     \
  MPD_NIF_RETURN(ret_var, ret_C_type, ret_ERL_type)

#define MPD_NIF MPD_NIF_DEFINE

MPD_NIF(mpd_iseven, result, C_RET_INT,           ERL_OUT_BOOLEAN,
                    dec,    C_ARG_CONST_MPD_T_P, ERL_IN_RESOURCE_MPD_T)

// Format: LANGUAGE_DIRECTION_TYPE

// MPD_NIF(mpd_iseven, C_ARG_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_OUT_BOOLEAN)
// MPD_NIF(mpd_isfinite,    C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isinfinite,  C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isinteger,   C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isnan,       C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isnegative,  C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isnormal,    C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isodd,       C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isoddcoeff,  C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isoddword,   C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_ispositive,  C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isqnan,      C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// mpd_isshared_data       // Not Exported (Memory Model)
// MPD_NIF(mpd_issigned,    C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_issnan,      C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_isspecial,   C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// mpd_isstatic            // Not Exported (Memory Model)
// mpd_isstatic_data       // Not Exported (Memory Model)
// mpd_issubnormal         // in: const mpd_t*, const mpd_context_t*   out: int
// MPD_NIF(mpd_iszero,      C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
// MPD_NIF(mpd_iszerocoeff, C_CONST_MPD_T_P__ERL_IN_RESOURCE_MPD_T, C_RET_INT__ERL_BOOLEAN)
/*
mpd_lsd                 // in: mpd_uint_t                           out: mpd_uint_t
mpd_lsnprint_flags      // TODO
mpd_lsnprint_signals    // TODO
mpd_maxcontext          // TODO
mpd_minalloc            // Not Exported (Memory Model)
mpd_msd                 // in: mpd_uint_t                           out: mpd_uint_t
mpd_msword              // in: const mpd_t*                         out: mpd_uint_t
mpd_print               // Not Exported (Debug)
mpd_qabs
mpd_qabs_uint
mpd_qadd
mpd_qadd_i32
mpd_qadd_i64
mpd_qadd_ssize
mpd_qadd_u32
mpd_qadd_u64
mpd_qadd_uint
mpd_qand
mpd_qceil
mpd_qcheck_nan
mpd_qcheck_nans
mpd_qcmp
mpd_qcompare
mpd_qcompare_signal
mpd_qcopy
mpd_qcopy_abs
mpd_qcopy_negate
mpd_qcopy_sign
mpd_qdiv
mpd_qdiv_i32
mpd_qdiv_i64
mpd_qdiv_ssize
mpd_qdiv_u32
mpd_qdiv_u64
mpd_qdiv_uint
mpd_qdivint
mpd_qdivmod
mpd_qexp
mpd_qexport_u16
mpd_qexport_u32
mpd_qfinalize
mpd_qfloor
mpd_qfma
mpd_qformat
mpd_qget_i32
mpd_qget_i64
mpd_qget_ssize
mpd_qget_u32
mpd_qget_u64
mpd_qget_uint
mpd_qimport_u16
mpd_qimport_u32
mpd_qinvert
mpd_qinvroot
mpd_qln
mpd_qlog10
mpd_qlogb
mpd_qmax
mpd_qmax_mag
mpd_qmaxcoeff
mpd_qmin
mpd_qmin_mag
mpd_qminus
mpd_qmul
mpd_qmul_i32
mpd_qmul_i64
mpd_qmul_ssize
mpd_qmul_u32
mpd_qmul_u64
mpd_qmul_uint
mpd_qncopy
mpd_qnew
mpd_qnew_size
mpd_qnext_minus
mpd_qnext_plus
mpd_qnext_toward
mpd_qor
mpd_qplus
mpd_qpow
mpd_qpowmod
mpd_qquantize
mpd_qreduce
mpd_qrem
mpd_qrem_near
mpd_qrescale
mpd_qresize
mpd_qresize_zero
mpd_qrotate
mpd_qround_to_int
mpd_qround_to_intx
mpd_qscaleb
mpd_qset_i32
mpd_qset_i64
mpd_qset_i64_exact
mpd_qset_ssize
mpd_qset_string
mpd_qset_string_exact
mpd_qset_u32
mpd_qset_u64
mpd_qset_u64_exact
mpd_qset_uint
mpd_qsetclamp
mpd_qsetcr
mpd_qsetemax
mpd_qsetemin
mpd_qsetprec
mpd_qsetround
mpd_qsetstatus
mpd_qsettraps
mpd_qshift
mpd_qshiftl
mpd_qshiftn
mpd_qshiftr
mpd_qshiftr_inplace
mpd_qsqrt
mpd_qsset_i32
mpd_qsset_i64
mpd_qsset_ssize
mpd_qsset_u32
mpd_qsset_u64
mpd_qsset_uint
mpd_qsub
mpd_qsub_i32
mpd_qsub_i64
mpd_qsub_ssize
mpd_qsub_u32
mpd_qsub_u64
mpd_qsub_uint
mpd_qtrunc
mpd_qxor
mpd_radix               // in: (void)                               out: long
mpd_realloc             // Not Exported (Memory Model)
mpd_same_quantum        // const mpd_t*, const mpd_t*               out: int
mpd_set_const_data      // Not Exported (Memory Model)
mpd_set_dynamic         // Not Exported (Memory Model)
mpd_set_dynamic_data    // Not Exported (Memory Model)
mpd_set_flags           // Not Exported (Low Level)
mpd_set_infinity        // Not Exported (Low Level)
mpd_set_negative        // Not Exported (Low Level)
mpd_set_positive        // Not Exported (Low Level)
mpd_set_qnan            // Not Exported (Low Level)
mpd_set_shared_data     // Not Exported (Memory Model)
mpd_set_sign            // Not Exported (Low Level)
mpd_set_snan            // Not Exported (Low Level)
mpd_set_static          // Not Exported (Memory Model)
mpd_set_static_data     // Not Exported (Low Level)
mpd_setdigits           // Not Exported (Low Level)
mpd_seterror            // Not Exported (Low Level [Convenience])
mpd_setspecial          // in: mpd_t*, uint8_t sign, uint8_t type   out: (void)
mpd_sh_alloc            // Not Exported (Memory Model)
mpd_sign                // in: const mpd_t*                         out: uint8_t
mpd_signcpy             // in: mpd_t*, const mpd_t*                 out: (void)
mpd_sizeinbase          // in: const mpd_t*, uint32_t               out: size_t
mpd_snprint_flags       // TODO
mpd_to_eng              // in: const mpd_t*, int                    out: char*
mpd_to_eng_size         // in: char**, const mpd_t*, int            out: mpd_ssize_t
mpd_to_sci              // in: const mpd_t*, int                    out: char*
mpd_to_sci_size         // in: char**, const mpd_t*, int            out: mpd_ssize_t
mpd_trail_zeros         // in: const mpd_t*                         out: mpd_ssize_t
mpd_version             // in: (void)                               out: const char*
mpd_word_digits         // in: mpd_uint_t                           out: int
mpd_zerocoeff           // in: mpd_t*                               out: (void)
*/


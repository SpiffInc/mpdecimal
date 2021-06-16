// Nif functions where the inputs and outputs are not all of type
// resource_mpd_t. The definition for each function is not automatically
// generated.

// NIF_FUNCTION(function, argc_in, argc_out)

NIF_FUNCTION(cmp,           2, 1) // in: resource_mpd_t, resource_mpd_t out: integer
NIF_FUNCTION(is_mpdecimal,  1, 1) // in: resource_mpd_t                 out: boolean
NIF_FUNCTION(isinfinite,    1, 1) // in: resource_mpd_t,                out: boolean
NIF_FUNCTION(isinteger,     1, 1) // in: resource_mpd_t,                out: boolean
NIF_FUNCTION(isnan,         1, 1) // in: resource_mpd_t,                out: boolean
NIF_FUNCTION(ispositive,    1, 1) // in: resource_mpd_t,                out: boolean
NIF_FUNCTION(set_i64,       1, 1) // in: int64_t                        out: resource_mpd_t
NIF_FUNCTION(set_string,    1, 1) // in: char*                          out: resource_mpd_t
NIF_FUNCTION(to_sci,        1, 1) // in: resource_mpd_t,                out: binary
NIF_FUNCTION(to_eng,        1, 1) // in: resource_mpd_t,                out: binary


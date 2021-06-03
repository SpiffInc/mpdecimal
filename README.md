# MPDecimal

An elixir wrapper around the [mpdecimal](https://www.bytereef.org/mpdecimal/) library by Stefan Krah.
This library provides accurate fixed-precision decimal operations as a NIF.


### Build

This NIF is built as a shared library, which is statically linked with the mpdecimal library.

### Scope

Only the power() function is wrapped at this time, other enhancements may wrap more of the functionality of the mpdecimal library.

### Thread Safety

An mpdecimal context is initialized to match the default context of the Elixir Decimal library (precision, rounding mode, traps). This context is copied for each NIF call to ensure that there is no shared mutable data, thus ensuring thread safety. All calls to the mpdecimal library are thread safe, given that no two threads use the same context.

### Memory

The mpdecimal library is configured to use the memory allocator provided by the BEAM VM.

### Execution Time

As a rule of thumb a well-behaving native function should return to its caller before a millisecond has passed. The power() function seems to finish in ~100 μs, so we are an order of magnitude away from needing to worry about manual execution time managment. (Breaking a single behavior into multiple function calls, or calling enif_consume_timeslice())

### TODOS

* Expose more of the functionality of the mpdecimal library.
* Test known edge cases, try to break the library, gain confidence.
* Teach the Makefile to be agnostic to the version of the mpdecimal library that is provided in the c_lib directory.

#ifdef NIF_DEBUG
static void nif_debug_print_data_hex(const unsigned char* data, size_t size)
{
  const unsigned char* end = data + size;
  while (data < end) {
  	printf("0x%02x ", *(data++));
  }
  printf("\r\n");
}

static void nif_debug_print_parameter(const char* name, const ERL_NIF_TERM* term, const ErlNifBinary* binary)
{
  printf(              "%s\r\n" \
                       "  raw       ", name);
  nif_debug_print_data_hex(binary->data, binary->size);

  enif_fprintf(stdout, "\r\n" \
                       "  binary    %T\r\n" \
                       "    size    %d bytes\r\n\n",
                       *term,
                       binary->size);

  printf(              "  cstring   %s\r\n" \
                       "    length  %zu characters\r\n\n",
                       binary->data,
                       strlen((char*) binary->data));
}
#endif


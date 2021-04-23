CFLAGS ?= -g -O3
CFLAGS += -Wall

CFLAGS += -I"$(ERTS_INCLUDE_DIR)"
CFLAGS += -I"$(C_SRC_DIR)"
CFLAGS += -I"$(MPD_LIB_DIR:/=)/libmpdec"

PRIV_DIR = $(MIX_APP_PATH)/priv
LIB_NAME = $(PRIV_DIR)/mpdecimal_nif.so

C_SRC_DIR = c_src
NIF_SRC=$(C_SRC_DIR)/*.c

# Any tar.gz file that is located in C_LIB_DIR is assummed to be the mpdecimal
# library. Some basic information about the directory structure is also
# assummed.
C_LIB_DIR = c_lib
MPD_LIB_TARFILE = $(wildcard $(C_LIB_DIR)/*.tar.gz)
MPD_LIB_DIR = $(C_LIB_DIR)/$(shell tar tzf $(MPD_LIB_TARFILE) | head -1)
MPD_LIB = $(MPD_LIB_DIR:/=)/libmpdec/libmpdec.a

ifneq ($(CROSSCOMPILE),)
    # crosscompiling
    CFLAGS += -fPIC
else
    # not crosscompiling
    ifneq ($(OS),Windows_NT)
        CFLAGS += -fPIC

        ifeq ($(shell uname),Darwin)
            LDFLAGS += -dynamiclib -undefined dynamic_lookup
        endif
    endif
endif

calling_from_make:
	mix compile

all: $(PRIV_DIR) $(LIB_NAME) $(MPD_LIB)

$(LIB_NAME): $(NIF_SRC) $(MPD_LIB)
	$(CC) $(CFLAGS) -shared $(LDFLAGS) $< -o $@ $(MPD_LIB)

$(PRIV_DIR):
	mkdir -p $@

$(MPD_LIB_DIR):
	$(MAKE) -C $(C_LIB_DIR) extract

$(MPD_LIB): $(MPD_LIB_DIR)
	$(MAKE) -C $(C_LIB_DIR)

clean:
	rm -f $(LIB_NAME)
	$(MAKE) -C $(C_LIB_DIR) clean

.PHONY: all clean

OPUS_OPTS = --disable-asm --disable-intrinsics --enable-shared=no
OPUS_CC = emcc
OPUS_BUILD_DIR = build

CC = emcc
OBJS = opus.o
CFLAGS = -Iopus/include

all: opus.js

opus.js: $(OBJS) $(OPUS_BUILD_DIR)/.libs/libopus.a
	$(CC) \
	-O3 \
	-s WASM=1 \
	-s MODULARIZE=1 \
	-s EXPORT_ES6=0 \
	-s ALLOW_MEMORY_GROWTH=1 \
	-s EXTRA_EXPORTED_RUNTIME_METHODS=['ccall'] \
	-o opus.js \
	$^

$(OPUS_BUILD_DIR)/.libs/libopus.a: $(OPUS_BUILD_DIR)/Makefile
	-make -C $(OPUS_BUILD_DIR) CC=$(OPUS_CC)

$(OPUS_BUILD_DIR)/Makefile: $(OPUS_BUILD_DIR) opus/configure
	cd $(OPUS_BUILD_DIR) && \
	../opus/configure $(OPUS_OPTS) && \
	cd ../

$(OPUS_BUILD_DIR):
	mkdir -p $(OPUS_BUILD_DIR)

opus/configure: opus/autogen.sh
	opus/autogen.sh

.PHONY: clean
clean:
	rm -rf build
	rm -f opus.js opus.wasm

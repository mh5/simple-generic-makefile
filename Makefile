# Hi, I am a simple and somewhat generic Makefile. Please read the comments for more information.

# Add me to the root of your project, and then create the empty folders `deps' and `objs' for me

# Here is some stuff that you will need to edit.

# This is the compiler that will be used (replace it with g++ for C++, or keep it as it is for C)
CXX := gcc

# The extention of source files (replace it with cpp for C++, or keep it as it is for C)
EXT := c

# The name of the output binary (replace it with the desired binary name)
# This name must correspond to a source file, e.g., src/server.c or src/server.cpp
BIN := server

# These are the libraries needed for both compilation and linking (replace them with the libraries you need)
# Make sure that the library is recognized by pkg-config
# To list all the libraries recognized by pkg-config, run `pkg-config --list-all'
CLLIBS := glib-2.0 json-glib-1.0 libwebsockets zlib 

# These are the libraries needed only for compiling (you can leave it empty)
CLIBS :=

# These are the libraries needed only for linking (you can leave it empty)
LLIBS :=

# That's probably all what you need to edit here.

# You can now create a /src folder and add your code in it. I'll detect which source files
# require which header files, and I will compile the objects and then link them together to
# generate your binary file. Just don't forget to have a source file that corresponds to the
# desired output binary as mentioned above.

# When your code is ready to compile, just run `make' and the binary will be created in the
# root directory.

CPPFLAGS += $(shell pkg-config ${CLLIBS} ${CLIBS} --cflags)
LDFLAGS += $(shell pkg-config ${CLLIBS} ${LLIBS} --libs)

SOURCES := $(wildcard src/*.$(EXT))
DEPENDS := $(SOURCES:src%.$(EXT)=deps%.d)
OBJECTS := $(DEPENDS:deps%.d=objs%.o)
BINFILE := $(BIN)

all: $(BINFILE)

$(BINFILE): $(OBJECTS)
	@echo "Linking: $(BINFILE)..."
	@$(CXX) $(LDFLAGS) $(OBJECTS) -o $(BINFILE)

$(DEPENDS): deps/%.d: src/%.$(EXT)
	@echo "Generating deps: $@"
	@$(shell printf "objs/`$(CXX) -MM $<`\n" > $@)

ifneq ($(MAKECMDGOALS),clean)
include $(DEPENDS)
endif

$(OBJECTS):
	@echo "Compiling: $@"
	@$(CXX) -c $(CPPFLAGS) $< -o $@

clean:
	@rm $(OBJECTS) $(DEPENDS) $(BINFILE) 2>/dev/null || true

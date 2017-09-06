CXX := gcc
EXT := c
BIN := server

CLLIBS := glib-2.0 json-glib-1.0 libwebsockets zlib 
CLIBS :=
LLIBS :=

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

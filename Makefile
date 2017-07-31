BUILD=./.build

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    EXTRA_SWIFTLINK=
    TARGET = .build/debug/libSwiftTclExtDemo.so
endif

ifeq ($(UNAME_S),Darwin)
    TCLVERSION=8.6.6_2
    BREWROOT=/usr/local/Cellar
    TCLLIBPATH=$(BREWROOT)/tcl-tk/$(TCLVERSION)/lib
    TCLINCPATH=$(BREWROOT)/tcl-tk/$(TCLVERSION)/include
    EXTRA_SWIFTLINK=-Xlinker -L/usr/local/lib \
	-Xlinker -L$(TCLLIBPATH) \
	-Xcc -I$(TCLINCPATH)
    TARGET = .build/debug/libSwiftTclExtDemo.dylib
endif

default: $(TARGET)

all: $(TARGET)

# swift build will make an error because of Tcl8_6 modulemap ?
# use shell test as a stand-in until this is sorted
$(TARGET): Sources/demoext.swift
	-swift build $(EXTRA_SWIFTLINK)
	test -f $(TARGET)

test: $(TARGET)
	tclsh8.6 packages/extension_test.tcl

clean:
	rm -rf .build $(TARGET) Package.pins

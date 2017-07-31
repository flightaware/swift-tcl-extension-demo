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
    PROJECT = SwiftTclDemoExt.xcodeproj
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

xcode: $(PROJECT)

clean:
	rm -rf .build $(TARGET) Package.pins $(PROJECT)

$(PROJECT): Package.swift Makefile
	@echo Generating Xcode project
	swift package -Xlinker -L/usr/local/lib -Xlinker -L$(TCLLIBPATH) -Xlinker -ltcl8.6 -Xlinker -ltclstub8.6 generate-xcodeproj
	@echo "NOTE: You will need to manually set the working directory for the SwiftTclDemo scheme to the root directory of this tree."
	@echo "Thanks Apple"


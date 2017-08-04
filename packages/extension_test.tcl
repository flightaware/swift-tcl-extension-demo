# Load the extension library
set libname ".build/debug/libSwiftTclExtDemo[info sharedlibextension]"
load $libname

# open a pipe to read this file
set fp [open "| cat packages/extension_test.tcl"]

puts "Reading pipe created in Tcl using Swift"
puts "<<EOF"
puts "[readChannel $fp]"
puts "EOF"

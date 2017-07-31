//
//  Provide the Tcl extension demoext in Swift
//
//  Copyright © 2017 FlightAware. All rights reserved.
//

import Tcl8_6
import SwiftTcl

// A trivial function to export to tcl
func demoext (interp: TclInterp, objv: [TclObj]) -> String {
	return "demoext"
}

// What's this silgen_name thing?
//
// When tcl loads a platform library with the load command, tcl
// looks for an initialization function in the dynamic library.
//
// This C linkage name is dependent on the name of the .so file
// If the tcl code is
//   load "./libSwiftTclExtDemo.so"
// then the C initialization entrypoint has to be
//   filename - "lib" and ".so"
//   all lowercase
//   captialize first character

@_silgen_name("Swifttclextdemo_Init")
func Demoext_Init(_ interpPtr:UnsafeMutablePointer<Tcl_Interp>) -> Int {
	let interp = TclInterp(interp: interpPtr)	
	// Add the command to tcl
    interp.createCommand(named: "demoext", using: demoext)
    return 0
}

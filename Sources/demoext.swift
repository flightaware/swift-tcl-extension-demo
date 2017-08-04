//
//  Provide the Tcl extension demoext in Swift
//
//  Copyright © 2017 FlightAware. All rights reserved.
//

import Tcl8_6
import SwiftTcl
import Foundation

class ChannelReader {
    var interp: UnsafeMutablePointer<Tcl_Interp>
    
    init(_ interp: UnsafeMutablePointer<Tcl_Interp>) {
        self.interp = interp
    }

    /**
        Get the unix file descriptor from the Tcl channel name.
     
        - Parameter channelName: Tcl's name for the channel
     
        - Returns: integer file descriptor or -1
     */
    func getNativeFdFromChannelName(_ channelName: String) -> Int32 {
        let direction = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        direction.pointee = TCL_READABLE
        if let channel = Tcl_GetChannel(interp, channelName, direction) {
            let handlePtr = UnsafeMutablePointer<ClientData?>.allocate(capacity: 1)
            if Tcl_GetChannelHandle(channel, TCL_READABLE, handlePtr) == TCL_OK {
                let fd = handlePtr.withMemoryRebound(to: Int32.self, capacity:1) { return $0.pointee }
                return fd
            }
        }
        return -1
    }
    
    /**
        Read a Tcl Channel until no more input is received.
 
        - Returns: String of file contents or empty string
    */
    func readChannel (interp: TclInterp, objv: [TclObj]) -> String {
        if let channelName:String = try? objv[1].get() {
            let fd = getNativeFdFromChannelName(channelName)
            if (fd < 0) {
                return "Unable to get native fd for \(channelName)"
            }
     
            // Reading a few bytes to exercise the buffer operations
            let size = 8
            let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
            defer {
                ptr.deallocate(capacity: size)
            }
            // Buffer for channel contents
            var data = [UInt8]()
            // POSIX file I/O
            var n = read(fd, ptr, size)
            while (n > 0) {
                let buffer = UnsafeBufferPointer(start: ptr, count: n)
                data = data + Array(buffer)
                n = read(fd, ptr, size)
            }
            
            if let result = String(bytes: data, encoding: .utf8) {
                return result
            } else {
                return ""
            }
        } else {
            return "Missing Tcl channel argument"
        }
    }
    
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
func ChannelReaderExt_Init(_ interpPtr:UnsafeMutablePointer<Tcl_Interp>) -> Int {
    let interp = TclInterp(interp: interpPtr)	
    let channelReader = ChannelReader(interpPtr)
    // Add the command to tcl
    interp.createCommand(named: "readChannel", using: channelReader.readChannel)
    return 0
}

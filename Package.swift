// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "SwiftTclExtDemo",
	dependencies: [
		.Package(url: "https://github.com/flightaware/swift-tcl.git", Version(1,0,0))
	]
)

let libSwiftTclExtDemo = Product(name: "SwiftTclExtDemo", type: .Library(.Dynamic), modules: "SwiftTclExtDemo")
products.append(libSwiftTclExtDemo)

// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "SwiftTclExtDemo",
	dependencies: [
		.Package(url: "https://github.com/snoe925/swift-tcl.git", Version(1,1,5))
	]
)

let libSwiftTclExtDemo = Product(name: "SwiftTclExtDemo", type: .Library(.Dynamic), modules: "SwiftTclExtDemo")
products.append(libSwiftTclExtDemo)

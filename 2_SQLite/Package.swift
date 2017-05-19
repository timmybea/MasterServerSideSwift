import PackageDescription

let package = Package(
    name: "hello-SQLite",
    dependencies: [
	.Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 7),
	.Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
	.Package(url: "https://github.com/vapor/sqlite.git", majorVersion: 2, minor: 0),
	]
)
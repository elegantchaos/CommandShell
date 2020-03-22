import XCTest
@testable import CommandShell

final class CommandShellTests: XCTestCase {
    // TODO: make an executable target with a test command; launch it from here and capture the output to test the shell
}

//    var output: String = ""
//
//    func testBasics() {
//        CommandShell.main(
//
//        let wibble = TestCommand(name: "wibble")
//        let wobble = TestCommand(name: "wobble")
//        let shell = Shell(commands: [wibble, wobble], commandLine: ["test", "wibble", "file"], ioHandler: TestHandler(for: self))
//        shell.run()
//        XCTAssertEqual(result, .ok)
//        XCTAssertTrue(wibble.ran)
//        XCTAssertFalse(wobble.ran)
//    }
//
//    func testHelp() {
        // TODO: can't capture the output of --help current, since Docopt logs it straight to stderr and exits.
        //       need to put some hooks into Docopt to fix this.
//        let wibble = TestCommand(name: "wibble")
//        let wobble = TestCommand(name: "wobble")
//        let shell = Shell(commands: [wibble, wobble], commandLine: ["test", "--help"], ioHandler: TestHandler(for: self))
//        shell.run()
//        XCTAssertEqual(result, .ok)
//        XCTAssertEqual(output, "blah")
//    }
//}

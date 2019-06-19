import XCTest
@testable import CommandShell

final class CommandShellTests: XCTestCase {
    var result: Result? = nil
    var output: String = ""

    struct TestHandler: IOHandler {
        let done: XCTestExpectation
        let test: CommandShellTests
        
        init(for test: CommandShellTests) {
            self.test = test
            self.done = test.expectation(description: "done")
        }
        
        func log(_ string: String) {
            test.output += string
        }
        
        func exit(result: Result) {
            test.result = result
            done.fulfill()
        }
        
        func waitForExit() {
            test.wait(for: [done], timeout: 1.0)
        }
    }
    
    class TestCommand: Command {
        let name: String
        
        override var description: Description {
            return Description(name: name, help: "Do the wibble command", usage: ["<file>"])
        }
        
        var ran = false
        
        init(name: String) {
            self.name = name
        }
        
        override func run(shell: Shell) throws -> Result {
            ran = true
            return .ok
        }
    }
    
    func testBasics() {
        let wibble = TestCommand(name: "wibble")
        let wobble = TestCommand(name: "wobble")
        let shell = Shell(commands: [wibble, wobble], commandLine: ["test", "wibble", "file"], ioHandler: TestHandler(for: self))
        shell.run()
        XCTAssertEqual(result, .ok)
        XCTAssertTrue(wibble.ran)
        XCTAssertFalse(wobble.ran)
    }
    
    func testHelp() {
        // TODO: can't capture the output of --help current, since Docopt logs it straight to stderr and exits.
        //       need to put some hooks into Docopt to fix this.
//        let wibble = TestCommand(name: "wibble")
//        let wobble = TestCommand(name: "wobble")
//        let shell = Shell(commands: [wibble, wobble], commandLine: ["test", "--help"], ioHandler: TestHandler(for: self))
//        shell.run()
//        XCTAssertEqual(result, .ok)
//        XCTAssertEqual(output, "blah")
    }
}

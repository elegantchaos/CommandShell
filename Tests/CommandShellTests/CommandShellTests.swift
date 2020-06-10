import XCTest
import XCTestExtensions

@testable import CommandShell


final class CommandShellTests: XCTestCase {
    let help = """
        OVERVIEW: An example command.

        USAGE: CommandShellExample [--version] [--verbose] <subcommand>

        OPTIONS:
          --version               Show the version.
          --verbose               Enable additional logging.
          -h, --help              Show help information.

        SUBCOMMANDS:
          subcommand
        
        See 'CommandShellExample help <subcommand>' for detailed help.

        """

    func testNoCommands() {
        let runner = XCTestRunner(for: productsDirectory.appendingPathComponent("CommandShellExample"))
        let result = runner.run()
        XCTAssertResult(result, status: 0, stdout: help, stderr: "")
    }
    
    func testVersion() {
        let result = run("CommandShellExample", arguments: ["--version"])
        XCTAssertResult(result, status: 0, stdout: "1.0", stderr: "")
    }
    
    func testHelp() {
        let result = run("CommandShellExample", arguments: ["--help"])
        XCTAssertResult(result, status: 0, stdout: help, stderr: "")
    }

    func testSubcommand() {
        let result = run("CommandShellExample", arguments: ["subcommand"])
        XCTAssertResult(result, status: 0, stdout: "Hello.", stderr: "")
    }

    func testSubcommandVerbose() {
        let result = run("CommandShellExample", arguments: ["subcommand", "--verbose"])
        XCTAssertResult(
            result,
            status: 0,
            stdout: """
                Hello.
                This is verbose output.
                """,
            stderr: ""
        )
    }

}

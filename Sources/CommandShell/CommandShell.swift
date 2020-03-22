// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import SemanticVersion

struct CommandShell: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Abstract.",
        subcommands: [],
        defaultSubcommand: nil
    )
    
    static var version = SemanticVersion(1)
    
    @Flag(help: "Show the version.") var version: Bool

    func run() throws {
        if version {
            print(CommandShell.version.asString)
        } else {
            throw CleanExit.helpRequest(self)
        }
    }
    
    var name: String {
        let url = URL(fileURLWithPath: CommandLine.arguments[0])
        return url.lastPathComponent

    }
}

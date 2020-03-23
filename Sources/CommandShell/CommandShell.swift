// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import SemanticVersion
import Logger

public struct CommandShell: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: CommandShell.executable,
        abstract: "Abstract.",
        subcommands: [],
        defaultSubcommand: nil
    )

    public static var executable: String {
        let url = URL(fileURLWithPath: CommandLine.arguments[0])
        return url.lastPathComponent
        
    }
    
    @Flag(help: "Show the version.") var version: Bool
    @OptionGroup() var standard: StandardOptions
    
    public init() {
    }

    public static func configure(abstract: String, subcommands: [ParsableCommand.Type], defaultSubcommand: ParsableCommand.Type?) {
        configuration = CommandConfiguration(
            commandName: CommandShell.executable,
            abstract: abstract,
            subcommands: subcommands,
            defaultSubcommand: defaultSubcommand
        )
    }
    public func run() throws {
        if version {
            print(standard.engine.version.asString)
        } else {
            throw CleanExit.helpRequest(self)
        }
    }
    
}

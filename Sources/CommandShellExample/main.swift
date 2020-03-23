// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/03/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import CommandShell
import Foundation

struct Subcommand: ParsableCommand {
    @OptionGroup() var common: CommandShellOptions
    
    func run() throws {
        let engine: ExampleEngine = common.loadEngine()
        engine.output.log("Hello.")
        engine.verbose.log("This is verbose output.")
    }
}

class ExampleEngine: CommandEngine {
    override class var abstract: String { return "An example command." }
    override class var subcommands: [ParsableCommand.Type] { return [Subcommand.self] }
}

CommandShell<ExampleEngine>.main()

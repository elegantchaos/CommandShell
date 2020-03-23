// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import SemanticVersion
import Logger

public struct CommandShell<Engine: CommandEngine>: ParsableCommand {
    public static var configuration: CommandConfiguration {
        return Engine.configuration
    }

    public static var executable: String {
        let url = URL(fileURLWithPath: CommandLine.arguments[0])
        return url.lastPathComponent
        
    }
    
    @Flag(help: "Show the version.") var version: Bool
    @OptionGroup() var options: CommandShellOptions
    
    public init() {
    }

    public func run() throws {
        let engine = options.loadEngine()
        if version {
            print("blah")
            engine.output.log(engine.version.asString)
        } else {
            throw CleanExit.helpRequest(self)
        }
    }

    static func mainWithFlush() {
        do {
            let command = try parseAsRoot()
            try command.run()
            Logger.defaultManager.flush()
            exit()
        } catch {
            exit(withError: error)
        }
    }

}

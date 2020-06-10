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
        let engine: Engine = options.loadEngine()
        if version {
            engine.output.log(engine.version.asString)
        } else {
            throw CleanExit.helpRequest(self)
        }
    }

    public static func main() -> Never {
        signal(SIGINT) { signal in
            Logger.defaultManager.flush()
            print("Interrupted by signal \(signal).")
        }

        do {
            let command = try parseAsRoot()
            try command.run()
            Logger.defaultManager.flush()
            exit()
        } catch {
            Logger.defaultManager.flush()
            exit(withError: error)
        }
    }
}

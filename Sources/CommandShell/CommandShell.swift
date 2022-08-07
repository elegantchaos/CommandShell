// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import SemanticVersion
import Logger

/// If set, this is the Info.plist dictionary that will be supplied
/// to the shell. If not set, the shell will attempt to load it as a resource.
private var commandShellExplicitInfo: [String:Any]?

public struct CommandShell<Engine: CommandEngine>: ParsableCommand {
    public static var configuration: CommandConfiguration {
        return Engine.configuration
    }

    public static var executable: String {
        let url = URL(fileURLWithPath: CommandLine.arguments[0])
        return url.lastPathComponent
        
    }
    
    @Flag(help: "Show the version.") var version = false
    @OptionGroup() var options: CommandShellOptions
    

    public init() {
    }

    public func run() throws {
        let engine: Engine = options.loadEngine(info: commandShellExplicitInfo)
        if version {
            engine.output.log(engine.version.asString)
        } else {
            throw CleanExit.helpRequest(self)
        }
    }

    
    public static func main(info: [String:Any]? = nil) -> Never {
        signal(SIGINT) { signal in
            Manager.shared.flush()
            print("Interrupted by signal \(signal).")
            abort()
        }

        do {
            commandShellExplicitInfo = info
            var command = try parseAsRoot()
            try command.run()
            Manager.shared.flush()
            exit()
        } catch {
            Manager.shared.flush()
            exit(withError: error)
        }
    }
}

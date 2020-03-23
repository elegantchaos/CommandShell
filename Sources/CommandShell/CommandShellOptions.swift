// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/03/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation

public struct CommandShellOptions: ParsableArguments {
    @Flag(help: "Enable additional logging.") public var verbose: Bool
    
    public init() {
    }
    
    public func loadEngine<Engine: CommandEngine>() -> Engine {
        return Engine.init(options: self)
    }
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Arguments

open class Command {
    public struct Description {
        public let name: String
        public let help: String
        public let usage: [String]
        public let arguments: [String:String]
        public let options: [String:String]
        public let returns: [Result]

        public init(name: String, help: String, usage: [String], arguments: [String:String] = [:], options: [String:String] = [:], returns: [Result] = []) {
            self.name = name
            self.help = help
            self.usage = usage
            self.arguments = arguments
            self.options = options
            self.returns = returns
        }
    }
    
    public init() {
    }
    
    open var description: Description {
        return Description(name: "", help: "", usage: [])
    }
    
    open func run(shell: Shell) throws -> Result {
        print("Command \(description.name) unimplemented." )
        return .ok
    }

}

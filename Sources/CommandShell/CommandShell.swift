// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Arguments
import Foundation

public class Shell {
    let commands: [Command]
    let defaultCommand: Command?
    public let arguments: Arguments
    
    public init(commands: [Command]) {
        self.commands = commands
        let documentation = Shell.buildDocumentation(for: commands)
        self.arguments = Arguments(documentation: documentation, version: "1.0")

        var defaultCommand: Command? = nil
        for command in commands {
            if command.description.name.isEmpty {
                defaultCommand = command
                break
            }
        }
        self.defaultCommand = defaultCommand
    }
    
    public func exit(result: Result) -> Never {
        if result.code != 0 {
            print("Error: \(result.description)")
            if !result.supplementary.isEmpty {
                print(result.supplementary)
            }
        } else {
            print("Done.")
        }

        print("")
        Foundation.exit(result.code)
    }
    
    public func run() -> Never {
        var matched = false
        
        for command in commands {
            if arguments.command(command.description.name) {
                run(command: command)
                matched = true
                break
            }
        }
        
        if !matched, let defaultCommand = defaultCommand {
            run(command: defaultCommand)
            matched = true
        }

        if !matched {
            exit(result: .badArguments)
        } else {
            dispatchMain()
        }
    }

    internal func run(command: Command) {
        do {
            let result = try command.run(shell: self)
            if result.code != Result.running.code {
                exit(result: result)
            }
            
        } catch {
            exit(result: Result.runFailed.adding(supplementary: String(describing: error)))
        }
    }
    
    public func log(_ message: String) {
        print(message)
    }
    
    class func buildDocumentation(for commands: [Command]) -> String {
        var arguments: [String:String] = [:]
        var options = [ "--help": "Show this help."]
        var helps: [String] = []
        var results: [Result] = [ .ok, .unknownCommand, .badArguments, .runFailed ]
        
        let appName = CommandLine.name
        var usageText = ""
        var helpText = ""
       for command in commands {
            let description = command.description
            for usage in description.usage {
                let commandName = description.name
                if commandName.isEmpty {
                    usageText += "    \(appName) \(usage)\n"
                } else {
                    usageText += "    \(appName) \(commandName) \(usage)\n"
                    helpText += "    \(commandName)    \(description.help)\n"
                }

            }
            helps.append(description.help)
            arguments.merge(description.arguments, uniquingKeysWith: { (k1, k2) in return k1 })
            options.merge(description.options, uniquingKeysWith: { (k1, k2) in return k1 })
            results.append(contentsOf: description.returns)
        }
        
        var optionText = ""
        for option in options {
            optionText += "    \(option.key)     \(option.value)\n"
        }
        
        var argumentText = ""
        for argument in arguments {
            argumentText += "    \(argument.key)    \(argument.value)\n"
        }
        
        var resultText = ""
        var codesUsed: [Int32:String] = [:]
        for key in results.sorted(by: { return $0.code < $1.code }) {
            if let duplicate = codesUsed[key.code] {
                print("Warning: duplicate code \(key.code) for \(key.description) and \(duplicate)")
            }
            codesUsed[key.code] = key.description
            resultText += "    \(key.code)    \(key.description)\n"
        }
        
        var text = """
        Various release utilities.
        
        Usage:
        \(usageText)
        
        """
        
        if !helpText.isEmpty {
            text += """
        Commands:
        \(helpText)
        
        """
        }
        
        text += """
        Arguments:
        \(argumentText)
        
        Options:
        \(optionText)
        
        Exit Status:
        
        The command exits with one of the following values:
        
        \(resultText)
        
        """
            
        return text
    }
    
}

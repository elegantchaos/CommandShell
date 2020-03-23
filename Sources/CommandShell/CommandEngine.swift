// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/03/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import Logger
import SemanticVersion

public protocol CommandEngineProtocol {
    init(options: CommandShellOptions)
}

open class CommandEngine: CommandEngineProtocol {
    public lazy var info = loadInfoPlist()
    public lazy var version = loadVersion()
    public lazy var buildNumber = loadBuildNumber()
    
    public let output = Logger.stdout
    public let verbose = Channel("verbose", handlers: [Logger.stdoutHandler])

    public required init(options: CommandShellOptions) {
        output.enabled = true
        verbose.enabled = options.verbose
    }
    
    class var configuration: CommandConfiguration {
        return CommandConfiguration(
            commandName: CommandShell.executable,
            abstract: abstract,
            subcommands: subcommands,
            defaultSubcommand: defaultSubcommand
        )
    }
    
    open class var abstract: String {
        return "<abstract goes here>"
    }
    open class var subcommands: [ParsableCommand.Type] {
        return []
    }
    
    open class var defaultSubcommand: ParsableCommand.Type? {
        return nil
    }
    
    public var name: String {
        return info["CFBundleDisplayName"] ?? CommandShell.executable
    }
    
    func loadVersion() -> SemanticVersion {
        if let string = info["CFBundleShortVersionString"], let version = SemanticVersion(string) {
            return version
        } else {
            return SemanticVersion(1)
        }
    }
    
    func loadBuildNumber() -> Int {
        if let string = info["CFBundleVersion"], let build = Int(argument: string) {
            return build
        } else {
            return 0
        }
    }
    
    func loadInfoPlist() -> [String:String] {
        #if os(macOS) || os(iOS)
        if let handle = dlopen(nil, RTLD_LAZY) {
            defer { dlclose(handle) }
            
            if let ptr = dlsym(handle, MH_EXECUTE_SYM) {
                var size: UInt = 0
                let mhExecHeaderPtr = ptr.assumingMemoryBound(to: mach_header_64.self)
                if let ptr = getsectiondata(mhExecHeaderPtr, "__TEXT", "__Info_plist", &size) {
                    let data = Data(bytesNoCopy: ptr, count: Int(size), deallocator: .none)
                    do {
                        let info = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                        return info as? [String:String] ?? [:]
                    } catch {
                    }
                }
            }
        }
        #endif
        return [:]
    }

}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/03/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import Logger
import SemanticVersion

public protocol CommandEngineProtocol {
    init(options: CommandShellOptions, info: [String:Any]?)
}

open class CommandEngine: CommandEngineProtocol {
    public lazy var info = loadInfoPlist()
    public lazy var version = loadVersion()
    public lazy var buildNumber = loadBuildNumber()
    
    public let output = Channel.stdout
    public let verbose = Channel("verbose", handlers: [Channel.stdoutHandler])

    public required init(options: CommandShellOptions, info: [String:Any]?) {
        output.enabled = true
        verbose.enabled = options.verbose
        if let info {
            self.info = info
        }
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
        return (info[.nameInfoKey] as? String) ?? CommandShell.executable
    }
    
    public var fullVersion: String {
        var string = "Version \(version.asString)"
        if let build = info[.buildInfoKey] {
            string.append(" (\(build))")
        }
        
        return string
    }
    
    public var fullName: String {
        return "\(name) \(fullVersion)"
    }
    
    public var about: String {
        var string = fullName
        if let copyright = info[.copyrightInfoKey] {
            string.append("\n\(copyright)")
        }
        
        return string
    }
    
    func loadVersion() -> SemanticVersion {
        if let string = (info[.versionInfoKey] as? String) {
            return SemanticVersion(string)
        } else {
            return SemanticVersion(1)
        }
    }
    
    func loadBuildNumber() -> Int {
        if let string = (info[.buildInfoKey] as? String), let build = Int(argument: string) {
            return build
        } else {
            return 0
        }
    }
    
    func loadInfoPlist() -> [String:Any] {
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
                        return info as? [String:Any] ?? [:]
                    } catch {
                    }
                }
            }
        }
        #endif
        return [:]
    }

}

public extension String {
    static let buildInfoKey = "CFBundleVersion"
    static let nameInfoKey = "CFBundleDisplayName"
    static let versionInfoKey = "CFBundleShortVersionString"
    static let copyrightInfoKey = "NSHumanReadableCopyright"
}

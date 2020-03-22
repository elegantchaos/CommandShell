// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import SemanticVersion

struct CommandShell: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Abstract.",
        subcommands: [],
        defaultSubcommand: nil
    )
    
    static var info = loadInfoPlist()
    static var version = loadVersion()
    static var buildNumber = loadBuildNumber()
    
    @Flag(help: "Show the version.") var version: Bool

    func run() throws {
        if version {
            print(CommandShell.version.asString)
        } else {
            throw CleanExit.helpRequest(self)
        }
    }
    
    static var executable: String {
        let url = URL(fileURLWithPath: CommandLine.arguments[0])
        return url.lastPathComponent

    }
    
    static var name: String {
        return info["CFBundleDisplayName"] ?? executable
    }
    
    static func loadVersion() -> SemanticVersion {
        if let string = info["CFBundleShortVersionString"], let version = SemanticVersion(string) {
            return version
        } else {
            return SemanticVersion(1)
        }
    }
    
    static func loadBuildNumber() -> Int {
        if let string = info["CFBundleVersion"], let build = Int(argument: string) {
            return build
        } else {
            return 0
        }
    }
    static func loadInfoPlist() -> [String:String] {
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

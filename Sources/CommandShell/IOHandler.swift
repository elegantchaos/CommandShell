// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/06/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol IOHandler {
    func log(_ string: String)
    func exit(result: Result)
    func waitForExit()
}

public struct DefaultIOHandler: IOHandler {
    public func log(_ string: String) {
        print(string)
    }
    
    public func exit(result: Result) {
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
    
    public func waitForExit() {
        dispatchMain()
    }
}

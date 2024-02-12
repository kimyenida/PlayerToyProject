//
//  Util.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

class Util: NSObject{
    static func log(_ messages: Any..., functionName: String=#function, saveToFile: Bool=false) {
        #if DEBUG
        print("💚 iMBC - \(functionName)# ", messages)
        if saveToFile {
            //SwiftyBeaver.verbose(messages)
        }
        #endif
    }
}

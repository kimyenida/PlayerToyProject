//
//  IHandlerCommend.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation


protocol iMBCPlayerHandlerCommend: class {
//    func addListener(listener: iMBCPlayerHandlerCommend)
    func commend(opt: CommandOption, obj: Sendable?)
}

protocol IHandlerCommend: class {
    func addListener(listener: IHandlerCommend)

    func commend(opt: Int, message: String, obj: Any?)

    func commend(opt: CommandOption, obj: Sendable?)
}

extension IHandlerCommend {
    func addListener(listener: IHandlerCommend) {
        Util.log("Called at: ", #file, " - ", #function)
    }
    
    func commend(opt: Int, message: String, obj: Any?) {
        Util.log("Called at: ", #file, " - ", #function)
    }
    
    func commend(opt: CommandOption, obj: Sendable?) {
        Util.log("Called at: ", #file, " - ", #function)
    }
}

protocol CommandOption {
    var obj: Sendable? { get }
    var message: String? { get }
}

extension CommandOption {
    var obj: Sendable? { return nil }
    var message: String? { return nil }
}

protocol Sendable {}

extension String: Sendable {}
extension Int: Sendable {}
extension Bool: Sendable {}
extension Float: Sendable {}
extension Dictionary: Sendable {}

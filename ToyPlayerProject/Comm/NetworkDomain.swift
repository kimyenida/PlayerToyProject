//
//  NetworkDomain.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation
enum NetworkDomain {
    case control
    case media
    case talk
    case playvod
    case global
    case search
    case imbbs
    
    var url: String {
        return "https://\(host)/"
    }
     
    var host: String {
        switch self {
        case .control: return "control.imbc.com"
        case .media: return "mediaapi.imbc.com"
        case .talk: return "talkapi.imbc.com"
        case .playvod: return "playvod.imbc.com"
        case .global: return "global.imbc.com"
        case .search: return "cue.imbc.com"
        case .imbbs: return "imbbs.imbc.com"
        }
    }
}

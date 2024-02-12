//
//  PlayViewerType.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

enum PlayViewerType: CommandOption {
    case INTRO(data: [String: Any])
    case ONAIR(type: String, onairtype: String)
    case ONAIRPLUS(type: String, onairtype: String, ch: String)
    case NVOD(type: String, chid: String) // only mbcnet 에서만 온에어랑 동일하게 취급함
    case VOD(isfree: Bool, broadcastId: String, itemid: String)
    case PREVOD(broadcastId: String, itemid: String)
    case MOVIE(broadcastId: String, itemid: String, month: Bool)
    case FOREIGN(broadcastId: String, itemid: String)
    case SKETCH(broadcastId: String, itemid: String)
    case CLIP(broadcastId: String, itemid: String)
    //다음 회차 요청의 경우 data가 not nil임
    case MBIC(chid: String, type: String, data: MbicUtilForm?)
    
    func changeViewer(id: Int = 0) -> PlayViewerType {
        switch self {
        case .INTRO: return self
        case let .ONAIR(type, _):
            return .ONAIR(type: type, onairtype: "\(id)")
        case let .ONAIRPLUS(type, _, ch):
            return .ONAIRPLUS(type: type, onairtype: "\(id)", ch: ch)
        case .NVOD: return self
        case let .VOD(isfree, broadcastId, _):
            return .VOD(isfree: isfree, broadcastId: broadcastId, itemid: "\(id)")
        case .PREVOD: return self
        case let .MOVIE(broadcastId, _, month):
            return .MOVIE(broadcastId: broadcastId, itemid: "\(id)", month: month)
        case .FOREIGN: return self
        case .SKETCH: return self
        case .CLIP: return self
        case let .MBIC(chid, type, _):
            return .MBIC(chid: chid, type: type, data: nil)
        }
    }
}

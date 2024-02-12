//
//  ControlAPI.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

enum ControlApi {
    case midrollShowTime
    // 온에어 관련
    case onairChannelList
    case onairScheduleList(type: String, sCode: String)
    case onairTalkIDList
    // VOD 관련
    case vodInfo(bid: String, isFree: Bool)
    // 공통
    case banner_onair
    case banner_vod
    //mbic 관련
    case mbicChannelList
    case mbicScheduleList(channelid: String, sDate: String)
}

extension ControlApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: NetworkDomain.control.url) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .midrollShowTime   : return "App/V2/MidrollShowTime"
        case .onairChannelList  : return "Schedule/PCONAIR"
        case .onairScheduleList : return "Schedule/listforapp"
        case .onairTalkIDList   : return "App/V2/OnAir/Talk"
        case .vodInfo           : return "App/VodInfo"
        case .banner_onair      : return "MBCApp/Banner/Live"
        case .banner_vod        : return "MBCApp/Banner/VOD"
        case .mbicChannelList   : return "MbicLive/ChannelList"
        case .mbicScheduleList  : return "MbicLive/Schedule"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .onairChannelList:
            var param = Parameters()
            param.updateValue("APP", forKey: "type")//대문자로만
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyyMMddHHmmssZZZ"
//            let callback = dateFormatter.string(from: Date())
//            param.updateValue(callback, forKey: "garbage")
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: param)
        
        case .onairScheduleList(let type, let sCode):
            var param = Parameters()
            param.updateValue(type, forKey: "type")
            param.updateValue(sCode, forKey: "sCode")
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: param)
            
        case .vodInfo(let bid, let isFree):
            var param = Parameters()
            param.updateValue(bid, forKey: "broadcastID")
            param.updateValue(isFree ? "Y":"N", forKey: "isFree")
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: param)
        
        case .banner_onair:
            var param = Parameters()
            param.updateValue("IOS", forKey: "type")
            param.updateValue("3", forKey: "positionType")
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: param)
            
        case .banner_vod:
            var param = Parameters()
            param.updateValue("IOS", forKey: "type")
            param.updateValue("2", forKey: "positionType")
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: param)
            
        case .mbicChannelList:
            var param = Parameters()
            param.updateValue("APP", forKey: "type")
            param.updateValue("1000", forKey: "pageSize")
            param.updateValue("type", forKey: "APP")
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: param)
            
        case .mbicScheduleList(let channelid, let sDate):
            var param = Parameters()
            param.updateValue(channelid, forKey: "channelid")
            param.updateValue(sDate, forKey: "sDate")
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: param)
        
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var contentType: HTTPContentType? {
        return nil
    }
}


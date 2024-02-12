//
//  StreamAPI.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

enum StreamApi {
    case onair(type: String, onairtype: String)
    case onairplus(type: String, onairtype: String, ch: String)
    case nvod(type: String, chid: String)
    
    case nvod1(type: String, chid: String)
    case nvod2(type: String, chid: String)
    
    case playerUtil(isfree: Bool, broadcastId: String, itemid: String)
    case playerURLUtil(isfree: Bool, broadcastId: String, itemid: String)
    
    case seamless(broadcastId: String, mediaTime: String, flaSum: String)
    case nowOnAirStautsCheck
    
    case mbicUtil(chid: String, type: String)
    case mbicURLUtil(chid: String, type: String, isnext: String)
}

extension StreamApi: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: NetworkDomain.media.url) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .onair                         :
            return "Player/OnAirURLUtilForAppSec2022"//"Player/OnAirURLUtilForAppSec"
        case .onairplus                     :
            return "Player/OnAirPlusURLUtilForAppSec2022"//"Player/OnAirPlusURLUtilForAppSec"
        case .nvod                          : return "Player/NVodURLUtil"
        case .nvod1                         : return "Player/NewNVodURLUtil"
        case .nvod2                         : return "Player/NewNVodNextURLUtil"
        case let .playerUtil(isfree, _, _):
            if isfree {
                return "Player/FreePlayerUtil"
            } else {
                return "Player/PlayerUtil"
            }
            
        case let .playerURLUtil(isfree, _, _):
            if isfree {
                return "Player/FreePlayURLUtil"
            } else {
                return "Player/PlayURLUtil"
            }
            
        case .seamless:
            return "Seamless/UpdatePlayTime"
            
        case .nowOnAirStautsCheck:
            return "Player/OnAirScheduleUtil"
            
        case .mbicUtil:
            return "Player/MbicPlayerUtil"
            
        case .mbicURLUtil:
            return "Player/MbicPlayURLUtil"
             
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case let .onair(type, onairtype):
            var params = Parameters()
            params.updateValue("\(type)", forKey: "type")
            params.updateValue("\(onairtype)", forKey: "onairtype")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
        case let .onairplus(type, onairtype, ch):
            var params = Parameters()
            params.updateValue("\(type)", forKey: "type")
            params.updateValue("\(onairtype)", forKey: "onairtype")
            params.updateValue("\(ch)", forKey: "ch")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
        case let .nvod(type, chid):
            var params = Parameters()
            params.updateValue("\(type)", forKey: "type")
            params.updateValue("\(chid)", forKey: "chid")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
        case let .nvod1(type, chid):
            var params = Parameters()
            params.updateValue("\(type)", forKey: "type")
            params.updateValue("\(chid)", forKey: "chid")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
        case let .nvod2(type, chid):
            var params = Parameters()
            params.updateValue("\(type)", forKey: "type")
            params.updateValue("\(chid)", forKey: "chid")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
            
        case let .playerUtil(_, broadcastId, itemid):
            var params = Parameters()
            params.updateValue("\(broadcastId)", forKey: "broadcastId")
            params.updateValue("\(itemid)", forKey: "itemid")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
            
        case let .playerURLUtil(_, broadcastId, itemid):
            var params = Parameters()
            params.updateValue("\(broadcastId)", forKey: "broadcastId")
            params.updateValue("\(itemid)", forKey: "itemid")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
            
        case let .seamless(broadcastId, mediaTime, flaSum):
            var params = Parameters()
            params.updateValue("\(broadcastId)", forKey: "broadcastId")
            params.updateValue("\(mediaTime)", forKey: "mediaTime")
            params.updateValue("\(flaSum)", forKey: "flaSum")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
            
        case .nowOnAirStautsCheck:
            return .request
            
        case let .mbicUtil(chid, type):
            var params = Parameters()
            params.updateValue("\(chid)", forKey: "chid")
            params.updateValue("\(type)", forKey: "type")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
            
        case let .mbicURLUtil(chid, type, isnext):
            var params = Parameters()
            params.updateValue("\(chid)", forKey: "chid")
            params.updateValue("\(type)", forKey: "type")
            params.updateValue("\(isnext)", forKey: "isNext")
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: params)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var contentType: HTTPContentType? {
        return .json
    }
    
}

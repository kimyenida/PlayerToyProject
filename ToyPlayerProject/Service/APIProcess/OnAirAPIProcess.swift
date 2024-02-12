//
//  OnAirAPIProcess.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation
import OSLog

struct MbicChannelList: Codable {
    let totalCount: Int?
    let mbicList: [MbicChannelInfo]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "TotalCount"
        case mbicList = "List"
    }
}
 

struct MbicChannelInfo: Codable, ChannelInfo {
    let cId: Int?
    let typeTitle, title, onAirImage: String?
    let startTime, endTime, rate: String?
    let targetAge: Int?
    let orderNum, pc, m, a, sunwi: Int?
    let talkID: Int?
    
    var type: String? {
        return "NVOD"
    }
    var scheduleCode: String? {
        if let cId = cId {
            return String(cId)
        }
        return nil
    }
    var mediaCode: String? {
        if let cId = cId {
            return String(cId)
        }
        return nil
    }
    var percentTime: Int? {
        if let rate = rate {
            return Int(rate)
        }
        return nil
    }
    var isOnAirNow: Bool {
        return true
    }
    
    enum CodingKeys: String, CodingKey {
        case cId = "ChannelId"
        case typeTitle = "ChannelName"
        case title = "Title"
        case onAirImage = "Picture"
        case targetAge = "TargetAge"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case rate = "Rate"
        case orderNum = "OrderNum"
        case pc = "PC"
        case m = "M"
        case a = "A"
        case sunwi = "Sunwi"
        case talkID = "TalkID"
    }
}



class OnAirAPIProcess: APIProcess {
    private let controlAPI = iMBCNetRouter<ControlApi>()
    // 온에어 채널리스트 (이 중 TV list만 사용)
    func getChannelList(_ completion: @escaping (Result<OnAirChannelList, ResponseError>) -> Void) {
        controlAPI.request(.onairChannelList) { data, response, error in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    // 온에어 스케줄 (이 중 TV list만 사용)
//    func getScheduleList(type: String, sCode: String, _ completion: @escaping (Result<[OnAirDaySchedule], ResponseError>) -> Void) {
//        controlAPI.request(.onairScheduleList(type: type, sCode: sCode)) { data, response, error in
//            APIProcess.handleResult(data, response, error, completion)
//        }
//    }
    // mbic 채널리스트
    func getMbicChannelList(_ completion: @escaping (Result<MbicChannelList, ResponseError>) -> Void) {
        controlAPI.request(.mbicChannelList) { data, response, error in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    // mbic 스케줄
    func getMbicScheduleList(id: String, sdata: String, _ completion: @escaping (Result<[MbicDaySchedule], ResponseError>) -> Void) {
        controlAPI.request(.mbicScheduleList(channelid: id, sDate: sdata)) { data, response, error in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
}

struct MbicDaySchedule: Codable, ChannelInfo {
    let isToday: String?
    let chCode: String?
    let programID: String?
    let contentID: String?
    let programTitle: String?
    let contentNumber: String?
    let targetAge: String?
    let endTime: String?
    let homepageURL: String?
    let onAir: String?
    let playTime: String?
    let photo: String?
    let talkID: Int?
    
    // - OnAirChannelInfo
    let typeTitle: String?
    let title: String?
    let startTime: String?
    let percentTime: Int?
    let onAirImage: String?
    let _isOnAirNow: String?
    
    var type: String? {
        return "NVOD"
    }
    var isOnAirNow: Bool {
        return _isOnAirNow == "Y"
    }
    // N/A
    var scheduleCode: String? {
        return nil
    }
    var mediaCode: String? {
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case isToday = "IsToday"
        case chCode = "ChCode"
        case programID = "ProgramID"
        case contentID = "ContentID"
        case programTitle = "ProgramTitle"
        case title = "ContentTitle"
        case contentNumber = "ContentNumber"
        case targetAge = "TargetAge"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case homepageURL = "HomepageURL"
        case onAir = "OnAir"
        case playTime = "PlayTime"
        case percentTime = "percentTime"
        case _isOnAirNow = "IsOnAirNow"
        case photo = "Photo"
        case onAirImage = "OnAirImage"
        case typeTitle = "ChannelTitle"
        case talkID = "TalkID"
    }
}

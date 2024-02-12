//
//  OnAirChannelList.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

struct OnAirChannelInfo: Codable, ChannelInfo {
    let type: String?
    let scheduleCode, mediaCode, typeTitle, title: String?
    let homepageURL: String?
    let startTime, endTime: String?
    let fullStartTime, fullEndTime: String?
    let photo: String?
    let percentTime: Int?
    let targetAge: String?
    let orderNum, talkID: Int?
    let onAirImage: String?
    private let _isOnAirNow: String?
    
    var isOnAirNow: Bool {
        return _isOnAirNow == "Y"
    }
    
    // 스포츠 미방송 관련 로직에 필요한 정보들 startDate endDate type
//    var startDate: Date? {
//        guard let startTimeString = fullStartTime?.convert(from: "yyyyMMddHHmmss", to: "yyyy-MM-dd HH:mm:ss")  else { return nil }
//        let startDate = "\(startTimeString)".convertDate(of: "yyyy-MM-dd HH:mm:ss")
//        return startDate
//    }
//    
//    var endDate: Date? {
//        guard let endTimeString = fullEndTime?.convert(from: "yyyyMMddHHmmss", to: "yyyy-MM-dd HH:mm:ss") else { return nil }
//        let endDate = "\(endTimeString)".convertDate(of: "yyyy-MM-dd HH:mm:ss")
//        return endDate
//    }

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case scheduleCode = "ScheduleCode"
        case mediaCode = "MediaCode"
        case typeTitle = "TypeTitle"
        case title = "Title"
        case homepageURL = "HomepageURL"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case photo = "Photo"
        case percentTime
        case targetAge = "TargetAge"
        case orderNum = "OrderNum"
        case talkID = "TalkID"
        case onAirImage = "OnAirImage"
        case _isOnAirNow = "IsOnAirNow"
        case fullStartTime = "FullStartTime"
        case fullEndTime = "FullEndTime"
    }
}


struct OnAirChannelList: Codable {
    let serverTime: String?
    let tvList, ch24List, radioList: [OnAirChannelInfo]

    enum CodingKeys: String, CodingKey {
        case serverTime = "ServerTime"
        case tvList = "TVList"
        case ch24List = "CH24List"
        case radioList = "RadioList"
    }
}

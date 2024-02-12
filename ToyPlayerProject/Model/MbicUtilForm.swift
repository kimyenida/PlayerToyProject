//
//  MbicUtilForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

class MbicUtilForm: Codable, Sendable {
    let msg: String?
    let channelID: Int?
    let channelName: String?
    let preAdCnt, midAdCnt, midAdTerm: Int?
    let smrCode, smrProgramID: String?
    let adInfo: AdInfoForm?
    
    enum CodingKeys: String, CodingKey {
        case msg = "Msg"
        case channelID = "ChannelID"
        case channelName = "ChannelName"
        case preAdCnt = "PreAdCnt"
        case midAdCnt = "MidAdCnt"
        case midAdTerm = "MidAdTerm"
        case smrCode = "SMRCode"
        case smrProgramID = "SMRProgramId"
        case adInfo = "AdInfo"
    }
}


//
//  ChannelInfo.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/23/24.
//

import Foundation

protocol ChannelInfo {
    var type: String? { get }           // TV, Mbic 카테고리 구분
    var scheduleCode: String? { get }   // 채널 구분
    var typeTitle: String? { get }      // 채널명
    var title: String? { get }          // 컨텐츠명
    var startTime: String? { get }      // 온에어 시작 시간
    var percentTime: Int? { get }       // 온에어 진행율
    var onAirImage: String? { get }     // 온에어 실시간썸네일
    var isOnAirNow: Bool { get }        // 방송중 여부
    var talkID: Int? { get }            // 톡 ID
    var mediaCode: String? { get }      // 미디어코드 (mbic은 채널id)
}

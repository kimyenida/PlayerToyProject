//
//  AdInfoForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation
struct AdInfoForm: Codable, Sendable {
    var version: String?
    var media, site, requesttime, tid: String?
    var uuid, platform, playertype, os, devicemodel: String?
    var telco, cpid, channelid, category: String?
    var ispay, section, isonair, programid: String?
    var broaddate, contentnumber, targetnation: String?
    var playtime: String?
    var vodtype, clipid, starttime, endtime: String?
    var ip, gender, age, referrer: String?
    var adcount, adtype: String?
    var adurl: String?
    var trackpoint: String?
    var slots: String?
    var sectiontype: String?
    var customkeyword: String?
    
    var adInfoDoc: [String: String?] {
        var result = [String: String?]()
        do {
            let data = try JSONEncoder().encode(self)
            let obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String?]
            result = obj ?? [:]
        } catch {
            print("Error occurred while encode parameters: \(error)")
        }
        return result
    }
    
    var isVirix: Bool?
    var invenid: String?
    var AdTitle: String?
    var AdCover: String?
    var isVirixCount: String?
    
    var count: Int {
        return Int(adcount ?? "0") ?? 0
    }
    
    init?(json: String) {
        do {
            self = try JSONDecoder().decode(AdInfoForm.self, from: json.data(using: .utf8)!)
        } catch {
            print("error while decoding: \(error)")
            return nil
        }
    }
}

//
//  PagingViewModel.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/22/24.
//

import Foundation

protocol PagingViewModelProtocol{
    func viewRefresh(isFirst: Bool, data:[ChannelInfo])
}
class PagingViewModel{
    private var channelList : [ChannelInfo] = []
    private let networking = OnAirAPIProcess()
    
    
    
    var mbicList : [ChannelInfo] = []
    var tvList : [ChannelInfo] = []
    
    var indexListByScode: [[String: Int]] = [[:], [:]]
    var channelListByScode: [[String: ChannelInfo]] = [[:], [:]] // [[sCode:채널리스트]]
    
    var delegate : PagingViewModelProtocol?
    
    func refreshData(isFirst: Bool, code: Int){
        if code == 0{
            self.requestOnAirChannelList{
                self.delegate?.viewRefresh(isFirst: isFirst, data: self.tvList)
            }
        } else{
            self.requestMbicChannelList {
                self.delegate?.viewRefresh(isFirst: isFirst, data: self.mbicList)
            }
        }
    }
    
    private func requestMbicChannelList(_ completion: @escaping () -> Void) {
        networking.getMbicChannelList { [weak self] response in
            guard let `self` = self else { return }
            // - Set Data
            switch response {
            case .success(let channels):
                self.mbicList = channels.mbicList
                
            case .failure(let error):
                Util.log("OnAirVC ==> getMbicChannelList Error: \(error.reason)")
                self.mbicList = []
            }
            
            for (index, chInfo) in self.mbicList.enumerated() {
                self.indexListByScode[1][chInfo.scheduleCode!] = index
                self.channelListByScode[1][chInfo.scheduleCode!] = chInfo
            }
            
            completion()
        }
    }
    
    private func requestOnAirChannelList(_ completion: @escaping () -> Void) {
        networking.getChannelList() { [weak self] response in
            guard let `self` = self else { return }
            // - Set Data
            switch response {
            case .success(let channels):
                self.tvList = channels.tvList

            case .failure(let error):
                Util.log("OnAirVC ==> getMbicChannelList Error: \(error.reason)")
                self.tvList = []

            }
            
            for (index, chInfo) in self.tvList.enumerated() {
                self.indexListByScode[0][chInfo.scheduleCode!] = index
                self.channelListByScode[0][chInfo.scheduleCode!] = chInfo
            }
            completion()
        }
    }
    
    func findChannelInfo(for sCode: String) -> ChannelInfo? {
        // tv
        if let chInfoTV = channelListByScode[0][sCode] {
            return chInfoTV
        }
        // ch24
        else if let chInfoCH24 = channelListByScode[1][sCode] {
            return chInfoCH24
        }
        else {
            return nil
        }
    }
}

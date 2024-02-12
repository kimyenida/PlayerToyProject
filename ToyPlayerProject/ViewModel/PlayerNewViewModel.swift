//
//  PlayerNewViewModel.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/16/24.
//

import Foundation
import AVFoundation

protocol PlayerViewModelProtocol {
    func changeImage(_ kind:String)
    func changSliderValue(_ value: Float)
    func changelLabel(_ value:String)
    func changerLabel(_ value:String)
}

class PlayerNewViewModel {
    
    var delegate: PlayerViewModelProtocol?
    private var isTumbSeek : Bool = false //사용자가 슬라이더를 움직이고 있음을 나타내는 변수
    private var timeObserver : Any? = nil
    
    public func setObserverToPlayer(player: AVPlayer?,completion: @escaping ()->()){
        // 0.3초마다 Player가 반응하게
        let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: {elapsed in
            self.updateSliderTime(elapsed, player, completion)
        })
    }
    
    public func onTabBack10(player: AVPlayer?){
        guard let currentTime = player?.currentTime() else { return }
        
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: -10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        player?.seek(to: seekTime,completionHandler: { completed in
        })
    }
    
    public func onTabNext10(player: AVPlayer?){
        guard let currentTime = player?.currentTime() else { return }
        
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: 10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        player?.seek(to: seekTime,completionHandler: { completed in
        })
    }
    
    public func onTabPlay(player: AVPlayer?){
        
        if player?.timeControlStatus == .playing{
            delegate?.changeImage("pause")
            player?.pause()
        }
        else{
            delegate?.changeImage("play.circle")
            player?.play()
        }
    }
    
    public func onTabPlayerSlider(player: AVPlayer?, sliderValue: Float64){
        self.isTumbSeek = true
        guard let duration = player?.currentItem?.duration else { return } // 총 재생시간
        let value = Float64(sliderValue) * CMTimeGetSeconds(duration) // 얼만큼 재생시간 되었는지(슬라이더 움직일 때 마다 계속 값이 바뀔것임)
        
        if value.isNaN == false{ // 숫자면(isNaN는 숫자가 아니면 true를 반환)
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1) //얼마나 재생시간되었는지 CMTime으로 변환
            player?.seek(to: seekTime, completionHandler: { completed in // player의 시간대를 seekTime으로 바꿈
                if completed{               // 잘 바뀌었다면 completed는 true
                    self.isTumbSeek = false     //다시 false로 isTumbSeek를 바꿈
                }
            })
        }
    }
    
    public func updateSliderTime(_ currentTime:CMTime,_ player : AVPlayer?, _ completion: @escaping ()->()){
        guard let currentTime = player?.currentTime() else { return }
        guard let duration = player?.currentItem?.duration else { return }
        
        
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        if self.isTumbSeek == false{
            delegate?.changSliderValue(Float(currentTimeInSecond/durationTimeInSecond))
        }
        
        let value = Float64(currentTimeInSecond/durationTimeInSecond) * CMTimeGetSeconds(duration)
        var hours = value / 3600
        var mins = value / 60
        var secs = value.truncatingRemainder(dividingBy: 60)
        var timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let housStr = timeformatter.string(from: NSNumber(value: hours)), let minStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        delegate?.changelLabel("\(housStr):\(minStr):\(secsStr)")
        
        hours = durationTimeInSecond / 3600
        mins = durationTimeInSecond / 60
        secs = durationTimeInSecond.truncatingRemainder(dividingBy: 60)
        timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let housStr = timeformatter.string(from: NSNumber(value: hours)), let minStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        delegate?.changerLabel("\(housStr):\(minStr):\(secsStr)")
        completion()
    }
    
    deinit{
        print("PlayerNewViewModel - deinit")
        timeObserver = nil
    }
}


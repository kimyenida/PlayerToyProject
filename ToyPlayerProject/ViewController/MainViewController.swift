//
//  MainViewController.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class MainViewController: UIViewController {
     
    var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var underView: LiveInfoView = {
        let view = LiveInfoView(categoryTitleList: MainViewController.categoryTitleList)
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var rLabel: UILabel = {
        var label = UILabel()
        label.text = "오른쪽"
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var lLabel: UILabel = {
        var label = UILabel()
        label.text = "오른쪽"
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var slider: UISlider = {
        var slider = UISlider()
        slider.tintColor = .systemRed
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var playBtn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "play.circle")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var back10Btn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "gobackward.10")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var next10Btn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "goforward.10")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let links = [TestVideoLinks.link1,TestVideoLinks.link2,TestVideoLinks.link3]
    
    var heightConstraint: NSLayoutConstraint?
    var viewModel: PlayerNewViewModel?
    static var categoryTitleList : [String] = ["온에어", "엠빅"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setVideoViewUI()
        self.setUnderViewUI()
        self.setPlayer()
        
        self.viewModel?.delegate = self
    }
    
    private var windowInterface : UIInterfaceOrientation? {
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        guard let windowInterface = self.windowInterface else{ return }
        if windowInterface.isPortrait == true {
            heightConstraint?.constant = 196
        } else {
            heightConstraint?.constant = self.view.bounds.width
        }
    }
     
    private func setVideoViewUI() {
        self.view.addSubview(videoView)
        
        NSLayoutConstraint.activate([
            self.videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.videoView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.videoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        playerLayer = playerlayerLayer(playerView: videoView)
        
        heightConstraint = videoView.heightAnchor.constraint(equalToConstant: 196)
        heightConstraint?.isActive = true
        
        videoView.addSubview(lLabel)
        videoView.addSubview(rLabel)
        videoView.addSubview(slider)
        videoView.addSubview(playBtn)
        videoView.addSubview(back10Btn)
        videoView.addSubview(next10Btn)
        
        
        NSLayoutConstraint.activate([
            lLabel.widthAnchor.constraint(equalToConstant: 50),
            lLabel.leadingAnchor.constraint(equalTo: self.videoView.leadingAnchor, constant: 10),
            lLabel.bottomAnchor.constraint(equalTo: self.videoView.bottomAnchor, constant: -10),
            
            rLabel.widthAnchor.constraint(equalToConstant: 50),
            rLabel.trailingAnchor.constraint(equalTo: self.videoView.trailingAnchor, constant: -10),
            rLabel.bottomAnchor.constraint(equalTo: self.videoView.bottomAnchor, constant: -10),
            
            slider.leadingAnchor.constraint(equalTo: self.lLabel.trailingAnchor, constant: 5),
            slider.trailingAnchor.constraint(equalTo: self.rLabel.leadingAnchor, constant: -5),
            slider.centerYAnchor.constraint(equalTo: self.lLabel.centerYAnchor),
            
            playBtn.widthAnchor.constraint(equalToConstant: 50),
            playBtn.heightAnchor.constraint(equalToConstant: 50),
            playBtn.centerXAnchor.constraint(equalTo: self.videoView.centerXAnchor),
            playBtn.centerYAnchor.constraint(equalTo: self.videoView.centerYAnchor),
            
            back10Btn.widthAnchor.constraint(equalToConstant: 50),
            back10Btn.heightAnchor.constraint(equalToConstant: 50),
            back10Btn.centerXAnchor.constraint(equalTo: self.videoView.centerXAnchor, constant: -80),
            back10Btn.centerYAnchor.constraint(equalTo: self.videoView.centerYAnchor),
            
            next10Btn.widthAnchor.constraint(equalToConstant: 50),
            next10Btn.heightAnchor.constraint(equalToConstant: 50),
            next10Btn.centerXAnchor.constraint(equalTo: self.videoView.centerXAnchor, constant: 80),
            next10Btn.centerYAnchor.constraint(equalTo: self.videoView.centerYAnchor),
        ])
        
        slider.addTarget(self, action: #selector(onTapSlider), for: .valueChanged)
        
        back10Btn.isUserInteractionEnabled = true
        back10Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack10)))
        
        next10Btn.isUserInteractionEnabled = true
        next10Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapNext10)))
        
        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPlay)))
        
    }
    
    fileprivate func playerlayerLayer(playerView: UIView) -> AVPlayerLayer {
        let renderingView = PlayerView(frame: videoView.frame)
        playerView.insertSubview(renderingView, at: 0)
        
        renderingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            renderingView.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
            renderingView.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
            renderingView.topAnchor.constraint(equalTo: videoView.topAnchor),
            renderingView.bottomAnchor.constraint(equalTo: videoView.bottomAnchor),
        ])
        
        return renderingView.avPlayerLayer
    }
    
    func setPlayer() {
        if let url = URL(string: TestVideoLinks.link2) {
            self.player = AVPlayer()
            self.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
            self.playerLayer?.player = self.player
        }
        
        self.viewModel?.setObserverToPlayer(player: self.player)  {} 
        self.addObservers()
    }
    
    private func setUnderViewUI() {
        underView.pagingTabBar.indicatorViewWidthConstraint.constant = self.view.frame.width / CGFloat(MainViewController.categoryTitleList.count)

        self.view.addSubview(underView)
        NSLayoutConstraint.activate([underView.topAnchor.constraint(equalTo: videoView.bottomAnchor),
                                     underView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     underView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     underView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
         
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem
        )
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    
    @objc
    private func onTapSlider(){
        viewModel?.onTabPlayerSlider(player: self.player, sliderValue: Float64(slider.value))
    }
    
    @objc
    private func onTapBack10(){
        viewModel?.onTabBack10(player: self.player)
    }
    
    @objc
    private func onTapNext10(){
        viewModel?.onTabNext10(player: self.player)
    }
    
    @objc
    private func onTapPlay(){
        viewModel?.onTabPlay(player: self.player)
    }
    
    @objc
    private func playerDidFinishPlaying(note: NSNotification) {
        print("the end \n")
        player?.pause()
        //slider.value = 1
        changeImage("pause")
    }
    
    deinit{
        print("MainViewController - deinit")
        viewModel = nil
        removeObservers()
    }
}

extension MainViewController: PlayerViewModelProtocol {
    func changSliderValue(_ value: Float) {
        self.slider.value = value
    }
    
    func changelLabel(_ value: String) {
        self.lLabel.text = value
    }
    
    func changerLabel(_ value: String) {
        self.rLabel.text = value
    }
    
    func changeImage(_ kind: String) {
        self.playBtn.image = UIImage(systemName: kind)
    }
}


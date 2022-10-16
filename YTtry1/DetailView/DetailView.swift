//
//  DetailView.swift
//  YTtry1
//
//  Created by Nephilim  on 10/11/22.
//

import Foundation
import UIKit
import YouTubeiOSPlayerHelper
import SnapKit


class DetailView: UIView, YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeTitle: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var videoNameLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerView.delegate = self
        
        //playerView.load(withVideoId: "YjU5JAPtwwQ", playerVars: ["autoplay" : 1, "controls": 0, "playsinline": 1, "rel": 0])
        playerView.load(withPlaylistId: "UU-lHJZR3Gqxm24_Vd_AJ5Yw")
    }
    
    
    
    func set(videoModel: Video) {
        
    }
    
    private func playVideo(videoID: String = "YjU5JAPtwwQ") {
        
        //playerView.load(withVideoId: videoID, playerVars: ["autoplay" : 1, "controls": 0, "playsinline": 1, "rel": 0])
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        //playerView.playVideo()
    }
    
    
    
    
    func observerCurrentTime() {
        playerView.currentTime { timeFloat, error in
            print(timeFloat)
        }
        
    }
    
    
    //MARK: - IBActions
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
    }
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
    }
    @IBAction func prevButtonPressed(_ sender: UIButton) {
        playerView.previousVideo()
        self.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        observerCurrentTime()
        playerView.nextVideo()
        self.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
    }
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        playerView.playerState { state, error in
            if state == .paused {
                self.playerView.playVideo()
                self.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            } else {
                self.playerView.pauseVideo()
                self.playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
            }
        }
    }
    
    
}

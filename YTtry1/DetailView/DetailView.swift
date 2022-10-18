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
import MediaPlayer



class DetailView: UIView, YTPlayerViewDelegate,NetworkServiceForDeteilView {
    func nameFetched(_ videoName: String) {
        //print("nameFetched executed")
        self.videoNameLabel.text = videoName
    }
    func statsFetched(_ statItem: VideoStatistics) {
        DispatchQueue.main.async {
            //print("stats fetched executed")
            let viewsFormatted = Int(statItem.viewCount)?.formattedWithSeparator
            self.viewsCountLabel.text = "\(viewsFormatted!) views"
        }
    }
    
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeTitle: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    
    var progressObserver : NSKeyValueObservation!
    var networkService = NetworkService()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("error setting up Audio Session")
        }
        progressObserver = audioSession.observe(\.outputVolume, changeHandler: { session, value in
            let volume = session.outputVolume
            self.volumeSlider.setValue(volume, animated: true)
            print("session.outputVolume = \(session.outputVolume)")
            
        })
        
        
        playerView.delegate = self
        networkService.detDelegate = self
        //playerView.load(withVideoId: "YjU5JAPtwwQ", playerVars: ["autoplay" : 1, "controls": 0, "playsinline": 1, "rel": 0])
        //playerView.load(withPlaylistId: "UU-lHJZR3Gqxm24_Vd_AJ5Yw")
        playVideo(videoID: "TPrKN5AHGCk")
        //        playerView.load(withVideoId: "TPrKN5AHGCk", playerVars: ["autoplay" : 1, "controls": 0, "playsinline": 1, "rel": 0])
        currentTimeSlider.setValue(0, animated: true)
    }
    
    
    
    func set(videoModel: Video) {
        
    }
    
    func playVideo(videoID: String) {
        
        playerView.load(withVideoId: videoID, playerVars: ["autoplay" : 1, "controls": 0, "playsinline": 1, "rel": 0])
        // you finished here
        playerView.playVideo()
        self.networkService.getSmollVideoStat(videoID)
        self.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
    }
    
    func playVideo(playlistID : String) {
        playerView.load(withPlaylistId: playlistID, playerVars: ["autoplay" : 1, "controls": 0, "playsinline": 1, "rel": 0])
        playerView.playVideo()
        self.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
        
    }
    
    func getVideoIDFromPlayer() {
        playerView.videoUrl { url, error in
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            let vidID = components?.queryItems?.first(where: { item -> Bool in
                item.name == "v"
            })!.value!
            self.networkService.getSmollVideoStat(vidID!)
            print("\(vidID) <<<<<<<<<<|||||||||>>>>>>>>")
        }
    }
    
    
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .unstarted:
            print("unstarted")
        case .ended:
            print("ended")
        case .playing:
            self.getVideoIDFromPlayer()
            self.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
        case .paused:
            self.getVideoIDFromPlayer()
            self.playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
        case .buffering:
            print("buffering")
        case .cued:
            print("cued")
        case .unknown:
            print("unknown")
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        //getVideoIDFromPlayer()
        playerView.playVideo()
        
        
    }
        
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        if playTime > 0 {
            self.updateCurrentTimeSlider()
        }
    }
    
    @objc private func updateCurrentTimeSlider() {
        playerView.currentTime { currentTime, error in
            self.playerView.duration { duration, error in
                let percentage = currentTime / Float(duration)
                self.currentTimeSlider.value = percentage
                let intCurrentTime = Int(currentTime)
                let intDuration = Int(duration) - intCurrentTime
                
                let secondsToMinsCurrentTitle = self.secondsToMinutes(intCurrentTime)
                let secondsToMinsDurationTitle = self.secondsToMinutes(intDuration)
                
                if secondsToMinsCurrentTitle.hours == 0 {
                    self.currentTimeTitle.text = String(format: "%02d:%02d", secondsToMinsCurrentTitle.minutes,secondsToMinsCurrentTitle.seconds )
                } else {
                    self.currentTimeTitle.text = String(format: "%02d:%02d:%02d", secondsToMinsCurrentTitle.hours, secondsToMinsCurrentTitle.minutes,secondsToMinsCurrentTitle.seconds )
                }
                if secondsToMinsDurationTitle.hours == 0 {
                    self.durationLabel.text = String(format: "%02d:%02d", secondsToMinsDurationTitle.minutes,secondsToMinsDurationTitle.seconds )
                } else {
                    self.durationLabel.text = String(format: "%02d:%02d:%02d", secondsToMinsDurationTitle.hours, secondsToMinsDurationTitle.minutes,secondsToMinsDurationTitle.seconds )
                }
            }
        }
    }
    
    private func secondsToMinutes(_ seconds: Int) -> (hours: Int ,minutes:Int,seconds: Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    //MARK: - IBActions
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
        let percentage = currentTimeSlider.value
        playerView.duration { duration, error in
            
            let seekTime = Float(duration) * percentage
            self.playerView.seek(toSeconds: seekTime, allowSeekAhead: true)
            let intSeekTime = Int(seekTime)
            let intDuration = Int(duration - Double(seekTime))
            
            let secondsToMinsCurrentTitle = self.secondsToMinutes(intSeekTime)
            let secondsToMinsDurationTitle = self.secondsToMinutes(intDuration)
            
            if secondsToMinsCurrentTitle.hours == 0 {
                self.currentTimeTitle.text = String(format: "%02d:%02d", secondsToMinsCurrentTitle.minutes,secondsToMinsCurrentTitle.seconds )
            } else {
                self.currentTimeTitle.text = String(format: "%02d:%02d:%02d", secondsToMinsCurrentTitle.hours, secondsToMinsCurrentTitle.minutes,secondsToMinsCurrentTitle.seconds )
            }
            if secondsToMinsDurationTitle.hours == 0 {
                self.durationLabel.text = String(format: "%02d:%02d", secondsToMinsDurationTitle.minutes,secondsToMinsDurationTitle.seconds )
            } else {
                self.durationLabel.text = String(format: "%02d:%02d:%02d", secondsToMinsDurationTitle.hours, secondsToMinsDurationTitle.minutes,secondsToMinsDurationTitle.seconds )
            }
            
        }
        
    }
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
        
        MPVolumeView.setVolume(volumeSlider.value)
        
    }
    @IBAction func prevButtonPressed(_ sender: UIButton) {
        playerView.previousVideo()
        self.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        
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

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let volumeSlider = volumeView.subviews.first { $0 is UISlider } as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            volumeSlider?.value = volume
        }
    }
}


extension String {
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}

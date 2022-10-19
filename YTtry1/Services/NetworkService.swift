//
//  Model .swift
//  YTtry1
//
//  Created by Nephilim  on 10/12/22.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkServiceTPVCDelegate {
    func channelsFetched(_ channels: [ChannelModel])
}
protocol NetworkServiceMainVCDelegate {
    
    func videosFetched(_ vidoes: [VideoModel])
    func videosFetched2(_ vidoes: [VideoModel])
    func playlistsTitleFetched(_ plTitle: String)
    func playlistsTitleFetched2(_ plTitle: String)
}
protocol NetworkServicePlayerDelegate {
    func statsFetched(_ statItem: VideoStatistics)
    func nameFetched(_ videoName: String)
}

class NetworkService {
    
    var tpvcDelegate : NetworkServiceTPVCDelegate?
    var mainvcDelegate :NetworkServiceMainVCDelegate?
    var playerDelegate: NetworkServicePlayerDelegate?

    func combineChannelModel() {
        var models = [ChannelModel]()
        
        Constants.CHANNEL_IDS.forEach { channelID in
            
            let uploadPlaylistUrl = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=\(channelID)&key=\(Constants.API_KEY)"
            
            AF.request(uploadPlaylistUrl).responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let valueJson: JSON = JSON(value)
                    //dump(valueJson)
                    guard let uploadPlaylist = valueJson["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"].string else { return }
                    let bannerTitleurl = "https://www.googleapis.com/youtube/v3/channels?part=brandingSettings&id=\(channelID)&key=\(Constants.API_KEY)"

                    AF.request(bannerTitleurl).responseJSON(completionHandler: { response in
                        
                        switch response.result {
                        case .success(let value):
                            let valueJson: JSON = JSON(value)
                            guard let banner = valueJson["items"][0]["brandingSettings"]["image"]["bannerExternalUrl"].string else {return}
                            guard let title = valueJson["items"][0]["brandingSettings"]["channel"]["title"].string else {return}
                            let subsCountUrl = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=\(channelID)&key=AIzaSyCIXNoadAqOlUtjk7irFeE3GYLPRHpcRcE"
                            AF.request(subsCountUrl).responseJSON { dataResponse  in
                                switch dataResponse.result {
                                case .success(let value):
                                    let valueJson: JSON = JSON(value)
                                    guard let subsCount = valueJson["items"][0]["statistics"]["subscriberCount"].string else { return }
                                    
                                    let model = ChannelModel(uploadPlaylist: uploadPlaylist, bannerUrl: banner, subsCount: subsCount,title: title)
                                    models.append(model)
                                    if Constants.CHANNEL_IDS.count == models.count {
                                        self.tpvcDelegate?.channelsFetched(models)
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })

                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getVideoName(_ videoID: String) {
        let url = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet&id=\(videoID)&key=\(Constants.API_KEY)"
        AF.request(url).responseJSON { data in
            switch data.result {
            case .success(let value):
                let valueJson: JSON = JSON(value)
                guard let videoName = valueJson["items"][0]["snippet"]["title"].string else { return }
                self.playerDelegate?.nameFetched(videoName)
            case .failure(let error):
                print(error)
            }
        }
    }
    func getSmollVideoStat(_ videoID: String) {
        if videoID.count > 3 {
            let url = "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id=\(videoID)&key=\(Constants.API_KEY)"
            AF.request(url).responseData { dataResponse in
                if let error = dataResponse.error {
                    print("Error received requestiong data: \(error.localizedDescription)")
                    return
                }
                guard let data = dataResponse.data else {return}

                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SecondResponse.self, from: data)
                    if let model = objects.items?[0] {
                        self.playerDelegate?.statsFetched(model)
                        self.getVideoName(videoID)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func fetchVideosFromPlaylists() {
        for (index,value) in Constants.PLAYLIST_IDS.enumerated() {
            
            let url = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(value)&key=\(Constants.API_KEY)&maxResults=10"
            
            AF.request(url).responseData { dataResponse in
                if let error = dataResponse.error {
                    print("Error received requestiong data: \(error.localizedDescription)")
                    return
                }
                guard let data = dataResponse.data else {return}
                
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(FirstResponse.self, from: data)
                    if objects.items != nil {
                        print("objects.items = \(objects.items!.count) <<<<<<<<<<<<<<<<<<")
                        
                        if index == 1 {
                            self.fetchVideoStatisticInfo2(objects.items!)
                        } else {
                            self.fetchVideoStatisticInfo(objects.items!)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            let playlistNameUrl = "https://www.googleapis.com/youtube/v3/playlists?key=\(Constants.API_KEY)&id=\(value)&part=id,snippet&fields=items(id,snippet(title,channelId,channelTitle))"
            AF.request(playlistNameUrl).responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let valueJson: JSON = JSON(value)
                    guard let plalistName = valueJson["items"][0]["snippet"]["title"].string else { return }
                    if index == 1 {
                        self.mainvcDelegate?.playlistsTitleFetched2( plalistName)
                    } else {
                        self.mainvcDelegate?.playlistsTitleFetched( plalistName)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchVideoStatisticInfo2(_ videos: [Video]) {
        var models = [VideoModel]()
        
        videos.forEach { video in
            
            let id = video.videoID
            let url = "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id=\(id)&key=\(Constants.API_KEY)"
            AF.request(url).responseData { dataResponse in
                if let error = dataResponse.error {
                    print("Error received requestiong data: \(error.localizedDescription)")
                    return
                }
                guard let data = dataResponse.data else {return}
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SecondResponse.self, from: data)
                    if let model = objects.items?[0] {
                        let newItem = VideoModel(videoName: video.title, videoViewsCount: model.viewCount, videoPreviewURL: video.thumbnail,videoID : video.videoID, videoLikesCount: model.likeCount)
                        
                        models.append(newItem)
                    }
                    if models.count == videos.count {
                        self.mainvcDelegate?.videosFetched2(models)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchVideoStatisticInfo(_ videos: [Video]) {
        var models = [VideoModel]()
        videos.forEach { video in
            
            let id = video.videoID
            let url = "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id=\(id)&key=\(Constants.API_KEY)"
            AF.request(url).responseData { dataResponse in
                if let error = dataResponse.error {
                    print("Error received requestiong data: \(error.localizedDescription)")
                    return
                }
                guard let data = dataResponse.data else {return}
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SecondResponse.self, from: data)
                    if let model = objects.items?[0] {
                        let newItem = VideoModel(videoName: video.title, videoViewsCount: model.viewCount, videoPreviewURL: video.thumbnail,videoID : video.videoID, videoLikesCount: model.likeCount)
                        
                        models.append(newItem)
                    }
                    if models.count == videos.count {
                        self.mainvcDelegate?.videosFetched(models)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

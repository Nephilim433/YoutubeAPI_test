//
//  Model .swift
//  YTtry1
//
//  Created by Nephilim  on 10/12/22.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkServiceDelegate {
    func channelsFetched(_ channels: [ChannelModel])
}

protocol NetworkServiceForViewController {
    
    func videosFetched(_ vidoes: [VideoModel])
    func videosFetched2(_ vidoes: [VideoModel])
}
protocol NetworkServiceForDeteilView {
    func statsFetched(_ statItem: VideoStatistics)
    func nameFetched(_ videoName: String)
}

class NetworkService {
    
    var delegate : NetworkServiceDelegate?
    var vcDelegate :NetworkServiceForViewController?
    var detDelegate: NetworkServiceForDeteilView?
    
    
    func combineChannelModel() {
        var models = [ChannelModel]()
        
        Constants.CHANNEL_IDS.forEach { channelID in
            
            let uploadPlaylistUrl = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=\(channelID)&key=AIzaSyCIXNoadAqOlUtjk7irFeE3GYLPRHpcRcE"
            
            AF.request(uploadPlaylistUrl).responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let valueJson: JSON = JSON(value)
                    //dump(valueJson)
                    guard let uploadPlaylist = valueJson["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"].string else { return }
                    
                    print("uploadPlaylist is \(uploadPlaylist)")
                    print("we got the upload playlist ID")
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
                                        self.delegate?.channelsFetched(models)
                                        
                                        //self.vcDelegate?.openDetailViewWith(models) // enebling gesture and opening detail view
                                    }
                                    
                                case .failure(let error):
                                    print(error)
                                }
                                    
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
                    //pewdiepie's uploadlist ID : UU-lHJZR3Gqxm24_Vd_AJ5Yw
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
                print("videoName = \(videoName) <><<<><><><><><><><><><><><><><><")
                self.detDelegate?.nameFetched(videoName)
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
            //print("data that comes with data statistics \(data)")
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SecondResponse.self, from: data)
                    if let model = objects.items?[0] {
                        self.detDelegate?.statsFetched(model)
                        self.getVideoName(videoID)
                        //print("the model is \(model) <><><><><><><><><><><><><")
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
            
            
        }
    }
    
    
    func fetchVideosFromPlaylists() {
        
        for (index,value) in Constants.PLAYLIST_IDS.enumerated() {
            
            let url = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(value)&key=\(Constants.API_KEY)"
            
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
                    
                    //self.delegate?.videosFetched(objects.items!)
                    print("objects.items = \(objects.items!) <<<<<<<<<<<<<<<<<<")
//                    self.fetchVideoStatisticInfo(objects.items!)
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
            //print("data that comes with data statistics \(data)")
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SecondResponse.self, from: data)
                    if let model = objects.items?[0] {
                        let newItem = VideoModel(videoName: video.title, videoViewsCount: model.viewCount, videoPreviewURL: video.thumbnail,videoID : video.videoID, videoLikesCount: model.likeCount)
                        
                        models.append(newItem)
                    }
                if models.count == videos.count {
                    self.vcDelegate?.videosFetched2(models)
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
            //print("data that comes with data statistics \(data)")
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SecondResponse.self, from: data)
                    if let model = objects.items?[0] {
                        let newItem = VideoModel(videoName: video.title, videoViewsCount: model.viewCount, videoPreviewURL: video.thumbnail,videoID : video.videoID, videoLikesCount: model.likeCount)
                        
                        models.append(newItem)
                    }
                if models.count == videos.count {
                    self.vcDelegate?.videosFetched(models)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        }
    }
    
   
    
    


}

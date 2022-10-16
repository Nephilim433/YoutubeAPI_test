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
    func videosFetched(_ vidoes: [Video])
    func channelsFetched(_ channels: [ChannelModel])
}
protocol NetworkServiceDelegate2 {
    func mapStatisticts()
    func mapBanner()
    var statistics : [VideoStatistics] { get set }
}


class NetworkService {
    
    var delegate : NetworkServiceDelegate?
    var delegate2 : NetworkServiceDelegate2?
    
    
    
    
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
                                        
//                                        self.vcDelegate?.openDetailViewWith(models) // enebling gesture and opening detail view
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
    
    
    
    
    
    func fetchVideoStatisticInfo(_ videos: [Video], complition : @escaping (Bool) -> Void) {
        var models = [VideoStatistics]()
        

        
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
                        //print("the model is \(model)")
                        self.delegate2?.statistics.append(model)
                        models.append(model)
                    }
                if models.count == videos.count {
                    complition(true)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        }
    }
    
   

    
    func fetchVideosFromPlaylists() {
        
        AF.request(Constants.API_URL).responseData { dataResponse in
            if let error = dataResponse.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                return
            }

            guard let data = dataResponse.data else {return}

            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(FirstResponse.self, from: data)
                if objects.items != nil {
                    self.delegate?.videosFetched(objects.items!)
                    print("objects.items = \(objects.items!)")
                    self.fetchVideoStatisticInfo(objects.items!) { success in
                        if success {
                            self.delegate2?.mapStatisticts()
                        }
                    }
                }
            } catch {

            }
        }

    }
    
//    func getVideos() {
//
//        // Create a URL object
//        let url = URL(string: Constants.API_URL)
//
//        guard url != nil else { return }
//
//        let session = URLSession.shared
//        // Get a url session object
//        let dataTask = session.dataTask(with: url!) { data, response, error in
//            if error != nil || data == nil {
//                return
//            }
//            //Parsing the data video objects
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(FirstResponse.self, from: data!)
//                if response.items != nil {
//                    //self.fetchVideoStatisticInfo(response.items!)
//                    self.delegate?.videosFetched(response.items!)
//                }
//
//            } catch  {
//
//            }
//        }
//        dataTask.resume()
//        // get a data task
//    }
}

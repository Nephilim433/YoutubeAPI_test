//
//  Video.swift
//  YTtry1
//
//  Created by Nephilim  on 10/12/22.
//

import Foundation

struct Video: Decodable {

    var videoID = ""
    var title = ""
    var thumbnail = ""
    
    
    enum CodingKeys: String, CodingKey {
        
        case snippet
        case thumbnails
        case maxres
        case resourceId
        
        case title
        case thumbnail = "url"
        case videoId
    }
    
    
   
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let snippetConteiner = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        //Parse title
        self.title = try snippetConteiner.decode(String.self, forKey: .title)
        //Parse thumbnail
        
        let thumbnailsContainer = try snippetConteiner.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
        let maxresContainer = try thumbnailsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .maxres)
        self.thumbnail = try maxresContainer.decode(String.self, forKey: .thumbnail)
        
        //parse Video ID
        let resourceIdContainer = try snippetConteiner.nestedContainer(keyedBy: CodingKeys.self, forKey: .resourceId)
        self.videoID = try resourceIdContainer.decode(String.self, forKey: .videoId)
        
    }
}

struct FirstResponse : Decodable {
    
    var items: [Video]?
    
    enum CodingKeys : String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([Video].self, forKey: .items)
    }
}

struct SecondResponse: Decodable {
    
    var items: [VideoStatistics]?
    enum CodingKeys : String, CodingKey {
        case items
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([VideoStatistics].self, forKey: .items)
    }
}

struct VideoStatistics: Decodable {
    
    var viewCount = ""
    var likeCount = ""
    
    
    enum CodingKeys : String, CodingKey {
        case statistics
        case viewCount
        case likeCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let statisticContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .statistics)
        self.likeCount = try statisticContainer.decode(String.self, forKey: .likeCount)
        self.viewCount = try statisticContainer.decode(String.self, forKey: .viewCount)
        
    }
}

struct ThirdResponse : Decodable {
    var items: [ChannelBranding]?
    enum CodingKeys : String, CodingKey {
        case items
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([ChannelBranding].self, forKey: .items)
    }
}

struct ChannelBranding: Decodable {
    var bannerExternalUrl = ""
    
    enum CodingKeys: String , CodingKey {
        
        case brandingSettings
        case image
        case bannerExternalUrl
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let brandingSettingsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .brandingSettings)
        let imgeContainer = try brandingSettingsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .image)
        self.bannerExternalUrl = try imgeContainer.decode(String.self, forKey: .bannerExternalUrl)
        
    }
}

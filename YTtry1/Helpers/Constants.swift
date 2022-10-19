//
//  Constants.swift
//  YTtry1
//
//  Created by Nephilim  on 10/12/22.
//

import Foundation

struct Constants {
    static var backgorundHexColor = "#1D1B26"
    
    static var API_KEY = "AIzaSyCIXNoadAqOlUtjk7irFeE3GYLPRHpcRcE"
    static var PLAYLIST_ID = "PLYH8WvNV1YEkRR6peiTWZfIRUglGJBQV5"
    static var URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId="
    static var API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
    
    static var PLAYLIST_IDS = ["PLqeSJS3N5tzhnHnb4uDhYJtwfQmadsCZ9","PLSdoVPM5WnndSQEXRz704yQkKwx76GvPV"]

    static var CHANNEL_IDS:[String] = ["UC_ODKC5gTs2LvdHXDRdDm0w","UCqY_JCZxqsyi9x3s31kFIRA","UCoUM-UJ7rirJYP8CQ0EIaHA", "UC9UhWlkLfeypFt7pp7v_aBw"]

    static let SFProDisplayBold = "SFProDisplay-Bold"
    static let SFProTextMedium = "SFProText-Medium"
    static let SFProTextRegular = "SFProText-Regular"
    static let SFProTextSemibold = "SFProText-Semibold"

    static let initialVideoID = "9R2QB0HsR0Y"
}

//
//  Constants.swift
//  YTtry1
//
//  Created by Nephilim  on 10/12/22.
//

import Foundation

struct Constants {
    
    static var API_KEY = "AIzaSyCIXNoadAqOlUtjk7irFeE3GYLPRHpcRcE"
    static var PLAYLIST_ID = "PLYH8WvNV1YEkRR6peiTWZfIRUglGJBQV5"
    static var API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
    
    static var CHANNEL_IDS:[String] = ["UC-lHJZR3Gqxm24_Vd_AJ5Yw","UCqY_JCZxqsyi9x3s31kFIRA","UCpiyhkUDOotGjl-exIJpaBg"]
    
    //static var API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
}

//`"https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id=MVu8QbxafJE&key=\(Constants.API_KEY)"` <- приклад реквеста по одному відосу

//https://www.googleapis.com/youtube/v3/channels?part=brandingSettings&id=UC-lHJZR3Gqxm24_Vd_AJ5Yw&key=AIzaSyCIXNoadAqOlUtjk7irFeE3GYLPRHpcRcE


//https://www.googleapis.com/youtube/v3/channels?part=statistics&id=channel_id&key=your_key
//channel ID ref UC-lHJZR3Gqxm24_Vd_AJ5Yw

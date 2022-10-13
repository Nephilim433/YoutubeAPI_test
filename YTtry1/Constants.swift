//
//  Constants.swift
//  YTtry1
//
//  Created by Nephilim  on 10/12/22.
//

import Foundation

struct Constants {
    
    static var API_KEY = "AIzaSyCIXNoadAqOlUtjk7irFeE3GYLPRHpcRcE"
    static var PLAYLIST_ID = "PLJ8cMiYb3G5eZQK-3tCqQCWV49C1M6aKh"
    static var API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
    
    //static var API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
}

//`"https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id=MVu8QbxafJE&key=\(Constants.API_KEY)"` <- приклад реквеста по одному відосу

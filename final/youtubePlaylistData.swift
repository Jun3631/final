//
//  youtubedata.swift
//  final
//
//  Created by Jun3631 on 2022/1/25.
//

import Foundation

struct youtubePlaylistData : Identifiable {
    var id : String
    var title : String
    var thumbnail : String
    var channelTitle : String
    var publishedAt : String
    var videoId : String
}

struct youtubeChannelData :  Identifiable{
    var id : String
    var bannerMobileExtraHdImageUrl : String
    var thumbnails : String
    var title : String
    var subscriberCount : String
    var description : String
    var publishedAt : String
    var viewCount : String
    var videoCount : String
}

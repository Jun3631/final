//
//  abc.swift
//  final
//
//  Created by Jun3631 on 2022/1/26.
//

import SwiftUI
import SwiftyJSON
import WebKit

struct youtubeVideoUIView: View {
    var videoId : String
    var body: some View {
        AsyncImage(url: URL(string:  "https://www.youtube.com/watch?v="+videoId))
    }
}

struct youtubeVideoUIView_Previews: PreviewProvider {
    static var previews: some View {
        youtubeVideoUIView(videoId: "")
    }
}

//
//  VideoTableViewController.swift
//  final
//
//  Created by Jun3631 on 2022/1/25.
//

import SwiftUI
import SwiftyJSON

struct youtubeUIView: View {
    @ObservedObject var results = getyoutubePlaylistData()
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                ForEach(results.data){result in
                    NavigationLink(destination: youtubeVideoUIView(videoId: result.videoId)){
                        HStack(alignment: .top, spacing: 10){
                            AsyncImage(url: URL(string:  result.thumbnail)){ image in
                                image
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:UIScreen.main.bounds.width/3)
                            } placeholder: {
                                Color.gray
                            }
                            
                            
                            VStack(alignment: .leading){
                                Text(result.title)
                                    .fontWeight(.medium)
                                    .font(.system(size: 15))
                                Text(result.channelTitle)
                                    .foregroundColor(Color(.gray))
                                    .font(.system(size: 13))
                                Text(result.publishedAt)
                                    .foregroundColor(Color(.gray))
                                    .font(.system(size: 13))
                            }
                            Spacer()
                        }.padding(.horizontal)
                    }
                }
            }.navigationBarItems(leading:
                                    HStack{
                Image("ladyflavorLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width:UIScreen.main.bounds.width/4)
                Text("好味小姐")
                    .foregroundColor(Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0))
            }
            )
        }
    }
}

struct youtubeUIView_Previews: PreviewProvider {
    static var previews: some View {
        youtubeUIView()
    }
}

class getyoutubePlaylistData: ObservableObject {
    @Published var data = [youtubePlaylistData]()
    init(){
        let url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails,status&playlistId=UUOz7W0VH--2WlqAE_3jtL4w&key=AIzaSyBJEsFFliYOCD7UvHI8-UtRWYsJ-Nj7T0o&maxResults=20"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!){(data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSON(data: data!)
            let items = json["items"].array!
            for i in items{
                let id = i["id"].stringValue
                let title = i["snippet"]["title"].stringValue
                let thumbnail = i["snippet"]["thumbnails"]["high"]["url"].stringValue
                let channelTitle = i["snippet"]["channelTitle"].stringValue
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"//"E MMM d HH:mm:ss Z yyyy"
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                let published = i["snippet"]["publishedAt"].stringValue
                let publishedA = dateFormatter.date(from: published)
                let publishedAt = dateFormat.string(from: publishedA!)
                let videoId = i["snippet"]["resourceId"]["videoId"].stringValue
                DispatchQueue.main.async {
                    self.data.append(youtubePlaylistData(id: id, title: title, thumbnail: thumbnail, channelTitle: channelTitle, publishedAt: publishedAt,videoId: videoId))
                }
            }
            
        }.resume()
        
        
    }
}



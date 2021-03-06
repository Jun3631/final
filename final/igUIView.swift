//
//  igUIView.swift
//  final
//
//  Created by Jun3631 on 2022/1/26.
//

import SwiftUI
import SwiftyJSON

struct igUIView: View {
    @ObservedObject var results = getinstagramProfileData()
    @ObservedObject var posts = getinstagramPostData()
    
    @State private var show = false
    var body: some View {
        let collec = posts.data.collection(into: 3)
        return NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                /*ForEach(results.data){result in
                    VStack(alignment: .leading, spacing: 10){
                        //第一行 頭貼 id 勾勾 貼文數 粉絲 追隨
                        HStack(alignment: .center, spacing: 30){
                            ZStack{
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.init(red: 74/255, green: 55/255, blue: 222/255), Color.init(red: 244/255, green: 191/255, blue: 102/255)]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                                    .frame(width:UIScreen.main.bounds.width/5+8.5,height:UIScreen.main.bounds.width/5+8.5)
                                AsyncImage(url: URL(string:  result.profile_pic_url_hd)){image in image
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:UIScreen.main.bounds.width/5,height: UIScreen.main.bounds.width/5)
                                        .cornerRadius(UIScreen.main.bounds.width/5)
                                }placeholder: {
                                    Color.gray
                                }
                            }
                            VStack(alignment: .leading, spacing: 10){
                                HStack(alignment: .center, spacing: 5){
                                    Text(result.username)
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                    if result.is_verified == true{
                                        Image("verified")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:UIScreen.main.bounds.width/25,height: UIScreen.main.bounds.width/25)
                                    }
                                }
                                HStack(spacing: 20){
                                    VStack(alignment: .center){
                                        Text("\(result.edge_owner_to_timeline_media_postcount)")
                                            .fontWeight(.bold)
                                            .font(.system(size: 15))
                                        Text("貼文數")
                                            .font(.system(size: 13))
                                    }
                                    VStack(alignment: .center){
                                        Text("\(result.edge_followed_by)")
                                            .fontWeight(.bold)
                                            .font(.system(size: 15))
                                        Text("粉絲人數")
                                            .font(.system(size: 13))
                                    }
                                    VStack(alignment: .center){
                                        Text("\(result.edge_follow)")
                                            .fontWeight(.bold)
                                            .font(.system(size: 15))
                                        Text("追蹤中")
                                            .font(.system(size: 13))
                                    }
                                    Spacer()
                                }
                            }
                        }.padding(.horizontal)
                        //全名 自傳 外部連結
                        VStack(alignment: .leading, spacing: 5){
                            Text(result.full_name)
                                .fontWeight(.bold)
                            Text(result.biography)
                                .font(.system(size: 13))
                            Text(result.external_url)
                                .font(.system(size: 13))
                                .foregroundColor(Color(red: 0.108, green: 0.586, blue: 0.881)).onTapGesture {
                                    self.show.toggle()
                                    
                                }.sheet(isPresented: self.$show){
                                    SafariView(url: URL(string: result.external_url)!)
                                }
                        }.padding(.horizontal)
                    }.padding(.vertical)
                }*/
                ForEach(0..<collec.count){ row in
                    HStack{
                        ForEach(collec[row]){ collecs in
                            NavigationLink(destination: igPostUIView(__typename: collecs.__typename,
                                                                     shortcode: collecs.shortcode,
                                                                     text: collecs.text,
                                                                     display_url: collecs.display_url,
                                                                     comment: collecs.comment,
                                                                     liked: collecs.liked
                                                                    )){
                                
                                AsyncImage(url: URL(string:  collecs.thumbnail)){image in image
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:UIScreen.main.bounds.width/3,height: UIScreen.main.bounds.width/3)
                                }placeholder: {
                                    Color.gray
                                }
                            }
                        }
                    }
                }
            }.navigationBarTitle("Instagram",displayMode: .inline)
        }//.edgesIgnoringSafeArea(.top)
    }
}

struct igUIView_Previews: PreviewProvider {
    static var previews: some View {
        igUIView()
    }
}





class getinstagramProfileData : ObservableObject {
    @Published var data = [instagramProfileData]()
    init(){
        let url = "https://www.instagram.com/ladyflavor_cui/?__a=1"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!){(data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSON(data: data!)
            let id = json["graphql"]["user"]["id"].stringValue
            let profile_pic_url_hd = json["graphql"]["user"]["profile_pic_url_hd"].stringValue
            let username = json["graphql"]["user"]["username"].stringValue#imageLiteral(resourceName: "simulator_screenshot_4F226A23-6A08-42B0-8D1F-FD5F3C3390F2.png")
            let is_verified = json["graphql"]["user"]["is_verified"].boolValue
            let edge_followed_by = json["graphql"]["user"]["edge_followed_by"]["count"].intValue
            let edge_follow = json["graphql"]["user"]["edge_follow"]["count"].intValue
            let full_name = json["graphql"]["user"]["full_name"].stringValue
            let biography = json["graphql"]["user"]["biography"].stringValue
            let external_url = json["graphql"]["user"]["external_url"].stringValue
            let edge_owner_to_timeline_media_postcount = json["graphql"]["user"]["edge_owner_to_timeline_media"]["count"].intValue
            DispatchQueue.main.async {
                self.data.append(instagramProfileData(id: id, profile_pic_url_hd: profile_pic_url_hd, username: username, is_verified: is_verified, edge_followed_by: edge_followed_by, edge_follow: edge_follow, full_name: full_name, biography: biography, external_url: external_url, edge_owner_to_timeline_media_postcount: edge_owner_to_timeline_media_postcount))
            }
        }.resume()
        
        
    }
}

class getinstagramPostData: ObservableObject {
    @Published var data = [instagramPostData]()
    //@Published var videoData : instagramVideoData
    init(){
        let url = "https://www.instagram.com/ladyflavor_cui/?__a=1"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!){(data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSON(data: data!)
            let edges = json["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"].array!
            for i in edges{
                let id = i["node"]["id"].stringValue
                let display_url = i["node"]["display_url"].stringValue
                let text = i["node"]["edge_media_to_caption"]["edges"][0]["node"]["text"].stringValue
                let comment = i["node"]["edge_media_to_comment"]["count"].intValue
                let liked = i["node"]["edge_liked_by"]["count"].intValue
                let thumbnail = i["node"]["thumbnail_resources"][4]["src"].stringValue
                let __typename = i["node"]["__typename"].stringValue
                let shortcode = i["node"]["shortcode"].stringValue
                
                
                DispatchQueue.main.async {
                    self.data.append(instagramPostData(id: id, display_url: display_url, text: text, comment: comment, liked: liked, thumbnail: thumbnail,__typename: __typename,shortcode: shortcode))
                }
            }
            
        }.resume()
        
        
    }
}

extension Array{
    func collection(into size: Int) -> [[Element]]{
        return stride(from: 0, to: count, by: size).map{
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

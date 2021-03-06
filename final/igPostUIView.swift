//
//  igPostUIView.swift
//  final
//
//  Created by Jun3631 on 2022/1/26.
//

import SwiftUI
import SwiftyJSON
import AVKit

struct igPostUIView: View {
    @ObservedObject var results = getinstagramProfileData()
    
    
    @State var player = AVPlayer(url: URL(string: "https://scontent-tpe1-1.cdninstagram.com/v/t50.2886-16/103435192_120999152963452_8029942739370787312_n.mp4?_nc_ht=scontent-tpe1-1.cdninstagram.com&_nc_cat=104&_nc_ohc=pgxkLzk-6PkAX96yeh9&oe=5EF9992B&oh=b1be375bb86541b7a752620c1c843349")!)
    @State var isplaying = false
    @State var showcontrols = false
    @State var value : Float = 0
    
    
    var __typename : String
    var shortcode : String
    var text : String
    var display_url : String
    var comment : Int
    var liked : Int
    
    //@ObservedObject var videos = getinstagramVideoData()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            //************titlebar
            ForEach(results.data){result in
                VStack(alignment: .leading, spacing: 10){
                    HStack(alignment: .center, spacing: 10){
                        ZStack{
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.init(red: 74/255, green: 55/255, blue: 222/255), Color.init(red: 244/255, green: 191/255, blue: 102/255)]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                                .frame(width:UIScreen.main.bounds.width/10+3,height:UIScreen.main.bounds.width/10+3)
                            AsyncImage(url: URL(string: result.profile_pic_url_hd)){ image in
                                image
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                    .cornerRadius(UIScreen.main.bounds.width/10)
                            }
                        placeholder: {
                            Color.gray
                        }
                        }
                        HStack(alignment: .center, spacing: 5){
                            Text(result.username)
                                .fontWeight(.bold)
                                .font(.system(size: 15))
                            if result.is_verified == true{
                                Image("verified")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:UIScreen.main.bounds.width/25,height: UIScreen.main.bounds.width/25)
                            }
                        }
                        Spacer()
                    }.padding(.horizontal)
                }.padding(.vertical)
            }
            //********************GrapghImage
            
            if __typename == "GraphImage"{
                AsyncImage(url: URL(string: display_url)){ image in
                    image
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width:UIScreen.main.bounds.width)
                }
            placeholder: {
                Color.gray
            }
            }
            //***************GraphVideo
            else if __typename == "GraphVideo"{
                VStack{
                    
                    ZStack{
                        
                        VideoPlayer(player: $player)
                        
                        if self.showcontrols{
                            
                            Controls(player: self.$player, isplaying: self.$isplaying, pannel: self.$showcontrols,value: self.$value)
                        }
                        
                    }
                    .frame(height: UIScreen.main.bounds.height / 3.5)
                    .onTapGesture {
                        
                        self.showcontrols = true
                    }
                    
                    
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .onAppear {
                    self.player.play()
                    self.isplaying = true
                }
            }
            //***************GraphSideCar
            else if __typename == "GraphSideCar"{
                AsyncImage(url: URL(string: display_url)){ image in
                    image
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width:UIScreen.main.bounds.width)
                }placeholder: {
                    Color.gray
                }
            }
            
            
            HStack(spacing: 20){
                Image("liked")
                    .resizable()
                    .scaledToFit()
                    .frame(width:UIScreen.main.bounds.width/15)
                Image("comment")
                    .resizable()
                    .scaledToFit()
                    .frame(width:UIScreen.main.bounds.width/15)
                Image("send")
                    .resizable()
                    .scaledToFit()
                    .frame(width:UIScreen.main.bounds.width/15)
                Spacer()
                Image("bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width:UIScreen.main.bounds.width/15)
            }.padding(.horizontal)
            
            HStack{
                VStack(alignment: .leading, spacing: 5){
                    Text("\(liked)??????")
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    Text(text)
                        .font(.system(size: 15))
                    Text("\(comment)?????????")
                        .foregroundColor(Color(.gray))
                        .font(.system(size: 15))
                }
                Spacer()
            }.padding(.horizontal)
            
        }
    }
}

struct igPostUIView_Previews: PreviewProvider {
    static var previews: some View {
        igPostUIView(__typename: "", shortcode: "", text: "", display_url: "", comment: 0, liked: 0)
    }
}


struct Controls : View {
    
    @Binding var player : AVPlayer
    @Binding var isplaying : Bool
    @Binding var pannel : Bool
    @Binding var value : Float
    
    var body : some View{
        
        VStack{
            
            Spacer()
            
            HStack{
                
                Button(action: {
                    
                    self.player.seek(to: CMTime(seconds: self.getSeconds() - 10, preferredTimescale: 1))
                    
                }) {
                    
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                
                Spacer()
                
                Button(action: {
                    
                    if self.isplaying{
                        
                        self.player.pause()
                        self.isplaying = false
                    }
                    else{
                        
                        self.player.play()
                        self.isplaying = true
                    }
                    
                }) {
                    
                    Image(systemName: self.isplaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                
                Spacer()
                
                Button(action: {
                    
                    self.player.seek(to: CMTime(seconds: self.getSeconds() + 10, preferredTimescale: 1))
                    
                }) {
                    
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
            }
            
            Spacer()
            
            CustomProgressBar(value: self.$value, player: self.$player, isplaying: self.$isplaying)
            
        }.padding()
            .background(Color.black.opacity(0.4))
            .onTapGesture {
                
                self.pannel = false
            }
            .onAppear {
                
                self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { (_) in
                    
                    self.value = self.getSliderValue()
                    
                    if self.value == 1.0{
                        
                        self.isplaying = false
                    }
                }
            }
        
        
    }
    
    func getSliderValue()->Float{
        
        return Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds)!)
    }
    
    func getSeconds()->Double{
        
        return Double(Double(self.value) * (self.player.currentItem?.duration.seconds)!)
    }
}

struct CustomProgressBar : UIViewRepresentable {
    
    
    func makeCoordinator() -> CustomProgressBar.Coordinator {
        
        return CustomProgressBar.Coordinator(parent1: self)
    }
    
    
    @Binding var value : Float
    @Binding var player : AVPlayer
    @Binding var isplaying : Bool
    
    func makeUIView(context: UIViewRepresentableContext<CustomProgressBar>) -> UISlider {
        
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .gray
        slider.thumbTintColor = .red
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.value = value
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.changed(slider:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: UIViewRepresentableContext<CustomProgressBar>) {
        
        uiView.value = value
    }
    
    class Coordinator : NSObject{
        
        var parent : CustomProgressBar
        
        init(parent1 : CustomProgressBar) {
            
            parent = parent1
        }
        
        @objc func changed(slider : UISlider){
            
            if slider.isTracking{
                
                parent.player.pause()
                
                let sec = Double(slider.value * Float((parent.player.currentItem?.duration.seconds)!))
                
                parent.player.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
            }
            else{
                
                let sec = Double(slider.value * Float((parent.player.currentItem?.duration.seconds)!))
                
                parent.player.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
                
                if parent.isplaying{
                    
                    parent.player.play()
                }
            }
        }
    }
}

class Host : UIHostingController<igPostUIView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}

struct VideoPlayer : UIViewControllerRepresentable {
    
    @Binding var player : AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayer>) {
        
        
    }
}

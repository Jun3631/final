//
//  ContentView.swift
//  final
//
//  Created by Jun3631 on 2022/1/25.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ContentView: View {
    var body: some View {
        TabView {
            youtubeUIView().tabItem {
                Image("YoutubeLogo")
                //Text("Youtube-Logo")
            }
            igUIView().tabItem{
                Image("igLogo")
            }
            
        }
    }
}
/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 */

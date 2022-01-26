//
//  SafariView.swift
//  final
//
//  Created by Jun3631 on 2022/1/26.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SFSafariViewController {
         SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
            
    }
    
    let url: URL
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://www.ladygaga.com/")!)
    }
}

//
//  WebPageView.swift
//  WebPageView
//
//  Created by Tatsuyuki Kobayashi on 2021/09/02.
//

import SwiftUI
import UIKit

struct WebPageView: UIViewControllerRepresentable {
    typealias UIViewControllerType = WebViewController
    
    let url: URL
    
    func makeUIViewController(context: Context) -> WebViewController {
        let vc = WebViewController(url: url)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
    }
}

struct WebPageView_Previews: PreviewProvider {
    static var previews: some View {
        WebPageView(url: URL(string: "")!)
    }
}

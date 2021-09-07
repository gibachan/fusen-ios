//
//  BookImageView.swift
//  BookImageView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI
import Kingfisher

struct BookImageView: View {
    let url: URL?
    
    var body: some View {
        KFImage(url)
            .placeholder {
                Image.book
                    .resizable()
                    .foregroundColor(.placeholder)
                    .padding(4)
            }
            .fade(duration: 0.25)
            .retry(maxCount: 3, interval: .seconds(5))
            .cancelOnDisappear(true)
            .resizable()
            .scaledToFit()
            .shadow(color: .backgroundGray, radius: 1, x: 2, y: 2)
    }
}

struct BookImageView_Previews: PreviewProvider {
    static var previews: some View {
        BookImageView(url: Book.sample.imageURL)
    }
}

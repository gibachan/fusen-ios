//
//  MemoImageView.swift
//  MemoImageView
//
//  Created by Tatsuyuki Kobayashi on 2021/09/01.
//

import Domain
import Kingfisher
import SwiftUI

struct MemoImageView: View {
    let url: URL?

    var body: some View {
        KFImage(url)
            .placeholder {
                Image.image
                    .resizable()
                    .foregroundColor(.placeholder)
            }
            .fade(duration: 0.25)
            .retry(maxCount: 3, interval: .seconds(5))
            .cancelOnDisappear(true)
            .resizable()
            .scaledToFit()
    }
}

struct MemoImageView_Previews: PreviewProvider {
    static var previews: some View {
        MemoImageView(url: Memo.sample.imageURLs.first)
    }
}

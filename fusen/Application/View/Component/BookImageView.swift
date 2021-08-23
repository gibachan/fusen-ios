//
//  BookImageView.swift
//  BookImageView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI

private var cache: [URL: Image] = [:]

struct BookImageView: View {
    let url: URL?

    var body: some View {
        if let url = url,
           let image = cache[url] {
            image
                .resizable()
        } else {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .onAppear(perform: {
                        if let url = url {
                            cache[url] = image
                        }
                    })
            } placeholder: {
                Image.book
                    .resizable()
                    .foregroundColor(.placeholder)
            }
        }
    }
}

struct BookImageView_Previews: PreviewProvider {
    static var previews: some View {
        BookImageView(url: Book.sample.imageURL)
    }
}

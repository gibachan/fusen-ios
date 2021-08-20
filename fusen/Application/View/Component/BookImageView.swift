//
//  BookImageView.swift
//  BookImageView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI

struct BookImageView: View {
    let url: URL?
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
        } placeholder: {
            Image.book
                .resizable()
                .foregroundColor(.placeholder)
        }
    }
}

struct BookImageView_Previews: PreviewProvider {
    static var previews: some View {
        BookImageView(url: Book.sample.imageURL)
    }
}

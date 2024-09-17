//
//  SearchBookItemView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Domain
import SwiftUI

struct SearchBookItemView: View {
    let publication: Publication

    var body: some View {
        HStack {
            BookImageView(url: publication.thumbnailURL)
                .frame(width: 48)
            VStack(alignment: .leading, spacing: 0) {
                Text(publication.title)
                    .font(.small)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(.textSecondary)
                Spacer(minLength: 8)
                Text(publication.author)
                    .font(.small)
                    .lineLimit(1)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

struct SearchBookItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookItemView(publication: Publication.sample)
    }
}

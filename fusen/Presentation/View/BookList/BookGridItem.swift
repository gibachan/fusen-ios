//
//  BookGridItem.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/01/03.
//

import Domain
import SwiftUI

struct BookGridItem: View {
    let book: Book
    
    var body: some View {
        BookImageView(url: book.imageURL)
    }
}

struct BookGridItem_Previews: PreviewProvider {
    static var previews: some View {
        BookGridItem(book: Book.sample)
    }
}

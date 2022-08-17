//
//  Publication.swift
//  Publication
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Foundation

struct Publication {
    let title: String
    let author: String
    let thumbnailURL: URL?
}

extension Publication {
    static var sample: Publication {
        .init(title: "仮説思考",
              author: "内田和成",
              thumbnailURL: URL(string: "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/4925/49255555.jpg?_ex=200x200")!)
    }
}

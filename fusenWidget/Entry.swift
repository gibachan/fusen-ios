//
//  Entry.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/06/25.
//

import Domain
import UIKit
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let book: CachedBook?
    let isPreview: Bool
}

extension SimpleEntry {
    func getBookImage() -> UIImage? {
        guard let url = book?.imageURL,
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}

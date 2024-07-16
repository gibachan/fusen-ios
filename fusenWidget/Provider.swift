//
//  Provider.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/06/25.
//

import Data
import WidgetKit

struct Provider: TimelineProvider {
    private let dataSource: UserDefaultsDataSource = UserDefaultsDataSourceImpl()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    book: nil,
                    isPreview: true)
    }

    func getSnapshot(in context: Context,
                     completion: @escaping (SimpleEntry) -> Void) {
        let entry: SimpleEntry
        
        if context.isPreview {
            entry = SimpleEntry(date: Date(),
                                book: nil,
                                isPreview: true)
        } else {
            entry = SimpleEntry(date: Date(),
                                book: dataSource.readingBook,
                                isPreview: false)
        }
        
        completion(entry)
    }
    
    func getTimeline(in context: Context,
                     completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date(),
                                                      book: dataSource.readingBook,
                                                      isPreview: false)],
                                policy: .never)
        completion(timeline)
    }
}

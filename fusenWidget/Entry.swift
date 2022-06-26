//
//  Entry.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/06/25.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let book: CachedBook?
    let configuration: ConfigurationIntent
}

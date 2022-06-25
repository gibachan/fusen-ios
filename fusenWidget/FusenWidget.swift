//
//  FusenWidget.swift
//  fusenWidget
//
//  Created by Tatsuyuki Kobayashi on 2022/06/25.
//

import Intents
import SwiftUI
import WidgetKit

struct FusenWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct FusenWidget: Widget {
    private let kind: String = "fusen-widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
            FusenWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("読書メモ")
        .description("読書中の書籍を表示します")
    }
}

struct FusenWidget_Previews: PreviewProvider {
    static var previews: some View {
        FusenWidgetEntryView(entry: SimpleEntry(date: Date(),
                                                configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

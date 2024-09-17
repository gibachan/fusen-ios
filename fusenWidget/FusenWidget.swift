//
//  FusenWidget.swift
//  fusenWidget
//
//  Created by Tatsuyuki Kobayashi on 2022/06/25.
//

import Domain
import SwiftUI
import WidgetKit

struct FusenWidgetEntryView: View {
    var entry: Provider.Entry

    private let bookWidth: CGFloat = 40
    private let bookHeight: CGFloat = 48

    private var bookPlaceholder: some View {
        Image("App")
            .resizable()
            .frame(width: 48, height: 48)
            .offset(x: -4, y: -4)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 4) {
                if entry.isPreview {
                    bookPlaceholder
                } else {
                    if let bookImage = entry.getBookImage() {
                        Image(uiImage: bookImage)
                            .resizable()
                            .frame(width: bookWidth, height: bookHeight)
                    } else {
                        bookPlaceholder
                    }
                }

                Spacer()

                Text("読書中")
                    .font(.minimal)
                    .foregroundColor(.active)
            }
            .padding(.bottom, 4)

            if entry.isPreview {
                // Preview
                Text("読書中の書籍を表示")
                    .font(.medium)
                    .foregroundColor(.textSecondary)
            } else {
                if let book = entry.book {
                    Text(book.title)
                        .font(.small)
                        .fontWeight(.bold)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Text(book.author)
                        .font(.minimal)
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                } else {
                    // Placeholder
                    Text("書籍が設定されていません")
                        .font(.medium)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .widgetBackground(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
    }
}

@main
struct FusenWidget: Widget {
    private let kind: String = "fusen-widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            FusenWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
        .configurationDisplayName("読書メモ")
        .description("読書中の書籍を表示します")
    }
}

struct FusenWidget_Previews: PreviewProvider {
    private static let entry = SimpleEntry(date: Date(),
                                           book: .init(id: .init(stringLiteral: "1"),
                                                       title: "星の王子さま",
                                                       author: "アントアーヌ・ド・サン・テグジュペリ/河野万里子",
                                                       imageURL: URL(string: "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/2044/9784102122044.jpg?_ex=200x200")!), isPreview: true)
    static var previews: some View {
        FusenWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

private extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

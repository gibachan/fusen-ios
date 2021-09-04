//
//  QuoteText.swift
//  QuoteText
//
//  Created by Tatsuyuki Kobayashi on 2021/09/04.
//

import SwiftUI

struct QuoteText: View {
    let text: String
    var body: some View {
        Text(text)
            .foregroundColor(.textSecondary)
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 8))
            .overlay(
                HStack {
                    Rectangle()
                        .fill(Color.backgroundGray)
                        .frame(width: 6)
                    Spacer()
                }
            )
    }
}

struct QuoteText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            QuoteText(text: "Hello world!\nblah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah ")
                .font(.medium)
                .lineLimit(4)
            Text("hoge hoge")
        }
    }
}

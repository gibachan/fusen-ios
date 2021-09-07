//
//  PlaceholderTextEditor.swift
//  PlaceholderTextEditor
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI

struct PlaceholderTextEditor: View {
    let placeholder: String
    @Binding var text: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.placeholder)
                    .padding(EdgeInsets(top: 9, leading: 4, bottom: 0, trailing: 0))
            }
            // ZStack is required for dynamic height of TextEditor
            // ref: https://stackoverflow.com/questions/62620613/dynamic-row-hight-containing-texteditor-inside-a-list-in-swiftui
            ZStack {
                TextEditor(text: $text)
                Text(text).opacity(0).padding(.all, 8)
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear {
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct PlaceholderTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderTextEditor(placeholder: "placeholder", text: Binding<String>.constant(""))
    }
}

//
//  ReadingBookDescriptionView.swift
//  ReadingBookDescriptionView
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import SwiftUI

struct ReadingBookDescriptionView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(alignment: .center, spacing: 16) {
                Text("書籍を「読書中」に設定すると、ホーム画面から手軽にメモを追加できるようになります。\n\nアプリのウィジェットに書籍が表示されます。")
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                
                Text("閉じる")
                    .font(.medium)
                    .foregroundColor(.active)
            }
            .frame(maxWidth: 240)
            .padding(24)
            .backgroundColor(.white)
            .border(Color.border, width: 1)
        }
    }
}

struct ReadingBookDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookDescriptionView()
    }
}

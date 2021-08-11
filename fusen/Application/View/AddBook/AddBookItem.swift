//
//  AddBookItem.swift
//  AddBookItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import SwiftUI

struct AddBookItem: View {
    let type: AddBookType
    var body: some View {
        HStack(spacing: 8) {
            type.icon
                .resizable()
                .frame(width: 24, height: 24)
            Text(type.title)
                .font(.medium)
        }
        .foregroundColor(.textPrimary)
    }
}

struct AddBookItem_Previews: PreviewProvider {
    static var previews: some View {
        AddBookItem(type: .camera)
    }
}

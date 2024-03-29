//
//  AddBookMenuItem.swift
//  AddBookMenuItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import SwiftUI

struct AddBookMenuItem: View {
    let type: AddBookMenuType
    var body: some View {
        HStack(spacing: 8) {
            type.icon
                .resizable()
                .frame(width: 24, height: 22)
            Text(type.title)
                .font(.medium)
        }
        .padding(.vertical, 8)
        .foregroundColor(.active)
    }
}

struct AddBookMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        AddBookMenuItem(type: .camera)
    }
}

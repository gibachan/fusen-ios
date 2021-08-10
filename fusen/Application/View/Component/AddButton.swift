//
//  AddButton.swift
//  AddButton
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

struct AddButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image.add
                .resizable()
                .foregroundColor(.primary)
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton {
            print("Add")
        }
        .frame(width: 24, height: 24)
    }
}

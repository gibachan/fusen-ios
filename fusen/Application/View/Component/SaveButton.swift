//
//  SaveButton.swift
//  SaveButton
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct SaveButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Text("保存")
        }
    }
}

struct SaveButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveButton {
            print("save")
        }
    }
}

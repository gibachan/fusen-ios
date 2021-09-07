//
//  CancelButton.swift
//  CancelButton
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import SwiftUI

struct CancelButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Text("キャンセル")
        }
    }
}

struct CancelButton_Previews: PreviewProvider {
    static var previews: some View {
        CancelButton {
            print("cancel")
        }
    }
}

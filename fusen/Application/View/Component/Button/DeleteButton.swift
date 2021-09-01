//
//  DeleteButton.swift
//  DeleteButton
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct DeleteButton: View {
    let action: () -> Void
    var body: some View {
        Button(role: .destructive) {
            action()
        } label: {
            Text("削除")
                .foregroundColor(.red)
        }
    }    
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton {
            print("delete")
        }
    }
}

//
//  DisplyStyleButton.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/01/03.
//

import SwiftUI

struct DisplyStyleButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image.displayStyle
                .resizable()
        }
    }
}

struct DisplyStyleButton_Previews: PreviewProvider {
    static var previews: some View {
        DisplyStyleButton {}
    }
}

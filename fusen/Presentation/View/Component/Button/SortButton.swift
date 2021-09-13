//
//  SortButton.swift
//  SortButton
//
//  Created by Tatsuyuki Kobayashi on 2021/09/04.
//

import SwiftUI

struct SortButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image.sort
                .resizable()
        }
    }
}

struct SortButton_Previews: PreviewProvider {
    static var previews: some View {
        SortButton {}
    }
}

//
//  AddBookIcon.swift
//  AddBookIcon
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import SwiftUI

struct AddBookIcon: View {
    var body: some View {
        Image.book
            .resizable()
            .frame(width: 20, height: 24)
            .overlay {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
                    .offset(x: 8, y: -8)
            }
            .overlay {
                Image.addCircle
                    .resizable()
                    .frame(width: 12, height: 12)
                    .background(Color.white)
                    .offset(x: 8, y: -8)
            }
            .foregroundColor(.active)
    }
}

struct AddBookIcon_Previews: PreviewProvider {
    static var previews: some View {
        AddBookIcon()
    }
}

//
//  ReadingMark.swift
//  ReadingMark
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import SwiftUI

struct ReadingMark: View {
    let isReading: Bool
    var body: some View {
        if isReading {
            Text("読書中")
                .font(.small)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.active))
        } else {
            Text("読書中")
                .font(.small)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Capsule().stroke(Color.inactive, lineWidth: 1))
                .background(Capsule().fill(Color.backgroundLightGray))
        }
    }
}

struct ReadingMark_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ReadingMark(isReading: false)
            ReadingMark(isReading: true)
        }
    }
}

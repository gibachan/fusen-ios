//
//  ControlToolbar.swift
//  ControlToolbar
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct ControlToolbar: View {
    private let text: String?
    private let trailingImage: Image?
    private let trailingAction: (() -> Void)?
    
    init(
        text: String? = nil,
        trailingImage: Image? = nil,
        trailingAction: (() -> Void)? = nil
    ) {
        self.text = text
        self.trailingImage = trailingImage
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if let text = text {
                Text(text)
                    .font(.small)
                    .foregroundColor(.textSecondary)
            }
            HStack(alignment: .center) {
                Spacer()
                if let trailingImage = trailingImage {
                    trailingImage
                        .foregroundColor(.primary)
                        .frame(width: 36, height: 36)
                        .onTapGesture {
                            trailingAction?()
                        }
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(Color.backgroundGray)
    }
}

struct ControlToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ControlToolbar(text: "123冊の書籍")
    }
}

//
//  ControlToolbar.swift
//  ControlToolbar
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct ControlToolbar: View {
    typealias Action = () -> Void
    private let text: String?
    private let leadingImage: Image?
    private let leadingAction: Action?
    private let trailingImage: Image?
    private let trailingAction: Action?

    init(
        text: String? = nil,
        leadingImage: Image? = nil,
        leadingAction: Action? = nil,
        trailingImage: Image? = nil,
        trailingAction: Action? = nil
    ) {
        self.text = text
        self.leadingImage = leadingImage
        self.leadingAction = leadingAction
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
                if let leadingImage = leadingImage {
                    leadingImage
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.active)
                        .onTapGesture {
                            leadingAction?()
                        }
                }
                Spacer()
                if let trailingImage = trailingImage {
                    trailingImage
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.active)
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

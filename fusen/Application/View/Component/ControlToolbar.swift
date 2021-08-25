//
//  ControlToolbar.swift
//  ControlToolbar
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct ControlToolbar: View {
    typealias Action = () -> Void
    private let leadingImage: Image?
    private let leadingAction: Action?
    private let trailingImage: Image?
    private let trailingAction: Action?

    init(
        leadingImage: Image? = nil,
        leadingAction: Action? = nil,
        trailingImage: Image? = nil,
        trailingAction: Action? = nil
    ) {
        self.leadingImage = leadingImage
        self.leadingAction = leadingAction
        self.trailingImage = trailingImage
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if let leadingImage = leadingImage {
                leadingImage
                    .resizable()
                    .frame(width: 28, height: 24)
                    .foregroundColor(.active)
                    .onTapGesture {
                        leadingAction?()
                    }
            }
            Spacer()
            if let trailingImage = trailingImage {
                trailingImage
                    .resizable()
                    .frame(width: 28, height: 24)
                    .foregroundColor(.active)
                    .onTapGesture {
                        trailingAction?()
                    }
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 48)
        .background(Color.white)
        .border(Color.backgroundGray, width: 0.5)
    }
}

struct ControlToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ControlToolbar()
    }
}

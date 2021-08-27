//
//  ControlToolbar.swift
//  ControlToolbar
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct ControlToolbar<L: View, R: View>: View {
    typealias Action = () -> Void
    private let leadingView: L
    private let leadingAction: Action?
    private let trailingView: R
    private let trailingAction: Action?

    init(
        @ViewBuilder leadingView: () -> L,
        leadingAction: Action? = nil,
        @ViewBuilder trailingView: () -> R,
        trailingAction: Action? = nil
    ) {
        self.leadingView = leadingView()
        self.leadingAction = leadingAction
        self.trailingView = trailingView()
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        HStack(alignment: .center) {
            leadingView
                .onTapGesture {
                    leadingAction?()
                }
            Spacer()
            trailingView
                .onTapGesture {
                    trailingAction?()
                }
        }
        .padding(.horizontal, 24)
        .frame(height: 48)
        .border(Color.backgroundGray, width: 0.5)
    }
}

struct TrailingControlToolbar<R: View>: View {
    typealias Action = () -> Void
    private let trailingView: R
    private let trailingAction: Action?

    init(
        @ViewBuilder trailingView: () -> R,
        trailingAction: Action? = nil
    ) {
        self.trailingView = trailingView()
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        ControlToolbar(
            leadingView: { EmptyView() },
            leadingAction: nil,
            trailingView: { trailingView },
            trailingAction: trailingAction
        )
    }
}

struct ControlToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ControlToolbar(leadingView: { EmptyView() }, leadingAction: nil, trailingView: { EmptyView() }, trailingAction: nil)
    }
}

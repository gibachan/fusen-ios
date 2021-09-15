//
//  ViewExtension.swift
//  ViewExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import SwiftUI

extension View {
    func backgroundColor(_ color: Color) -> some View {
        self.background(color)
    }
    
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        background(NavigationLink(isActive: isActive, destination: destination, label: { EmptyView() }))
    }
    
    func debug(_ block: () -> Void) -> some View {
        block()
        return self
    }
}

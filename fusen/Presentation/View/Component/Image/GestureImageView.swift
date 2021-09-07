//
//  GestureImageView.swift
//  GestureImageView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import SwiftUI

struct GestureImageView: View {
    @State var offset: CGSize = .zero
    @State var initialOffset: CGSize = .zero
    @State var scale: CGFloat = 1.0
    @State var initialScale: CGFloat = 1.0

    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .offset(offset)
            .scaleEffect(scale)
            .gesture(SimultaneousGesture(
                MagnificationGesture()
                    .onChanged { scale = $0 * initialScale }
                    .onEnded { _ in initialScale = scale },
                DragGesture()
                    .onChanged { offset = CGSize(width: initialOffset.width + $0.translation.width, height: initialOffset.height + $0.translation.height) }
                    .onEnded { _ in initialOffset = offset }
            )
            )
    }
}

struct GestureImageView_Previews: PreviewProvider {
    static var previews: some View {
        GestureImageView(image: Image.book)
    }
}

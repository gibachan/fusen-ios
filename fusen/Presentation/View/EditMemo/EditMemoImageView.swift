//
//  MemoImageView.swift
//  MemoImageView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct EditMemoImageView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var offset: CGSize = .zero
    @State var initialOffset: CGSize = .zero
    @State var scale: CGFloat = 1.0
    @State var initialScale: CGFloat = 1.0
    
    let url: URL?
    
    var body: some View {
        ZStack {
            Color.black
            MemoImageView(url: url)
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
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarTitle("添付画像", displayMode: .inline)
        .navigationBarItems(
            leading: CancelButton { dismiss() }
        )
    }
}

struct EditMemoImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditMemoImageView(url: Memo.sample.imageURLs.first!)
        }
    }
}

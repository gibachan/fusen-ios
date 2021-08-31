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
    
    let url: URL
    let deleteAction: (() -> Void)
    
    var body: some View {
        VStack {
            AsyncImage(url: url) { image in
                GestureImageView(image: image)
            } placeholder: {
                Color.black
            }
        }
        .backgroundColor(.black)
        .navigationBarTitle("画像", displayMode: .inline)
        .navigationBarItems(
            leading: CancelButton { dismiss() },
            trailing: DeleteButton {
                deleteAction()
                dismiss()
            }
        )
    }
}

struct EditMemoImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditMemoImageView(url: Memo.sample.imageURLs.first!) {
                print("delete")
            }
        }
    }
}

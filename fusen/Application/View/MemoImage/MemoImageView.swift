//
//  MemoImageView.swift
//  MemoImageView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct MemoImageView: View {
    @Environment(\.dismiss) private var dismiss
    let image: UIImage
    let deleteAction: () -> Void
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .padding()
        }
        .background(Color.black)
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

struct MemoImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MemoImageView(image: UIImage.strokedCheckmark) {
                print("delete")
            }
        }
    }
}

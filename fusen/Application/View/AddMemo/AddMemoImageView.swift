//
//  AddMemoImageView.swift
//  AddMemoImageView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import SwiftUI

struct AddMemoImageView: View {
    @Environment(\.dismiss) private var dismiss
    let image: UIImage
    let deleteAction: (() -> Void)
    
    var body: some View {
        VStack {
            GestureImageView(image: Image(uiImage: image))
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

struct AddMemoImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemoImageView(image: UIImage.strokedCheckmark) {
            print("delete")
        }
    }
}

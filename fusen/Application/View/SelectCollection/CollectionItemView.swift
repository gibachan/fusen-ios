//
//  CollectionItemView.swift
//  CollectionItemView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import SwiftUI

struct CollectionItemView: View {
    let collection: Collection
    let isSelected: Bool
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if isSelected {
                Image.checkmark
                    .resizable()
                    .foregroundColor(.primary)
                    .frame(width: 20, height: 20)
            } else {
                Color.clear
                    .frame(width: 20, height: 20)
            }
            Image.collection
                .resizable()
                .frame(width: 20, height: 18)
                .foregroundColor(Color(rgb: collection.color))
            Text(collection.name)
                .font(.medium)
                .foregroundColor(.textPrimary)
            Spacer()
        }
    }
}

struct CollectionItemView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionItemView(collection: Collection.sample, isSelected: true)
    }
}

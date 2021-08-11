//
//  AddBookView.swift
//  AddBookView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import SwiftUI

struct AddBookView: View {
    @StateObject var viewModel = AddBookViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Spacer(minLength: 40)
                ForEach(AddBookType.allCases) {
                    AddBookItem(type: $0)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("書籍を追加", displayMode: .inline)
            .navigationBarItems(leading: CancelButton { dismiss() })
        }
    }
}

enum AddBookType: Identifiable, CaseIterable {
    case camera
    case manual

    var id: String { title }

    var title: String {
        switch self {
        case .camera: return "バーコードを読み取る"
        case .manual: return "マニュアル入力する"
        }
    }

    var icon: Image {
        switch self {
        case .camera: return .camera
        case .manual: return .manual
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

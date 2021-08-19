//
//  AddBookView.swift
//  AddBookView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddBookViewModel()
    @State private var isScanBarcodePresented = false
    @State private var isManualInputPresented = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 32) {
                Spacer().frame(height: 32)
                Button {
                    isScanBarcodePresented = true
                } label: {
                    AddBookItem(type: AddBookType.camera)
                }
                Button {
                    isManualInputPresented = true
                } label: {
                    AddBookItem(type: AddBookType.manual)
                }
                Spacer()
            }
            .sheet(isPresented: $isScanBarcodePresented, onDismiss: {
                print("dimiss")
            }, content: {
                ScanBarcodeView()
            })
            .sheet(isPresented: $isManualInputPresented, onDismiss: {
                print("dimiss")
            }, content: {
                Text("Not yet implemented")
            })
            .navigationBarTitle("書籍を追加", displayMode: .inline)
            // sheet表示する場合にキャンセルボタンを表示する
//            .navigationBarItems(leading: CancelButton { dismiss() })
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

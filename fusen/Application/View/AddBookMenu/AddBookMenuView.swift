//
//  AddBookMenuView.swift
//  AddBookMenuView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import SwiftUI

struct AddBookMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isScanBarcodePresented = false
    @State private var isManualInputPresented = false
    private let collection: Collection?
    
    init(in collection: Collection? = nil) {
        self.collection = collection
    }
    
    var body: some View {
        NavigationView {
            List {
                Button {
                    isScanBarcodePresented = true
                } label: {
                    AddBookMenuItem(type: AddBookMenuType.camera)
                }
                Button {
                    isManualInputPresented = true
                } label: {
                    AddBookMenuItem(type: AddBookMenuType.manual)
                }
            }
            .fullScreenCover(isPresented: $isScanBarcodePresented, onDismiss: {
                print("dimiss")
            }, content: {
                NavigationView {
                    ScanBarcodeView(in: collection)
                }
            })
            .sheet(isPresented: $isManualInputPresented, onDismiss: {
                print("dimiss")
            }, content: {
                NavigationView {
                    AddBookView(in: collection)
                }
            })
            .navigationBarTitle("書籍を追加", displayMode: .inline)
            .navigationBarItems(leading: CancelButton { dismiss() })
        }
    }
}

enum AddBookMenuType: Identifiable, CaseIterable {
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

struct AddBookMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookMenuView()
    }
}

//
//  ScanBarcodeView.swift
//  ScanBarcodeView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Domain
import SwiftUI

struct ScanBarcodeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ScanBarcodeViewModel()
    @State private var isSuggestPresented = false
    private let collection: Domain.Collection?
    
    init(in collection: Domain.Collection? = nil) {
        self.collection = collection
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            BarcodeCameraView { code in
                Task {
                    await viewModel.onBarcodeScanned(code: code)
                }
            }
            
            Text("カメラでバーコードを読み取ってください")
                .font(.medium)
                .foregroundColor(.white)
                .padding(.top, 32)
            
            scannedBook
                .padding()
        }
        .backgroundColor(.black)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: CancelButton { dismiss() },
                            trailing: torchButton)
        .alert(isPresented: $isSuggestPresented) {
            Alert(
                title: Text("書籍を追加"),
                message: Text("「\(viewModel.suggestedBook?.title ?? "")」が見つかりました。書籍を追加しますか？"),
                primaryButton: .cancel(Text("キャンセル"),
                                       action: {
                                           Task {
                                               await viewModel.onDeclinSuggestedBook()
                                           }
                                       }),
                secondaryButton: .default(Text("追加").fontWeight(.bold), action: {
                    Task {
                        await viewModel.onAcceptSuggestedBook(collection: collection)
                    }
                })
            )
        }
        .onReceive(viewModel.$suggestedBook) {
            isSuggestPresented = $0 != nil
        }
    }
    
    private var scannedBook: some View {
        VStack(alignment: .center) {
            Spacer()
            if let scannedBook = viewModel.scannedBook {
                withAnimation {
                    Text("「\(scannedBook.title)」を追加しました。")
                        .font(.small)
                        .foregroundColor(.white)
                        .padding()
                        .backgroundColor(.backgroundGray)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

extension ScanBarcodeView {
    private var torchButton: some View {
        Button(action: {
            viewModel.onTorchToggled()
        }, label: {
            if viewModel.isTorchOn {
                Image.cameraTorchOn
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.yellow)
            } else {
                Image.cameraTorchOff
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
        })
    }
}

struct ScanBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        ScanBarcodeView()
    }
}

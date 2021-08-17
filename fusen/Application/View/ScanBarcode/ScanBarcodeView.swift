//
//  ScanBarcodeView.swift
//  ScanBarcodeView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import SwiftUI

struct ScanBarcodeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ScanBarcodeViewModel()
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                BarcodeCameraView { code in
                    Task {
                       await viewModel.onBarcodeScanned(code: code)
                    }
                }
                
                VStack(alignment: .center, spacing: 0) {
                    Text("カメラでバーコードを読み取ってください")
                        .font(.medium)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 24, leading: 0, bottom: 40, trailing: 0))
                    Rectangle()
                        .stroke(lineWidth: 2)
                        .fill(.white)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0))
                }
                .padding()
            }
            .background(Color.black)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: CancelButton { dismiss() },
                                trailing: torchButton)
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

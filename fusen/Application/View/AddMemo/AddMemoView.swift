//
//  AddMemoView.swift
//  AddMemoView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct AddMemoView: View {
    @StateObject private var viewModel = AddMemoViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddMemoView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemoView()
    }
}

//
//  BookShelfTabView.swift
//  BookShelfTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

struct BookShelfTabView: View {
    @StateObject var viewModel = BookShelfTabViewModel()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    ForEach(0..<100, id: \.self) {
                        Text("Row \($0)")
                    }
                }
                HStack(alignment: .center) {
                    Spacer()
                    Text(viewModel.textCountText)
                        .font(.small)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    AddButton {
                        print("Add")
                    }
                    .frame(width: 24, height: 24)
                    Spacer().frame(width: 16)
                }
                .frame(height: 48)
                .background(Color.backgroundGray)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("本棚")
        }
        .onAppear { viewModel.onAppear() }
    }
}

struct BookShelfTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTabView()
    }
}

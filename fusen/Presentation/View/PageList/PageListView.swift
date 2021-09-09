//
//  PageListView.swift
//  PageListView
//
//  Created by Tatsuyuki Kobayashi on 2021/09/09.
//

import SwiftUI

struct PageListView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var page: Int
    let initialPage: Int
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(0..<999) { page in
                    ZStack(alignment: .leading) {
                        Color.white // to be able to tap empty area
                        Text("\(page)")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                    }
                    .id(page)
                    .onTapGesture {
                        self.page = page
                        dismiss()
                    }
                }
            }
            .onAppear {
                guard initialPage > 0 else { return }
                DispatchQueue.main.async {
                    withAnimation {
                        proxy.scrollTo(initialPage, anchor: .top)
                    }
                }
            }
        }
        .navigationBarTitle("ページ")
    }
}

struct PageListView_Previews: PreviewProvider {
    static var previews: some View {
        PageListView(page: Binding<Int>.constant(0), initialPage: 0)
    }
}

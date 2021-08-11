//
//  BookShelfTabViewModel.swift
//  BookShelfTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import Foundation

final class BookShelfTabViewModel: ObservableObject {
    @Published var textCountText = ""

    func onAppear() {
        textCountText = "xx冊の書籍"
    }
}

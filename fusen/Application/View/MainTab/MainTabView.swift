//
//  MainTabView.swift
//  MainTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = MainTabViewModel()
    var body: some View {
        TabView {
            BookShelfTabView()
                .tabItem {
                    Image.bookShelf
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

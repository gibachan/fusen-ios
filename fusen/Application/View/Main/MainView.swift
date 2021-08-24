//
//  MainView.swift
//  MainView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var isTutorialPresented = false
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Image.home
                    Text("ホーム")
                }
            BookShelfTabView()
                .tabItem {
                    Image.bookShelf
                    Text("本棚")
                }
            SettingTabView()
                .tabItem {
                    Image.setting
                    Text("設定")
                }
        }
        .accentColor(.active)
        .fullScreenCover(isPresented: $isTutorialPresented) {
        } content: {
            TutorialView()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onReceive(viewModel.$showTutorial) {
            isTutorialPresented = $0
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

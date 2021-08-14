//
//  MainView.swift
//  MainView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State var isTutorialPresented = false
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Image.home
                }
            BookShelfTabView()
                .tabItem {
                    Image.bookShelf
                }
        }
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

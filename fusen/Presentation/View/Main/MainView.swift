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
    @State private var isMaintenancePresented = false
    @State private var toastText = ""
    @State private var isToastPresented = false
    @State private var isReadingBookDescriptionPresented = false
    @State private var selectedTab = 0
    private var tabSelection: Binding<Int> { Binding(
        get: { self.selectedTab },
        set: {
            if self.selectedTab == $0 {
                switch selectedTab {
                case 0:
                    NotificationCenter.default.postHomePopToRoot()
                case 1:
                    NotificationCenter.default.postBookShelfPopToRoot()
                default:
                    break
                }
            } else {
                self.selectedTab = $0
            }
        }
    )}

    var body: some View {
        ZStack {
            TabView(selection: tabSelection) {
                NavigationView {
                    HomeTabView()
                }
                .tabItem {
                    Image.home
                    Text("ホーム")
                }
                .tag(0)

                NavigationView {
                    BookShelfTabView()
                }
                .tabItem {
                    Image.bookShelf
                    Text("本棚")
                }
                .tag(1)

                NavigationStack {
                    SearchTabView()
                }
                .tabItem {
                    Image.search
                    Text("検索")
                }
                .tag(2)

                NavigationView {
                    SettingTabView()
                }
                .tabItem {
                    Image.setting
                    Text("設定")
                }
                .tag(3)
            }
            .zIndex(0)
            
            if isReadingBookDescriptionPresented {
                ReadingBookDescriptionView()
                    .onTapGesture {
                        withAnimation {
                            isReadingBookDescriptionPresented = false
                        }
                    }
            }
            
            if isToastPresented {
                ToastView(text: toastText, type: .error)
                    .zIndex(1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isToastPresented = false
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            isToastPresented = false
                        }
                    }
            }
        }
        .accentColor(.active)
        .fullScreenCover(isPresented: $isTutorialPresented) {
        } content: {
            TutorialView()
        }
        .fullScreenCover(isPresented: $isMaintenancePresented) {
        } content: {
            MaintenanceView()
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$showTutorial) {
            isTutorialPresented = $0 && !viewModel.isMaintaining
        }
        .onReceive(viewModel.$isMaintaining) {
            isMaintenancePresented = $0
        }
        .onReceive(NotificationCenter.default.errorPublisher()) { notification in
            toastText = notification.errorMessage?.string ?? ""
            withAnimation {
                isToastPresented = true
            }
        }
        .onReceive(NotificationCenter.default.showReadingBookDescriptionPublisher()) { _ in
            withAnimation {
                isReadingBookDescriptionPresented = true
            }
        }
        .onReceive(NotificationCenter.default.logOutPublisher()) { _ in
            withAnimation {
                isTutorialPresented = true
            }
        }
        .onOpenURL { url in
            Task {
                await viewModel.onDeepLink(url: url)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

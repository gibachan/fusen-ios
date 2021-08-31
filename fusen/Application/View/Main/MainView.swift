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
    
    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    HomeTabView()
                }
                .tabItem {
                    Image.home
                    Text("ホーム")
                }
                
                NavigationView {
                    BookShelfTabView()
                }
                .tabItem {
                    Image.bookShelf
                    Text("本棚")
                }
                
                NavigationView {
                    SettingTabView()
                }
                .tabItem {
                    Image.setting
                    Text("設定")
                }
            }
            .zIndex(0)
            
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
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

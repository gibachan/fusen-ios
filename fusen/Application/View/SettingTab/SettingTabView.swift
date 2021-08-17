//
//  SettingTabView.swift
//  SettingTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct SettingTabView: View {
    @StateObject var viewModel = SettingTabViewModel()
    var body: some View {
        NavigationView {
            List {
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("設定")
        }
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}

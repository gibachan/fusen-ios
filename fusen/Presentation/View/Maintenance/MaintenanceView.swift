//
//  MaintenanceView.swift
//  MaintenanceView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import SwiftUI

struct MaintenanceView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("App")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.placeholder)
                .opacity(0.4)
                .frame(width: 112, height: 112)
            Text("現在メンテナンス中です。しばらくお待ちください。")
                .font(.medium)
                .foregroundColor(.textPrimary)
        }
        .padding(40)
    }
}

struct MaintenanceView_Previews: PreviewProvider {
    static var previews: some View {
        MaintenanceView()
    }
}

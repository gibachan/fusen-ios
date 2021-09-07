//
//  ToastView.swift
//  ToastView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import SwiftUI

struct ToastView: View {
    let text: String
    let type: ToastType
    
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.small)
                .foregroundColor(type.foregroundColor)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(type.backgroundColor.opacity(0.9))
                .clipShape(Capsule())
            Spacer().frame(height: 72)
        }
        .frame(width: UIScreen.main.bounds.width * 0.94)
    }
    
    enum ToastType {
        case info
        case warning
        case error
        
        var foregroundColor: Color {
            switch self {
            case .info: return .textPrimary
            case .warning: return .textPrimary
            case .error: return .white
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .info: return .info
            case .warning: return .warning
            case .error: return .error
            }
        }
        
        var image: Image {
            switch self {
            case .info: return .info
            case .warning: return .warning
            case .error: return .error
            }
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(text: "Unexpected error occured!", type: .error)
    }
}

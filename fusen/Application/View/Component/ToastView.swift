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
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                type.image
                Text(text)
            }
            .font(.headline)
            .foregroundColor(type.foregroundColor)
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
            .background(type.backgroundColor)
            .clipShape(Capsule())
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.show = false
                }
            }
        }
        .onTapGesture {
            withAnimation {
                self.show = false
            }
        }
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

struct ToastOverlay<T: View>: ViewModifier {
    @Binding var show: Bool
    let toast: T
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                toast
            }
        }
    }
}

extension View {
    func toast(text: String, type: ToastView.ToastType, isActive: Binding<Bool>) -> some View {
        self.modifier(ToastOverlay(show: isActive, toast: ToastView(text: text, type: type, show: isActive)))
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(text: "Unexpected error occured!", type: .error, show: Binding<Bool>.constant(true))
    }
}

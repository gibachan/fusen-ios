//
//  SectionHeaderText.swift
//  SectionHeaderText
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct SectionHeaderText: View {
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.medium)
            .fontWeight(.bold)
    }}

struct SectionHeaderText_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderText("最近追加した書籍")
    }
}

//
//  ActionView.swift
//  fusenActionExtension
//
//  Created by Tatsuyuki Kobayashi on 2022/08/15.
//

import Foundation

protocol ActionView: AnyObject {
    func showDescription()
    func showInput()
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func setQuote(_ text: String)
    func close()
    func openApp()
}

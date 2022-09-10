//
//  ActionView.swift
//  fusenActionExtension
//
//  Created by Tatsuyuki Kobayashi on 2022/08/15.
//

import UIKit

protocol ActionView: AnyObject {
    func showDescription()
    func showInput()
    func showBook(title: String, image: UIImage)
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func setQuote(_ text: String)
    func close()
    func openApp()
}

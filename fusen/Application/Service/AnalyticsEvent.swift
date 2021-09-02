//
//  AnalyticsEvent.swift
//  AnalyticsEvent
//
//  Created by Tatsuyuki Kobayashi on 2021/09/02.
//

import Foundation

enum AnalyticsEvent {
    case addBookByManual
    case addBookByBarcode
    case scanBarcodeError(code: String)
}

extension AnalyticsEvent {
    var name: String {
        switch self {
        case .addBookByManual:
            return "add_book_by_manual"
        case .addBookByBarcode:
            return "add_book_by_barcode"
        case .scanBarcodeError:
            return "scan_barcode_error"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .addBookByManual:
            return [:]
        case .addBookByBarcode:
            return [:]
        case let .scanBarcodeError(code: code):
            return [
                "barcode": code
            ]
        }
    }
}

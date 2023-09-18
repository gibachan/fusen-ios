//
//  AnalyticsEvent.swift
//  AnalyticsEvent
//
//  Created by Tatsuyuki Kobayashi on 2021/09/02.
//

import Foundation

public enum AnalyticsEvent: Equatable {
    case addBookByManual
    case addBookByBarcode
    case scanBarcodeByRakutenError(code: String)
    case scanBarcodeByGoogleError(code: String)
}

public extension AnalyticsEvent {
    var name: String {
        switch self {
        case .addBookByManual:
            return "add_book_by_manual"
        case .addBookByBarcode:
            return "add_book_by_barcode"
        case .scanBarcodeByRakutenError:
            return "scan_barcode_by_rakuten_error"
        case .scanBarcodeByGoogleError:
            return "scan_barcode_by_google_error"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .addBookByManual:
            return [:]
        case .addBookByBarcode:
            return [:]
        case let .scanBarcodeByRakutenError(code: code):
            return [
                "barcode": code
            ]
        case let .scanBarcodeByGoogleError(code: code):
            return [
                "barcode": code
            ]
        }
    }
}

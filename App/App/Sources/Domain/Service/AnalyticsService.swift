//
//  AnalyticsService.swift
//  AnalyticsService
//
//  Created by Tatsuyuki Kobayashi on 2021/09/02.
//

import Foundation

public protocol AnalyticsServiceProtocol {
    func log(event: AnalyticsEvent)
}

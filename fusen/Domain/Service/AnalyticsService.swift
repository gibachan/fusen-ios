//
//  AnalyticsService.swift
//  AnalyticsService
//
//  Created by Tatsuyuki Kobayashi on 2021/09/02.
//

import Foundation
import FirebaseAnalytics

protocol AnalyticsServiceProtocol {
    func log(event: AnalyticsEvent)
}

final class AnalyticsService: AnalyticsServiceProtocol {
    static let shared: AnalyticsServiceProtocol = AnalyticsService()
    
    private init() {}
    
    func log(event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}

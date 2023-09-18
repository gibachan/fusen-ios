//
//  AnalyticsService.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/09/18.
//

import Domain
import FirebaseAnalytics
import Foundation

final class AnalyticsService: AnalyticsServiceProtocol {
    static let shared: AnalyticsServiceProtocol = AnalyticsService()

    private init() {}

    func log(event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}

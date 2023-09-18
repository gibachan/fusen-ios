//
//  MockSearchPublicationsByTitleUseCase.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Foundation
import Domain
@testable import fusen

final class MockSearchPublicationsByTitleUseCase: SearchPublicationsByTitleUseCase {
    private let success: [Publication]?
    private let failure: SearchPublicationsByTitleUseCaseError?
    
    init(success: [Publication]) {
        self.success = success
        self.failure = nil
    }
    
    init(failure: SearchPublicationsByTitleUseCaseError) {
        self.success = nil
        self.failure = failure
    }
    
    func invoke(withTitle title: String) async throws -> [Publication] {
        if let success = success {
            return success
        } else {
            throw failure!
        }
    }
}

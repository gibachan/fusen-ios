//
//  MockAddBookByPublicationUseCase.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Foundation
@testable import fusen

final class MockAddBookByPublicationUseCase: AddBookByPublicationUseCase {
    private let success: ID<Book>?
    private let failure: AddBookByPublicationUseCaseError?
    
    init(success: ID<Book>?) {
        self.success = success
        self.failure = nil
    }
    
    init(failure: AddBookByPublicationUseCaseError) {
        self.success = nil
        self.failure = failure
    }
    
    func invoke(publication: Publication, collection: Collection?) async throws -> ID<Book> {
        if let success = success {
            return success
        } else {
            throw failure!
        }
    }
}

//
//  AddCollectionUseCaseTests.swift
//  AddCollectionUseCaseTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/08.
//

import Domain
import XCTest

class AddCollectionUseCaseTests: XCTestCase {
    func testAddCollection() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let collectionRepository = MockCollectionRepository(getResult: .success(Array(repeating: Collection.sample, count: Collection.countLimit - 1)))
        let useCase = AddCollectionUseCaseImpl(accountService: accountService, collectionRepository: collectionRepository)

        do {
            let id = try await useCase.invoke(name: "hoge", color: RGB(red: 0, green: 0, blue: 0))
            XCTAssertEqual(id.value, "123")
        } catch {
            XCTFail("Not Supposed to be reached: \(error.localizedDescription)")
        }
    }
    func testThrowOverLimitException() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let collectionRepository = MockCollectionRepository(getResult: .success(Array(repeating: Collection.sample, count: Collection.countLimit)))
        let useCase = AddCollectionUseCaseImpl(accountService: accountService, collectionRepository: collectionRepository)

        do {
            _ = try await useCase.invoke(name: "hoge", color: RGB(red: 0, green: 0, blue: 0))
            XCTFail("Not Supposed to be reached")
        } catch {
            switch error {
            case AddCollectionUseCaseError.countOver:
                break
            default:
                XCTFail("Not Supposed to be reached: \(error.localizedDescription)")
            }
        }
    }
}

private class MockCollectionRepository: CollectionRepository {
    typealias GetResult = Result<[Collection], Error>
    typealias AddResult = Result<ID<Collection>, Error>
    typealias DeleteResult = Result<Void, Error>

    private let getResult: GetResult
    private let addResult: AddResult
    private let deleteResult: DeleteResult

    init(
        getResult: GetResult = .success([]),
        addResult: AddResult = .success(.init(stringLiteral: "123")),
        deleteResult: DeleteResult = .success(())
    ) {
        self.getResult = getResult
        self.addResult = addResult
        self.deleteResult = deleteResult
    }

    func getlCollections(for user: User) async throws -> [Collection] {
        switch getResult {
        case let .success(collections):
            return collections
        case let .failure(error):
            throw error
        }
    }

    func addCollection(name: String, color: RGB, for user: User) async throws -> ID<Collection> {
        switch addResult {
        case let .success(id):
            return id
        case let .failure(error):
            throw error
        }
    }

    func delete(collection: Collection, for user: User) async throws {
        switch deleteResult {
        case .success:
            break
        case let .failure(error):
            throw error
        }
    }
}

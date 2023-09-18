//
//  SearchAPIKeyRepositoryImpl.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/26.
//

import Domain
import FirebaseFunctions
import Foundation

final class SearchAPIKeyRepositoryImpl: SearchAPIKeyRepository {
    private let dataSource: UserDefaultsDataSource
    private lazy var functions = Functions.functions(region: "asia-northeast1")

    init(dataSource: UserDefaultsDataSource = UserDefaultsDataSourceImpl()) {
        self.dataSource = dataSource
    }
    
    func get(for user: User) async throws -> SearchAPI.Key {
        if let key = dataSource.searchAPIKey {
            return SearchAPI.Key(rawValue: key)
        }

        do {
            let result = try await functions.httpsCallable("generateSearchKey").call()
            if let key = result.data as? String {
                dataSource.searchAPIKey = key
                return SearchAPI.Key(rawValue: key)
            }
            throw SearchAPIKeyRepositoryError.notFound
        } catch {
            throw SearchAPIKeyRepositoryError.badNetwork
        }
    }

    func clear() {
        dataSource.searchAPIKey = nil
    }
}

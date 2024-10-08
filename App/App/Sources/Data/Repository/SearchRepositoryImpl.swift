//
//  SearchRepositoryImpl.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/26.
//

import AlgoliaSearchClient
import Domain
import Foundation

public final class SearchRepositoryImpl: SearchRepository {
    public init() {}

    public func memos(
        withAPIKey key: SearchAPI.Key,
        for text: String,
        by type: SearchMemoType
    ) async throws -> [ID<Memo>] {
        let client = SearchClient(appID: ApplicationID(rawValue: Algolia.appID), apiKey: APIKey(rawValue: key.rawValue))
        let indexName: String
        switch type {
        case .text:
            indexName = Algolia.indexNameForMemoByText
        case .quote:
            indexName = Algolia.indexNameForMemoByQuote
        }
        let index = client.index(withName: IndexName(rawValue: indexName))

        do {
            var query = Query(text)
            query.hitsPerPage = 20
            let response = try index.search(query: query)

            // Convert response object into an array of SearchMemoResponse ignoring inaccurate element.
            // ref: https://stackoverflow.com/questions/46344963/swift-jsondecode-decoding-arrays-fails-if-single-element-decoding-fails
            let hitsData = try JSONEncoder().encode(response.hits.map(\.object))
            let throwables = try JSONDecoder().decode([Throwable<SearchMemoResponse>].self, from: hitsData)
            let results = throwables.compactMap { try? $0.result.get() }
            return results.map { .init(stringLiteral: $0.objectID) }
        } catch {
            if let transportError = error as? AlgoliaSearchClient.TransportError {
                print(transportError.localizedDescription)
                switch transportError {
                case let .requestError(error):
                    print("# TransportError.requestError: \(error)")
                case let .httpError(error):
                    if error.statusCode == 403 {
                        throw SearchRepositoryError.forbidden
                    }
                    print("# TransportError.httpError: \(error)")
                case let .noReachableHosts(intermediateErrors: intermediateErrors):
                    print("# TransportError.noReachableHosts: \(intermediateErrors)")
                case .missingData:
                    print("# TransportError.missingData")
                case let .decodingFailure(error):
                    print("# TransportError.decodingFailure: \(error)")
                }
                throw SearchRepositoryError.badNetwork
            } else {
                throw SearchRepositoryError.badNetwork
            }
        }
    }
}

private struct Throwable<T: Decodable>: Decodable {
    let result: Result<T, Error>

    init(from decoder: Decoder) throws {
        result = Result(catching: { try T(from: decoder) })
    }
}

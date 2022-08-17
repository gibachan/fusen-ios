//
//  RakutenBooksPublicationRepositoryImpl.swift
//  RakutenBooksPublicationRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/30.
//

import Foundation

struct RakutenBooksPublicationRepositoryImpl: PublicationRepository {
    private let session: URLSession
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func findBy(isbn: ISBN) async throws -> Publication {
        let urlString = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?applicationId=\(rakutenApplicationId)&formatVersion=2&isbn=\(isbn.value)"
        let url = URL(string: urlString)!
        log.d("request: \(url.absoluteURL)")
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw PublicationRepositoryError.notFound
        }
        do {
            let bookResponse = try decoder.decode(RakutenBooksResponse.self, from: data)
            if let book = bookResponse.toDomain() {
                return book
            } else {
                throw PublicationRepositoryError.notFound
            }
        } catch {
            throw PublicationRepositoryError.invalidJSON
        }
    }
    
    func findBy(title: String) async throws -> [Publication] {
        let urlString = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?applicationId=\(rakutenApplicationId)&formatVersion=2&title=\(title)&hits=30&page=1"
        let url = URL(string: urlString)!
        log.d("request: \(url.absoluteURL)")
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw PublicationRepositoryError.notFound
        }
        do {
            let bookResponse = try decoder.decode([RakutenBooksResponse].self, from: data)
            let books = bookResponse.compactMap({ $0.toDomain() })
            return books
        } catch {
            throw PublicationRepositoryError.notFound
        }
    }
}

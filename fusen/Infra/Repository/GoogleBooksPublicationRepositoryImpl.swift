//
//  GoogleBooksPublicationRepositoryImpl.swift
//  GoogleBooksPublicationRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Foundation

// This API is not good enough...
struct GoogleBooksPublicationRepositoryImpl: PublicationRepository {
    private let session: URLSession
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func findBy(isbn: ISBN) async throws -> Publication {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn.value)")!
        log.d("request: \(url.absoluteURL)")
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw PublicationRepositoryError.notFound
        }
        do {
            let bookResponse = try decoder.decode(GoogleBooksResponse.self, from: data)
            if let book = bookResponse.toDomain() {
                return book
            } else {
                throw PublicationRepositoryError.notFound
            }
        } catch {
            throw PublicationRepositoryError.invalidJSON
        }
    }
}
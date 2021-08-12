//
//  PublicationRepositoryImpl.swift
//  PublicationRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Foundation

struct PublicationRepositoryImpl: PublicationRepository {
    private let session: URLSession
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func findBy(isbn: ISBN) async throws -> Publication {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn.value)")!
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw PublicationRepositoryError.notFound
        }
        do {
            let bookResponse = try decoder.decode(PublicationResponse.self, from: data)
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

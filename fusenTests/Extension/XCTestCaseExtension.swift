//
//  XCTestCaseExtension.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/20.
//

import XCTest

extension XCTestCase {
    // ref: https://www.swiftbysundell.com/articles/testing-error-code-paths-in-swift/
    func assertThrows<T, E: Error & Equatable>(
        _ expression: @autoclosure () async throws -> T,
        throws error: E,
        in file: StaticString = #file,
        line: UInt = #line
    ) async {
        var thrownError: Error?
        
        do {
            _ = try await expression()
            XCTFail("expression does not throw error", file: file, line: line)
        } catch {
            thrownError = error
        }

        XCTAssertTrue(
            thrownError is E,
            "Unexpected error type: \(type(of: thrownError))",
            file: file, line: line
        )

        XCTAssertEqual(
            thrownError as? E, error,
            file: file, line: line
        )
    }
}

//
//  AlamofireHTTPClientTests.swift
//  MovariumTests
//
//  Created by Anton Solovev on 05.05.2026.
//

import Alamofire
import XCTest
@testable import Movarium

private final class FakeAuthTokenStore: AuthTokenKeychain, @unchecked Sendable {
    private let lock = NSLock()
    private var token: String?

    func setAuthToken(_ value: String) throws {
        lock.lock()
        defer { lock.unlock() }
        token = value
    }

    func getAuthToken() throws -> String? {
        lock.lock()
        defer { lock.unlock() }
        return token
    }

    func removeAuthToken() throws {
        lock.lock()
        defer { lock.unlock() }
        token = nil
    }
}

private final class URLProtocolStub: URLProtocol, @unchecked Sendable {
    static var requestHandler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = Self.requestHandler else {
            XCTFail("URLProtocolStub.requestHandler was not set")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

private struct StubEndpoint: APIEndpoint {
    let path: String
    let method: HTTPMethod
    let parameters: Parameters? = nil
    let headers: HTTPHeaders?
}

private struct StubRequest: Codable, Equatable {
    let title: String
    let rating: Int
}

private struct StubResponse: Codable, Equatable {
    let id: String
    let ok: Bool
}

final class AlamofireHTTPClientTests: XCTestCase {
    override func tearDown() {
        URLProtocolStub.requestHandler = nil
        super.tearDown()
    }

    func testSendRequestEncodesBodyHeadersAndDecodesResponse() async throws {
        let session = makeSession()
        let sut = AlamofireHTTPClient(baseURL: .kreosoft, session: session)
        let requestBody = StubRequest(title: "Movie", rating: 5)
        let expected = StubResponse(id: "42", ok: true)
        let responseData = try JSONEncoder().encode(expected)
        let requestObserved = expectation(description: "request observed")

        URLProtocolStub.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
            XCTAssertEqual(request.url?.path, "/tests/request")
            XCTAssertEqual(request.value(forHTTPHeaderField: "X-Test"), "1")

            let body = try self.requestBodyData(from: request)
            let decodedBody = try JSONDecoder().decode(StubRequest.self, from: body)
            XCTAssertEqual(decodedBody, requestBody)

            requestObserved.fulfill()
            let response = HTTPURLResponse(url: try XCTUnwrap(request.url), statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, responseData)
        }

        let result: StubResponse = try await sut.sendRequest(
            endpoint: StubEndpoint(
                path: "/tests/request",
                method: .post,
                headers: ["X-Test": "1"]
            ),
            requestBody: requestBody
        )

        XCTAssertEqual(result, expected)
        await fulfillment(of: [requestObserved], timeout: 1.0)
    }

    func testSendRequestWithoutResponseOnUnauthorizedClearsTokenAndPostsNotification() async throws {
        let session = makeSession()
        let authTokenStore = FakeAuthTokenStore()
        let notificationCenter = NotificationCenter()
        let sut = AlamofireHTTPClient(
            baseURL: .kreosoft,
            session: session,
            authTokenKeychain: authTokenStore,
            notificationCenter: notificationCenter
        )

        try authTokenStore.setAuthToken("token-123")
        let unauthorizedExpectation = expectation(
            forNotification: .unauthorizedErrorOccurred,
            object: nil,
            notificationCenter: notificationCenter
        )

        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(url: try XCTUnwrap(request.url), statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        do {
            try await sut.sendRequestWithoutResponse(
                endpoint: StubEndpoint(path: "/tests/protected", method: .get, headers: nil),
                requestBody: nil as EmptyRequestModel?
            )
            XCTFail("Expected unauthorized error")
        } catch {
            XCTAssertEqual(error as? AppError, .unauthorized)
        }

        await fulfillment(of: [unauthorizedExpectation], timeout: 1.0)
        XCTAssertNil(try authTokenStore.getAuthToken())
    }

    private func makeSession() -> Session {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return Session(configuration: configuration)
    }

    private func requestBodyData(from request: URLRequest) throws -> Data {
        if let body = request.httpBody {
            return body
        }

        guard let stream = request.httpBodyStream else {
            throw XCTSkip("Request body was not attached")
        }

        stream.open()
        defer { stream.close() }

        var result = Data()
        let bufferSize = 1024
        var buffer = [UInt8](repeating: 0, count: bufferSize)

        while stream.hasBytesAvailable {
            let readBytes = stream.read(&buffer, maxLength: bufferSize)
            if readBytes < 0 {
                throw stream.streamError ?? URLError(.cannotDecodeContentData)
            }
            if readBytes == 0 {
                break
            }
            result.append(buffer, count: readBytes)
        }

        return result
    }
}

//
//  AlamofireHTTPClient.swift
//  Movarium
//
//  Created by Anton Solovev on 04.10.2024.
//

@preconcurrency import Alamofire
import KeychainAccess
import Foundation

final class AlamofireHTTPClient: HTTPClient, @unchecked Sendable {

    private final class CallbackBox: @unchecked Sendable {
        let client: AlamofireHTTPClient
        init(_ client: AlamofireHTTPClient) { self.client = client }
        func logResponse(_ response: AFDataResponse<Data?>) { client.log(response) }
        func onUnauthorized() { client.handleUnauthorizedError() }
    }
    
    private let baseURL: BaseURL
    let keychain = Keychain()
    
    init(baseURL: BaseURL) {
        self.baseURL = baseURL
    }
    
    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws -> T {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        let box = CallbackBox(self)
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response { response in
                    box.logResponse(response)
                }
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        continuation.resume(returning: decodedData)
                    case .failure(let error):
                        let status = response.response?.statusCode
                        if status == 401 {
                            box.onUnauthorized()
                        }
                        continuation.resume(throwing: AppError.map(error, httpStatus: status))
                    }
                }
        }
    }
    
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        let box = CallbackBox(self)
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        let status = response.response?.statusCode
                        if status == 401 {
                            box.onUnauthorized()
                        }
                        continuation.resume(throwing: AppError.map(error, httpStatus: status))
                    }
                }
        }
    }
    
    private func handleUnauthorizedError() {
        do {
            try keychain.remove("authToken")
        } catch {
            AppLog.auth.error("Keychain remove failed: \(String(describing: error))")
        }
        
        NotificationCenter.default.post(name: .unauthorizedErrorOccurred, object: nil)
    }
}

// MARK: Requests logging
private extension AlamofireHTTPClient {
    func log(_ response: AFDataResponse<Data?>) {
        let method = response.request?.method?.rawValue ?? SC.empty
        let url = response.request?.url?.absoluteString ?? SC.empty
        AppLog.networking.debug("\(method) \(url, privacy: .public)")

        #if DEBUG
        switch response.result {
        case let .success(responseData):
            if let object = try? JSONSerialization.jsonObject(with: responseData ?? .empty),
               let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
               let string = String(data: data, encoding: .utf8) {
                AppLog.networking.debug("\(string, privacy: .private)")
            }
        case let .failure(error):
            AppLog.networking.error("Request failed: \(String(describing: error), privacy: .public)")
        }
        #endif
    }
}

//
//  AppError.swift
//  Movarium
//
//  Created by Anton Solovev on 04.10.2024.
//

import Foundation

enum AppError: Error, LocalizedError, Equatable {
    case unauthorized
    case client(code: Int)
    case server(code: Int)
    case decoding(message: String)
    case transport(code: URLError.Code?)
    case unknown(message: String)

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Session expired or not authorized."
        case let .client(code):
            return "Request failed (HTTP \(code))."
        case let .server(code):
            return "Server error (HTTP \(code))."
        case let .decoding(message):
            return "Could not read response: \(message)"
        case let .transport(code):
            if let code {
                return "Network error (\(code.rawValue))."
            }
            return "Network error."
        case let .unknown(message):
            return message
        }
    }

    static func map(_ error: Error, httpStatus: Int?) -> AppError {
        if error is DecodingError {
            return .decoding(message: (error as NSError).localizedDescription)
        }
        if let urlError = error as? URLError {
            return .transport(code: urlError.code)
        }
        if httpStatus == 401 {
            return .unauthorized
        }
        if let code = httpStatus {
            if (400..<500).contains(code) { return .client(code: code) }
            if (500..<600).contains(code) { return .server(code: code) }
        }
        return .unknown(message: (error as NSError).localizedDescription)
    }
}

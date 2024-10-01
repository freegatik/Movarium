//
//  ApplicationSupport.swift
//  Movarium
//
//  Created by Anton Solovev on 01.10.2024.
//

import Foundation
import os

// MARK: - Logging

enum AppLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "Movarium"

    static let networking = Logger(subsystem: subsystem, category: "Networking")
    static let auth = Logger(subsystem: subsystem, category: "Auth")
}

// MARK: - API configuration

enum APIConfiguration {
    private static func string(forKey key: String, default defaultValue: String) -> String {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            return defaultValue
        }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? defaultValue : trimmed
    }

    static var kreosoftBaseURL: String {
        string(forKey: "KREOSOFT_BASE_URL", default: "https://react-midterm.kreosoft.space")
    }

    static var kinopoiskBaseURL: String {
        string(forKey: "KINOPOISK_BASE_URL", default: "https://kinopoiskapiunofficial.tech")
    }
}

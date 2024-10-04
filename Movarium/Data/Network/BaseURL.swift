//
//  BaseURL.swift
//  Movarium
//
//  Created by Anton Solovev on 04.10.2024.
//

enum BaseURL {
    case kreosoft
    case kinopoisk

    var baseURL: String {
        switch self {
        case .kreosoft:
            return APIConfiguration.kreosoftBaseURL
        case .kinopoisk:
            return APIConfiguration.kinopoiskBaseURL
        }
    }
}

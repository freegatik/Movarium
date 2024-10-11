//
//  KinopoiskDetails.swift
//  Movarium
//
//  Created by Anton Solovev on 11.10.2024.
//

import Foundation

struct KinopoiskDetails {
    let kinopoiskId: Int
    let ratingKinoposik: Double
    let ratingImdb: Double
    
    init(kinopoiskId: Int = 0, ratingKinoposik: Double = 0, ratingImdb: Double = 0) {
        self.kinopoiskId = kinopoiskId
        self.ratingKinoposik = ratingKinoposik
        self.ratingImdb = ratingImdb
    }
}

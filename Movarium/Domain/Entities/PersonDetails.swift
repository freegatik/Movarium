//
//  PersonDetails.swift
//  Movarium
//
//  Created by Anton Solovev on 11.10.2024.
//

import Foundation

struct PersonDetails {
    let posterURL: String
    
    init(posterURL: String = SC.empty) {
        self.posterURL = posterURL
    }
}

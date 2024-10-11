//
//  AllMovieData.swift
//  Movarium
//
//  Created by Anton Solovev on 10.10.2024.
//

struct AllMovieData {
    var posterURL: String
    var id: String
    var reviews: [ReviewShort]

    init(posterURL: String = SC.empty, id: String = SC.empty, reviews: [ReviewShort] = []) {
        self.posterURL = posterURL
        self.id = id
        self.reviews = reviews
    }
}

struct ReviewShort {
    var id: String
    var rating: Int
}

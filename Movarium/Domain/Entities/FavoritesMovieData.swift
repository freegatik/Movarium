//
//  FavoritesMovieData.swift
//  Movarium
//
//  Created by Anton Solovev on 10.10.2024.
//

struct FavoritesMovieData {
    var posterURL: String
    var id: String

    init(posterURL: String = SC.empty, id: String = SC.empty) {
        self.posterURL = posterURL
        self.id = id
    }
}

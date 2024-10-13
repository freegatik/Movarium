//
//  FavoritesRepository.swift
//  Movarium
//
//  Created by Anton Solovev on 12.10.2024.
//

protocol FavoriteMoviesRepository {
    func addToFavorites(movieID: String) async throws
    func deleteFromFavorites(movieID: String) async throws
    func getFavorites() async throws -> MoviesListResponseModel
}

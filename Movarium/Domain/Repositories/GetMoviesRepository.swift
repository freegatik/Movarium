//
//  GetMoviesRepository.swift
//  Movarium
//
//  Created by Anton Solovev on 12.10.2024.
//

protocol GetMoviesRepository {
    func getMovies(page: Int) async throws -> MoviesPagedListResponseModel
    func getMovieDetails(movieID: String) async throws -> MovieDetailsModel
}

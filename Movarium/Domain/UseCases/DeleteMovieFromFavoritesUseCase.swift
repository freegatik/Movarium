//
//  DeleteMovieFromFavoritesUseCase.swift
//  Movarium
//
//  Created by Anton Solovev on 15.10.2024.
//

protocol DeleteMovieFromFavoritesUseCase {
    func execute(movieID: String) async throws
}

class DeleteMovieFromFavoritesUseCaseImpl: DeleteMovieFromFavoritesUseCase {
    private let repository: FavoriteMoviesRepository
    
    init(repository: FavoriteMoviesRepository) {
        self.repository = repository
    }
    
    static func create() -> DeleteMovieFromFavoritesUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = FavoriteMoviesRepositoryImpl(httpClient: httpClient)
        return DeleteMovieFromFavoritesUseCaseImpl(repository: repository)
    }
    
    func execute(movieID: String) async throws {
        do {
            try await repository.deleteFromFavorites(movieID: movieID)
        } catch {
            throw error
        }
    }
}

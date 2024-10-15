//
//  AddReviewUseCase.swift
//  Movarium
//
//  Created by Anton Solovev on 14.10.2024.
//

protocol AddReviewUseCase {
    func execute(movieID: String, request: ReviewRequest) async throws
}

class AddReviewUseCaseImpl: AddReviewUseCase {
    private let repository: ReviewsRepository
    
    init(repository: ReviewsRepository) {
        self.repository = repository
    }
    
    static func create() -> AddReviewUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = ReviewsRepositoryImpl(httpClient: httpClient)
        return AddReviewUseCaseImpl(repository: repository)
    }
    
    func execute(movieID: String, request: ReviewRequest) async throws {
        do {
            try await repository.addReview(movieID: movieID, request: request)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

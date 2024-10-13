//
//  GetUserDataRepository.swift
//  Movarium
//
//  Created by Anton Solovev on 13.10.2024.
//

protocol GetUserDataRepository {
    func getUserData() async throws -> UserDataResponseModel
}

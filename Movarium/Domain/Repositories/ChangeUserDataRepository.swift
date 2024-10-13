//
//  ChangeUserDataRepository.swift
//  Movarium
//
//  Created by Anton Solovev on 12.10.2024.
//

protocol ChangeUserDataRepository {
    func changeUserData(request: UserDataRequestModel) async throws
}

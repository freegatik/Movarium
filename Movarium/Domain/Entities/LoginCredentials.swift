//
//  LoginCredentials.swift
//  Movarium
//
//  Created by Anton Solovev on 11.10.2024.
//

struct LoginCredentials {
    var username: String
    var password: String
    
    init(username: String = SC.empty, password: String = SC.empty) {
        self.username = username
        self.password = password
    }
}

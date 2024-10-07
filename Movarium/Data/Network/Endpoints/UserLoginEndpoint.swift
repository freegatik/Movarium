//
//  UserLoginEndpoint.swift
//  Movarium
//
//  Created by Anton Solovev on 07.10.2024.
//

import Alamofire

struct UserLoginEndpoint: APIEndpoint {
    var path: String {
        return "/api/account/login"
    }
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}

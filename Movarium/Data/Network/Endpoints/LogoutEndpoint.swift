//
//  LogoutEndpoint.swift
//  Movarium
//
//  Created by Anton Solovev on 06.10.2024.
//

import Alamofire
import KeychainAccess

struct LogoutEndpoint: APIEndpoint {
    var path: String {
        return "/api/account/logout"
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

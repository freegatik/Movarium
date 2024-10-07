//
//  MoviesPagedListEndpoint.swift
//  Movarium
//
//  Created by Anton Solovev on 07.10.2024.
//

import Alamofire

struct MoviesPagedListEndpoint: APIEndpoint {
    let page: Int
    
    var path: String {
        return "/api/movies/\(page)"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}

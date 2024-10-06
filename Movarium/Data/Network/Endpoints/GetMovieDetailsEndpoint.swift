//
//  GetMovieDetailsEndpoint.swift
//  Movarium
//
//  Created by Anton Solovev on 06.10.2024.
//

import Alamofire

struct GetMovieDetailsEndpoint: APIEndpoint {
    
    let movieID: String
    
    var path: String {
        return "/api/movies/details/\(movieID)"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Alamofire.Parameters? {
        return ["id": movieID]
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}

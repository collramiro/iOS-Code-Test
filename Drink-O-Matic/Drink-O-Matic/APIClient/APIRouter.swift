//
//  APIRouter.swift
//  Drink-O-Matic
//
//  Created by Ramiro Coll Doñetz on 01/08/2019.
//  Copyright © 2019 Ramiro Coll Doñetz. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case drinks(filter: [String:String])
    case drink(id: String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
//        case .login:
//            return .post
        case .drinks, .drink:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
//        case .login:
//            return "/login"
        case .drinks:
            return "/filter.php"
        case .drink:
            return "/lookup.php"
        }
    }
    
    // MARK: - Parameters
    private var queryParameters: Parameters? {
        switch self {
        case .drinks(let filter):
            return filter
        case .drink(let id):
            return [K.APIParameterKey.drinkId: id]
        }
    }
    
    // MARK: - Body Parameters
    private var bodyParameters: Parameters? {
        switch self {
//        case .login(let email, let password):
//            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        default:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        //create url and query params
        let baseUrl = try K.ProductionServer.baseURL.asURL()
        var urlComponents = URLComponents.init(string: baseUrl.appendingPathComponent(path).absoluteString)
        if let parameters = queryParameters {
            urlComponents?.setQueryItems(with: parameters)
        }

        //protective code
        guard let requestUrl = urlComponents?.url else {
            throw AFError.invalidURL(url: baseUrl.appendingPathComponent(path))
        }
        
        //here we start to work with the URLRequest object
        var urlRequest = URLRequest(url: requestUrl)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = bodyParameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: Parameters) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
    }
}

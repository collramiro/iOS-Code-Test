//
//  APIClient.swift
//  Drink-O-Matic
//
//  Created by Ramiro Coll Doñetz on 01/08/2019.
//  Copyright © 2019 Ramiro Coll Doñetz. All rights reserved.
//

import Alamofire

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
//    static func login(email: String, password: String, completion:@escaping (Result<User>)->Void) {
//        performRequest(route: APIRouter.login(email: email, password: password), completion: completion)
//    }
    
    static func getDrinks(completion:@escaping (AFResult<DrinkList>)->Void) {
        let jsonDecoder = JSONDecoder()
        performRequest(route: APIRouter.drinks(filter: K.APIDrinksFilter.filterByCocktailGlass), decoder: jsonDecoder, completion: completion)
    }
    
    static func getDrinkDetails(drinkId: String, completion:@escaping (AFResult<DrinkDetails>)->Void) {
    
    AF.request(APIRouter.drink(id: drinkId)).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let responseDict = value as? [String: Any] {
                    let drinkDetail = DrinkDetails.initFromDictionary(dict: responseDict)
                    completion(.success(drinkDetail))
                }
            case .failure(let error):
                // error handling
                completion(.failure(error))
            }
        }
    }
}


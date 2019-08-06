//
//  Constants.swift
//  Drink-O-Matic
//
//  Created by Ramiro Coll Doñetz on 01/08/2019.
//  Copyright © 2019 Ramiro Coll Doñetz. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "https://www.thecocktaildb.com/api/json/v1/1"
    }
    
    struct APIParameterKey {
        static let drinkId = "i"

        //        static let password = "password"
        //        static let email = "email"
    }
    
    struct APIDrinksFilter {
        //Filter by Glass
        static let filterByCocktailGlass = ["g" : "Cocktail_glass"]
        static let filterByChampagneFlute = ["g" : "Champagne_flute"]
        
        //Filter by Alcoholic
        static let filterByAlcoholic = ["a" : "Alcoholic"]
        static let filterByNonAlcoholic = ["a" : "Non_Alcoholic"]
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

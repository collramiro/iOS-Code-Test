//
//  DrinkDetails.swift
//  Drink-O-Matic
//
//  Created by Ramiro Coll Doñetz on 01/08/2019.
//  Copyright © 2019 Ramiro Coll Doñetz. All rights reserved.
//

import UIKit

class DrinkDetails {
    var instructions: String?
    var ingredients = [String]()

    static func initFromDictionary(dict: [String: Any]) -> DrinkDetails {
        let drinkDetail = DrinkDetails()
        
        if let drinkArray = dict["drinks"] as? [Any], let drinkDict = drinkArray.first as? [String: Any] {
            //parse instructions
            drinkDetail.instructions = drinkDict["strInstructions"] as? String
            
            //parse ingredients
            var ingredientCount = 1
            while let ingredient = drinkDict["strIngredient\(ingredientCount)"] as? String, !ingredient.isEmpty{
                drinkDetail.ingredients.append(ingredient)
                ingredientCount += 1
            }
        }
        
        return drinkDetail
    }
}

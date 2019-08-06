//
//  Drink.swift
//  Drink-O-Matic
//
//  Created by Ramiro Coll Doñetz on 01/08/2019.
//  Copyright © 2019 Ramiro Coll Doñetz. All rights reserved.
//

import Foundation
import UIKit

struct DrinkList: Codable {
    let drinks: [Drink]
}

struct Drink: Codable {
    let name: String
    let thumbUrl: String
    let id: String
}

extension Drink {
    //Customizing Key Names to match the naming style
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case thumbUrl = "strDrinkThumb"
        case id = "idDrink"
    }
    
    func highlightedImage() -> Drink {
//        let scaledImage = image.resize(toWidth: image.size.width * GlobalConstants.cardHighlightedFactor)
        return Drink.init(name: name, thumbUrl: thumbUrl, id: id)
    }
}

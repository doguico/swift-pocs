//
//  Meal.swift
//  FoodTracker
//
//  Created by Guido Corazza on 8/18/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class Meal{
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    init?(pName: String, pPhoto: UIImage?, pRating: Int){
        // The name must not be empty
        guard !pName.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (pRating >= 0) && (pRating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = pName
        self.photo = pPhoto
        self.rating = pRating
    }
    
    
}

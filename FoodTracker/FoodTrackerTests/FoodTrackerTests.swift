//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Guido Corazza on 8/17/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    //MARK: Meal Class Tests

    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal.init(pName: "Zero", pPhoto: nil, pRating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Highest positive rating
        let positiveRatingMeal = Meal.init(pName: "Positive", pPhoto: nil, pRating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testMealInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Meal.init(pName: "Negative", pPhoto: nil, pRating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // Empty String
        let emptyNameMeal = Meal.init(pName: "", pPhoto: nil, pRating: 2)
        XCTAssertNil(emptyNameMeal)
        
        // Rating exceeds maximum
        let largeRatingMeal = Meal.init(pName: "Large", pPhoto: nil, pRating: 6)
        XCTAssertNil(largeRatingMeal)
    }
    
    
}

//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by zxx_iMac on 2018/3/29.
//  Copyright © 2018年 zxx_mbp. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    //MARK:Meal class tests
    
    // Confirm the Meal Class initializer returns a Meal object when passed valid parameters
    func testMealInitializationSucceeds() {
        //Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", rating: 0, image: nil)
        XCTAssertNotNil(zeroRatingMeal)
        
        //Highest positive rating
        let highestRatingMeal = Meal.init(name: "Highest", rating:5, image: nil)
        XCTAssertNotNil(highestRatingMeal)
    }
    
    //Confirm that Meal initializer return nil when passed a negative rating or an empty name
    func testMealInitializationFails() {
        //Negative rating
        let negativeRatingMeal = Meal.init(name: "negative", rating: -1, image: nil)
        XCTAssertNil(negativeRatingMeal)
        
        //Rating exceeds maxium
        let exceedRatingMeal = Meal.init(name: "Exceeds", rating: 6, image: nil)
        XCTAssertNil(exceedRatingMeal)
        
        //Empty name
        let emptyNameMeal = Meal.init(name: "", rating: 1, image: nil)
        XCTAssertNil(emptyNameMeal)
    }
}

//
//  Meal.swift
//  FoodTracker
//
//  Created by zxx_mbp on 2018/4/1.
//  Copyright © 2018年 zxx_mbp. All rights reserved.
//

import UIKit
import os.log

class Meal:NSObject,NSCoding {
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: PropertyKey.name)
        aCoder.encode(self.image, forKey: PropertyKey.image)
        aCoder.encode(self.rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //The name is required. If we cannot decoder a name string, the initializer shour fial
        guard let nameString = aDecoder.decodeObject(forKey: PropertyKey.name)as? String else {
            os_log("Unable to decode the name for a Meal object.",log:OSLog.default, type:.debug)
            return nil
        }
        
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        self.init(name: nameString, rating: rating, image: image)
    }
    
    //MARK:Types
    struct PropertyKey {
        static let name = "name"
        static let image = "image"
        static let rating = "rating"
    }
    //MARK:Properties
    var name:String
    var rating:Int
    var image:UIImage?
    
    //MARK:Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    init?(name:String,rating:Int,image:UIImage?) {
        //        //Initialization should return nil if there is no name or the rating is negative
        //        if name.isEmpty || rating < 0 {
        //            return nil
        //        }
        
        //The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        //The rating must be between 0 and 5 inclusively
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        
        // Initialize the sotred properties
        self.name = name
        self.rating = rating
        self.image = image
    }
}

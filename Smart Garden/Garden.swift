//
//  Garden.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/20/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import Foundation
import Parse

// 1
class Garden : PFObject, PFSubclassing {
    
    // 2
    @NSManaged var gardenName: String
    @NSManaged var gardenCity: String
    @NSManaged var gardenState: String
    @NSManaged var userID: PFUser?
    @NSManaged var userArray: [PFUser]?
    @NSManaged var pName: [String]
    @NSManaged var pType: [String]
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Garden"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
}
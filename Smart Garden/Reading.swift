//
//  Reading.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/20/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import Foundation
import Parse

// 1
class Reading : PFObject, PFSubclassing {
    
    // 2
    @NSManaged var gardenID: PFObject?
    @NSManaged var readings: Array<Array<Double>>
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Reading"
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
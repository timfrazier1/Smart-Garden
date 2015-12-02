//
//  ParseHelper.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/25/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import Foundation
import Parse

// 1
class ParseHelper {
    
    static func gardenRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        let gardenQuery = Garden.query()
        gardenQuery!.whereKey("userID", equalTo: PFUser.currentUser()!)
        gardenQuery!.includeKey("pName")
        
        gardenQuery!.findObjectsInBackgroundWithBlock(completionBlock)
    }
    // 2
    static func readingsRequestForCurrentUser(currentGarden: Garden, completionBlock: PFQueryArrayResultBlock) {
            
        let readingsQuery = Reading.query()
        readingsQuery!.whereKey("gardenID", equalTo: currentGarden)
            
        readingsQuery!.includeKey("readings")
        readingsQuery!.orderByDescending("createdAt")
        
        readingsQuery!.findObjectsInBackgroundWithBlock(completionBlock)

    }
    
}

extension PFObject {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
}

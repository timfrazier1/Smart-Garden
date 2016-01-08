//
//  ClaimGardenViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 1/1/16.
//  Copyright © 2016 FrazierApps. All rights reserved.
//

import UIKit
import Parse


class ClaimGardenViewController: UIViewController {


    @IBOutlet weak var gardenIDtextField: UITextField!
    
    @IBAction func claimGardenButtonTapped(sender: AnyObject) {
        
        if (gardenIDtextField.text!.characters.count == 10) {
            
            // Create parse object linkage
            //PFObject(withoutDataWithClassName: "Garden", objectId: gardenIDtextField.text!).addUniqueObject(PFUser.currentUser()!.objectId!, forKey: "userArray")
            print("Garden ID text field: \(gardenIDtextField.text!)")
            print("PF User object ID: \(PFUser.currentUser()!.objectId!)")
            
            //myComment["parent"] = PFObject(withoutDataWithClassName:"Post", objectId:"1zEcyElZ80")
            let gardenToClaim = PFObject(withoutDataWithClassName: "Garden", objectId: gardenIDtextField.text!)
            print("Garden to claim: \(gardenToClaim)")
            
            let relation = gardenToClaim.relationForKey("userArray")
            relation.addObject(PFUser.currentUser()!)
            gardenToClaim.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // if Garden created successfully
                    // create the alert
                    let alert = UIAlertController(title: "Success", message: "Garden claimed with ID:\(self.gardenIDtextField.text!).", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    // show the alert
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    // There was a problem, check error.description
                    // create the alert
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    // show the alert
                    self.presentViewController(alert, animated: true, completion: nil)

                }
            }
            
            
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid Garden ID. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)

        }
        
        
        // else on error show a failure message
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

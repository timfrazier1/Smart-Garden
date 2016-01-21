//
//  ReadingNamesDetailTableViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 1/16/16.
//  Copyright © 2016 FrazierApps. All rights reserved.
//

import UIKit
import Parse

class ReadingNamesDetailTableViewController: UITableViewController, UITextFieldDelegate {

    // Container to store the view table selected object
    var currentObject : Garden?
    var newPName : [String] = []
    
    @IBAction func saveButton(sender: AnyObject) {
        
        // Unwrap the current object object
        if let object = currentObject {
            newPName = []
            for i in 0..<object.pName.count {
                let customCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! SettingTableViewCell

                newPName.append(customCell.userDefinedType.text! as String)
            }
            
            object["pName"] = newPName
            
            // Save the data back to the server in a background task
            object.saveEventually(nil)
            
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    @IBAction func resetButton(sender: AnyObject) {
        // Unwrap the current object object
        if let object = currentObject {
            newPName = object.pType
            object["pName"] = newPName
            object.saveEventually(nil)
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hideKeys = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        hideKeys.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(hideKeys)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func hideKeyboard() {
        self.view.endEditing(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let rows = currentObject?.pName.count {
            return rows
        } else {
            return 0
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as! SettingTableViewCell
        
        // Need to get the Parse object data
        if let object = currentObject {
            cell.readingTypeLabel.text = object["pType"][indexPath.row] as! String
            cell.userDefinedType.text = object["pName"][indexPath.row] as! String
        }
    
        cell.userDefinedType.delegate = self
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //self.view.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        //self.view.resignFirstResponder()
        print("Made it to touches began section")
    }

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //super.scrollViewWillBeginDragging(self)
        self.view.endEditing(true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SettingsViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/20/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import UIKit



class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBAction func saveLabels(sender: AnyObject) {
        print("Main save button pushed")
        tableView.reloadData()
    }
    
    //Need to add a button to the storyboard at the top (maybe header) and make the action outlet to update the setting lables, both on display and in NSuserDefaults
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        /* In the settings, would like to make the reading labels customizable. 
            They would have to be editable and then we could match and replace the item in the string before it is displayed on the cells.
            It could work. 
        

        if NSUserDefaults.standardUserDefaults().objectForKey("customReadingTypes") != nil{
            currentReadingTypes = NSUserDefaults.standardUserDefaults().objectForKey("customReadingTypes") as! [String]
        }
        */
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }


}

extension SettingsViewController: UITableViewDataSource {
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as! SettingTableViewCell
 /*       if customReadingTypes[indexPath.row] != currentReadingTypes[indexPath.row] {
            cell.userDefinedType.text = customReadingTypes[indexPath.row]
        }
   */
        if cell.userDefinedType.text != "" {
            //cell.readingTypeLabel.text = cell.userDefinedType.text  // Need this for feedback currently, soon will comment out
            customReadingTypes[indexPath.row] = cell.userDefinedType.text!
          /*  if customReadingTypes.count <= indexPath.row {
                customReadingTypes.append(cell.userDefinedType.text!)
            } else if customReadingTypes.count > indexPath.row {
                customReadingTypes[indexPath.row] = cell.userDefinedType.text!
            }
            */
        }
        else {
            cell.readingTypeLabel.text = currentReadingTypes[indexPath.row]
            
            //customReadingTypes[indexPath.row] = currentReadingTypes[indexPath.row]
            
            if customReadingTypes.count <= indexPath.row {
                customReadingTypes.append(currentReadingTypes[indexPath.row])
            } else if customReadingTypes.count > indexPath.row {
                cell.userDefinedType.text = customReadingTypes[indexPath.row]
            }

        }
        
        
        
        NSUserDefaults.standardUserDefaults().setObject(customReadingTypes, forKey: "customReadingTypes")
        
        return cell
        
    }
    
    
}

extension SettingsViewController: UITableViewDelegate {

    
}

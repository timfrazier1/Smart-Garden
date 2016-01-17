//
//  SettingsViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/20/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import UIKit
import Parse



class SettingsViewController: UIViewController, UITextFieldDelegate {

    
    var currentUserGardens: [Garden] = []
    var userModifiedType = [String:String]()
    var customReadingTypes = [[String:String]()]

    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // It may be that we need to use a "dictionary" type in parse that pairs the default names to the custom names.
        // Then when getting ready to display the name, we would do a lookup in the dictionary to see if an entry was present for that particular sensor.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (self.currentUserGardens.count == 0) {
            ParseHelper.gardenRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
                self.currentUserGardens = result as? [Garden] ?? []
                self.customReadingTypes = [[String:String]()]
                                // Populate the user's defined settings with any that are present in Parse
                                print("Custom reading types: \(self.customReadingTypes)")
            }
        }
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
        print("Inside touchesBegan function")
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        print("Inside TextFieldShouldReturn")
        return true
    }


}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfGardens
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return rowCount[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as! SettingTableViewCell
        
        cell.readingTypeLabel.text = readingImageTypes[indexPath.section][indexPath.row]
        //cell.userDefinedType.text = ""
        cell.userDefinedType.placeholder = mainReadingTypes[indexPath.section][indexPath.row]
        print(indexPath)
        print(cell.userDefinedType.text)
        return cell

                
    }
    
    
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("SettingHeaderCell") as! SettingTableHeader
        
        headerCell.gardenName.text = gardenNames[section]
        
        headerCell.createdAt.text = "Last reading at \(readingCreatedAt[section])"
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }

}

//
//  DashboardViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/20/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import UIKit
import Parse

class DashboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var readingArray: [Reading] = []
    var currentUserGardens: [Garden] = []
    var currentGarden: Garden?
    var currentReadings: [Int] = []
    var rowCount: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        ParseHelper.gardenRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
            self.currentUserGardens = result as? [Garden] ?? []
            self.currentGarden = self.currentUserGardens[0]
            self.rowCount = (self.currentGarden?.pName.count)!
            
            ParseHelper.readingsRequestForCurrentUser (self.currentGarden!) { (result: [PFObject]?, error: NSError?) -> Void in
            
                self.readingArray = result as? [Reading] ?? []
                self.currentReadings = self.readingArray[0].readings
                self.tableView.reloadData()
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

}

extension DashboardViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        //return readings.count
        //return (self.currentGarden?.pName.count)!
        return rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCellWithIdentifier("ReadingCell") as! ReadingTableViewCell
        
        let readingType = self.currentGarden?.pName[indexPath.row]
        
        cell.readingTypeImageView.image = UIImage(named: String(UTF8String: readingType!)!)
       /* switch readingType {
            case "Sun":
                cell.readingTypeImageView.image = "Sun"
            case "Humidity":
            
        }   */
        
        cell.readingLabel.text = String(readingType!)
        cell.valueLabel.text = String(self.currentReadings[indexPath.row])
        print("Current reading is \(String(readingType!)) and the value is \(String(self.currentReadings[indexPath.row]))")
        return cell
    }
    
}

//
//  ReadingsViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/29/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit

public var rowCount: [Int] = [0, 0]
public var currentReadingTypes: [String] = []
public var customReadingTypes: [String] = []
public var mainReadingTypes: Array<Array<String>> = []
public var readingImageTypes: Array<Array<String>> = []
public var mainReadingValues: Array<Array<Double>> = []
public var numberOfGardens: Int = 0
public var readingCreatedAt: [String] = []
public var gardenNames: [String] = []

class ReadingsViewController: UIViewController {  //, TimelineComponentTarget {

    var defaultRange = 0...8
    var additionalRangeSize = 5

    @IBOutlet weak var tableView: UITableView!

    
    //var timelineComponent: TimelineComponent<Reading, ReadingsViewController>!
    
    
    // TODO items: 
    // [+] need to fix the select row at index path
    // [+] fix the readings settings to customize the sensor names - store in 'pName' in the garden Parse Object
    // [+] User login page + linking user to garden
    // [+] Update settings view controller to allow for sensor names to be customized
    // [+] Settings view controller could also be 
    
    var readingArray: [Reading] = []
    var currentUserGardens: [Garden] = []
    var currentGarden: Garden?
    var currentReadings: Array<Array<Double>> = []

    
    var currentReadingValues: [Double] = []

    var selectedReading: String = ""
    var selectedReadingIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  timelineComponent = TimelineComponent(target: self)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        if currentUserGardens.count == 0 {
            // Get the garden data initially
            self.getGardenData()
        }
        
     //   timelineComponent.loadInitialIfRequired()
        
    }
    
    func getGardenData() {
        ParseHelper.gardenRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
            self.currentUserGardens = result as? [Garden] ?? []
            
            // If we have any returned Gardens, proceed to get the readings
            if self.currentUserGardens != [] {
                
                //print("Garden 0: \(self.currentUserGardens[0]["gardenName"])")
                //print("Garden 1: \(self.currentUserGardens[1]["gardenName"])")
                mainReadingTypes = []
                readingImageTypes = []
                mainReadingValues = []
                readingCreatedAt = []
                gardenNames = []
                
                numberOfGardens = self.currentUserGardens.count
                
                // For each garden assigned to the user, fetch the data
                for gardenNumber in 0..<numberOfGardens {
                    
                    ParseHelper.readingsRequestForCurrentUser (self.currentUserGardens, index: gardenNumber) { (result: [PFObject]?, error: NSError?) -> Void in
                        
                        self.readingArray = result as? [Reading] ?? []
                        //print("Reading Array: \(self.readingArray)")
                        
                        // Format the date information and assign to the global variable
                        let formatter = NSDateFormatter()
                        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                        readingCreatedAt.append(formatter.stringFromDate(self.readingArray[0].createdAt!))
                        
                        // Take the first reading to make the display table
                        self.currentReadings = self.readingArray[0].readings
                        
                        currentReadingTypes = []
                        customReadingTypes = []
                        self.currentReadingValues = []
                        for i in 0..<self.currentReadings.count {
                            for j in 0..<self.currentReadings[i].count {
                                currentReadingTypes.append("\((self.currentUserGardens[gardenNumber].pType[i]))\(j+1)")
                                customReadingTypes.append("\((self.currentUserGardens[gardenNumber].pName[i]))\(j+1)")
                                //Revert if fails - currentReadingTypes.append("\((self.currentGarden?.pName[i])!)\(j+1)")
                                self.currentReadingValues.append(self.currentReadings[i][j])
                            }
                        }
                        
                        // Avoid index out of range errors and assign the appropriate number of rows per garden
                        if rowCount.count <= gardenNumber {
                            rowCount.append(self.currentReadingValues.count)
                        }
                        else {
                            rowCount[gardenNumber] = self.currentReadingValues.count
                        }
                        
                        // printing information for debugging
                        //print("Garden number: \(gardenNumber)")
                        //print("Row count array: \(rowCount)")
                        //print("Current count of reading values: \(self.currentReadingValues.count)")
                        

                        readingImageTypes.append(currentReadingTypes)
                        mainReadingTypes.append(customReadingTypes)
                        mainReadingValues.append(self.currentReadingValues)
                        gardenNames.append(String(self.currentUserGardens[gardenNumber]["gardenName"]))
                        
                        if (gardenNumber + 1 == numberOfGardens) {
                            sleep(1)
                            self.tableView.reloadData()
                            // print(mainReadingTypes)
                            // print(readingImageTypes)
                        }
                        
                    }
                }

                
            // If we didn't have any returned Gardens, set up the "dummy garden"
            } else {
                let dummyGarden = Garden()
                dummyGarden.gardenName = "Example Garden"
                dummyGarden.gardenCity = "New Town"
                dummyGarden.pName = ["AirTemp","Humidity","WaterTemp","Sun","Leaks","pH"]
                
                
                self.currentUserGardens[0] = dummyGarden
                
                
                self.currentReadings = [[85.0, 82.0], [95.0], [60.0, 64.0, 62.0], [15.0], [1.0], [5.0]]
                self.currentReadingValues = [85.0, 82.0, 95.0, 60.0, 64.0, 62.0, 15.0, 1.0, 5.0]
                mainReadingValues[0] = self.currentReadingValues
                
                currentReadingTypes = ["AirTemp1", "AirTemp2", "Humidity1", "WaterTemp1", "WaterTemp2", "WaterTemp3", "Sun1", "Leaks1", "pH1"]
                customReadingTypes = currentReadingTypes
                mainReadingTypes[0] = customReadingTypes
                
                readingCreatedAt.append("a long time ago...")
                rowCount[0] = (self.currentReadingValues.count)
                
                self.tableView.reloadData()
            }
            
        }
        
    }
/*
    func loadInRange(range: Range<Int>, completionBlock: ([Reading]?) -> Void) {
        ParseHelper.readingsRequestForCurrentUser(range: range) {(result: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            self.readingArray = result as? [Reading] ?? []
            completionBlock(self.readingArray)
            
        }
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        self.getGardenData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "displayChart") {
            
            let chartViewController = segue.destinationViewController as! HistoryGraphViewController
            //let path = self.tableView.indexPathForSelectedRow!
            //print("Path = \(path)")
        
            chartViewController.readingArray = self.readingArray
            chartViewController.readingLabels = customReadingTypes
            chartViewController.selectedReading = self.selectedReading
            chartViewController.selectedReadingIndex = self.selectedReadingIndex
        }

    }

    
}

extension ReadingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentUserGardens.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount[section]
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Reading2Cell") as! ReadingTable2ViewCell
        
        var readingType = ""
        if (indexPath.section < readingImageTypes.count) {
            readingType = readingImageTypes[indexPath.section][indexPath.row]
        } else {
            readingType = "Waiting..."
        }
        
        var customReadingType = [String:String]()
        
        // This should check for a dictionary lookup into the 'pNameDict' item to see if a custom label has been defined
        
        let query = Garden.query()
        //gardenQuery!.whereKey("userID", equalTo: PFUser.currentUser()!)
        query!.whereKey("gardenName", equalTo: self.currentUserGardens[indexPath.section]["gardenName"])
        query!.getFirstObjectInBackgroundWithBlock( { (result: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print("Error on query for garden: \(error)")
                print(String(self.currentUserGardens[indexPath.section]))
                cell.reading2Label.text = String(mainReadingTypes[indexPath.section][indexPath.row])
            } else {
                let returnedGarden = result as! Garden
                if (returnedGarden["pNameDict"] != nil) {
                    customReadingType = returnedGarden["pNameDict"] as! [String : String]
                    if let customName = customReadingType[mainReadingTypes[indexPath.section][indexPath.row]] {
                        cell.reading2Label.text = String(customName)
                        mainReadingTypes[indexPath.section][indexPath.row] = customName
                    } else {
                        cell.reading2Label.text = String(mainReadingTypes[indexPath.section][indexPath.row])
                    }
                } else {
                    cell.reading2Label.text = String(mainReadingTypes[indexPath.section][indexPath.row])
                }
            }
        })

        // This hack makes the image displaying work for up to 9 sensors of the same type (e.g. only one integer digit after the type)
        let imageType = String(UTF8String: readingType)!
        cell.readingType2ImageView.image = UIImage(named: imageType[Range(start: imageType.startIndex, end: imageType.endIndex.advancedBy(-1))])
        // Revert if fail - cell.readingType2ImageView.image = UIImage(named: String(UTF8String: readingType)!)
        
        
        
        //cell.value2Label.text = String(self.currentReadingValues[indexPath.row])
        if (indexPath.section < mainReadingValues.count) {
            cell.value2Label.text = String(mainReadingValues[indexPath.section][indexPath.row])
        } else {
            cell.value2Label.text = ""
        }
        //print("Current reading is \(String(readingType)) and the value is \(String(self.currentReadingValues[indexPath.row]))")
        return cell
        
    }
    
}

extension ReadingsViewController: UITableViewDelegate {
    
    // Obviously need to fix this functionality to support the multiple gardens displayed on main screen
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! ReadingTable2ViewCell
        
        self.selectedReading = currentCell.reading2Label.text!
        // Revert if fails - self.selectedReadingIndex = (self.currentGarden?.pName.indexOf(currentCell.reading2Label.text!))!
        print("\(currentCell.reading2Label.text!)")
        
        self.selectedReadingIndex = (customReadingTypes.indexOf(currentCell.reading2Label.text!))!
        print("Home selected Reading index is: \(self.selectedReadingIndex)")
        performSegueWithIdentifier("displayChart", sender: self)
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("ReadingHeader") as! ReadingTableHeader
        
        //headerCell.gardenName.text = self.currentUserGardens[section].gardenName
        if (section < gardenNames.count) {
            headerCell.gardenName.text = gardenNames[section]
        } else {
            headerCell.gardenName.text = "Loading..."
        }
        
        if (section < readingCreatedAt.count) {
            headerCell.createdAt.text = "Last reading at \(readingCreatedAt[section])"
        } else {
            headerCell.createdAt.text = "Loading..."
        }
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }

}

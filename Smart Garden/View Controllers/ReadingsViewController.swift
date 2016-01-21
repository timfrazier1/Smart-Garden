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
var readingArrayArray: [[Reading]] = []

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
    var currentReadings: Array<Double> = []

    
    var currentReadingValues: [Double] = []

    var selectedReading: String = ""
    var selectedReadingIndex: Int = 0
    var selectedGardenIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  timelineComponent = TimelineComponent(target: self)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
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
                
                readingArrayArray = []
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
                        readingArrayArray.append(self.readingArray)
                        
                        //print("Current reading array is: \(self.readingArray)")
                        
                        if (self.readingArray.count > 0) {
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
                                currentReadingTypes.append("\((self.currentUserGardens[gardenNumber].pType[i]))")
                                customReadingTypes.append("\((self.currentUserGardens[gardenNumber].pName[i]))")
                                self.currentReadingValues.append(self.currentReadings[i])
                                
                            }
                        
                            
                            
                            
                        } else {
                            self.currentReadings = [0.0]
                            self.currentReadingValues = [0.0]
                            
                            currentReadingTypes = ["No readings"]
                            customReadingTypes = currentReadingTypes
                            
                            readingCreatedAt.append("a long time ago...")

                        }
                        
                        readingImageTypes.append(currentReadingTypes)
                        
                        if gardenNames.count <= gardenNumber {
                            gardenNames.append(String(self.currentUserGardens[gardenNumber]["gardenName"]))
                        } else {
                            gardenNames[gardenNumber] = String(self.currentUserGardens[gardenNumber]["gardenName"])
                        }
                        
                        
                        if mainReadingTypes.count <= gardenNumber {
                            mainReadingTypes.append(customReadingTypes)
                        } else {
                            mainReadingTypes[gardenNumber] = customReadingTypes
                        }
                        
                        if mainReadingValues.count <= gardenNumber {
                             mainReadingValues.append(self.currentReadingValues)
                        } else {
                            mainReadingValues[gardenNumber] = self.currentReadingValues
                        }
                        
                        // Avoid index out of range errors and assign the appropriate number of rows per garden
                        if rowCount.count <= gardenNumber {
                            rowCount.append(self.currentReadingValues.count)
                        }
                        else {
                            rowCount[gardenNumber] = self.currentReadingValues.count
                        }
                        
                        if (gardenNumber + 1 == numberOfGardens) {
                            sleep(1)
                            self.tableView.reloadData()
                            // print(mainReadingTypes)
                            // print(readingImageTypes)
                        }

                    }
                }
                
                
                // If we didn't have any returned Gardens, set up the "dummy garden"  -- FIX THIS
            } else {
                let dummyGarden = Garden()
                dummyGarden.gardenName = "Example Garden"
                dummyGarden.gardenCity = "New Town"
                dummyGarden.pName = ["AirTemp","Humidity","WaterTemp1","WaterTemp2", "Sun","Leaks","pH"]
                dummyGarden.pType = ["AirTemp", "Humidity", "WaterTemp", "WaterTemp", "Sun", "Leaks", "pH"]
                
                if self.currentUserGardens.count == 0 {
                    self.currentUserGardens.append(dummyGarden)
                } else {
                    self.currentUserGardens[0] = dummyGarden
                }
                
                if gardenNames.count == 0 {
                    gardenNames.append(String(self.currentUserGardens[0]["gardenName"]))
                } else {
                    gardenNames[0] = String(self.currentUserGardens[0]["gardenName"])
                }
                
                let dummyReading = Reading()
                dummyReading.readings = [85.0, 95.0, 60.0, 64.0, 15.0, 1.0, 5.2]
                let dummyReadings: [Reading] = [dummyReading]
                self.currentReadings = dummyReading.readings
                
                self.currentReadingValues = [85.0, 95.0, 60.0, 64.0, 15.0, 1.0, 5.2]
                
                if readingArrayArray.count == 0 {
                    readingArrayArray.append(dummyReadings)
                } else {
                    readingArrayArray[0][0].readings = self.currentReadingValues
                }
                
                if mainReadingValues.count == 0 {
                    mainReadingValues.append(self.currentReadingValues)
                } else {
                    mainReadingValues[0] = self.currentReadingValues
                }
                
                currentReadingTypes = ["AirTemp", "Humidity", "WaterTemp", "WaterTemp", "Sun", "Leaks", "pH"]
                customReadingTypes = currentReadingTypes
                
                if mainReadingTypes.count == 0 {
                    mainReadingTypes.append(customReadingTypes)
                } else {
                    mainReadingTypes[0] = customReadingTypes
                }
                
                if readingImageTypes.count == 0 {
                    readingImageTypes.append(currentReadingTypes)
                } else {
                    readingImageTypes[0] = currentReadingTypes
                }
                
                readingCreatedAt.append("the future?")
                if rowCount.count == 0 {
                    rowCount.append(self.currentReadingValues.count)
                } else {
                    rowCount[0] = (self.currentReadingValues.count)
                }
                self.tableView.reloadData()
            }
        }
    }
    
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
        
            chartViewController.readingLabels = customReadingTypes
            chartViewController.selectedReading = self.selectedReading
            chartViewController.selectedReadingIndex = self.selectedReadingIndex
            chartViewController.selectedGardenIndex = self.selectedGardenIndex
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
            readingType = ""
        }
        cell.readingType2ImageView.image = UIImage(named: String(UTF8String: readingType)!)
        
        
        
        if (indexPath.section < mainReadingTypes.count && indexPath.row < mainReadingTypes[indexPath.section].count) {
            cell.reading2Label.text = String(mainReadingTypes[indexPath.section][indexPath.row])
        } else {
            cell.reading2Label.text = "Please refresh..."
        }
        

        if (indexPath.section < mainReadingValues.count) {
            if (mainReadingValues[indexPath.section][indexPath.row] % 1 == 0) {
                cell.value2Label.text = String(Int(mainReadingValues[indexPath.section][indexPath.row]))
            } else {
                cell.value2Label.text = String(mainReadingValues[indexPath.section][indexPath.row])
            }
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
        //print("You selected cell #\(indexPath.row) in section \(indexPath.section)!")
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! ReadingTable2ViewCell
        
        self.selectedReading = currentCell.reading2Label.text!
        // Revert if fails - self.selectedReadingIndex = (self.currentGarden?.pName.indexOf(currentCell.reading2Label.text!))!
        //print("\(currentCell.reading2Label.text!)")
        
        self.selectedReadingIndex = (mainReadingTypes[(indexPath?.section)!].indexOf(currentCell.reading2Label.text!))!
        self.selectedGardenIndex = (indexPath?.section)!
        
        //print("Home selected Reading index is: \(self.selectedReadingIndex)")
        //print("Home selected Garden index is: \(self.selectedGardenIndex)")
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

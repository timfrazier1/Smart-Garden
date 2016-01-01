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

public var rowCount: Int = 0
public var currentReadingTypes: [String] = []
public var customReadingTypes: [String] = []

class ReadingsViewController: UIViewController {  //, TimelineComponentTarget {

    var defaultRange = 0...8
    var additionalRangeSize = 5

    @IBOutlet weak var tableView: UITableView!

    
    //var timelineComponent: TimelineComponent<Reading, ReadingsViewController>!
    
    
    // TODO items: 
    // [+] incorporate timeline component to allow for pull to refresh
    // [+] asynchronous loading of data (is this necessary)?
    // [+] User login page + linking user to garden
    // [+] Update settings view controller to allow for sensor names to be customized
    // [+] Settings view controller could also be 
    
    var readingArray: [Reading] = []
    var currentUserGardens: [Garden] = []
    var currentGarden: Garden?
    var currentReadings: Array<Array<Double>> = []
    var readingCreatedAt: String = ""
    
    var currentReadingValues: [Double] = []

    var selectedReading: String = ""
    var selectedReadingIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  timelineComponent = TimelineComponent(target: self)
        
        self.getGardenData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        
     //   timelineComponent.loadInitialIfRequired()
        
    }
    
    func getGardenData() {
        ParseHelper.gardenRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
            self.currentUserGardens = result as? [Garden] ?? []
            //print(self.currentUserGardens)
            if self.currentUserGardens != [] {
                self.currentGarden = self.currentUserGardens[0]   // **** Need to ensure that if a new user signs up this doesn't error out due to no gardens
                
                
                ParseHelper.readingsRequestForCurrentUser (self.currentGarden!, range: self.defaultRange) { (result: [PFObject]?, error: NSError?) -> Void in
                    
                    self.readingArray = result as? [Reading] ?? []
                    //print("Reading Array: \(self.readingArray)")
                    
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                    formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                    self.readingCreatedAt = formatter.stringFromDate(self.readingArray[0].createdAt!)
                    
                    
                    self.currentReadings = self.readingArray[0].readings
                    //print("Current Readings are: \(self.currentReadings)")
                    
                    currentReadingTypes = []
                    self.currentReadingValues = []
                    for i in 0..<self.currentReadings.count {
                        for j in 0..<self.currentReadings[i].count {
                            currentReadingTypes.append("\((self.currentGarden?.pName[i])!)\(j+1)")
                            //Revert if fails - self.currentReadingTypes.append((self.currentGarden?.pName[i])!)
                            self.currentReadingValues.append(self.currentReadings[i][j])
                        }
                    }
                    
                    rowCount = (self.currentReadingValues.count)
                    //print("The types are: \(currentReadingTypes)")
                    //print("The values are: \(self.currentReadingValues)")
                    
                    if NSUserDefaults.standardUserDefaults().objectForKey("customReadingTypes") != nil{
                        customReadingTypes = NSUserDefaults.standardUserDefaults().objectForKey("customReadingTypes") as! [String]
                    } else {
                        customReadingTypes = currentReadingTypes
                    }
                    
                    self.tableView.reloadData()
                }
                
            } else {
                let dummyGarden = Garden()
                dummyGarden.gardenName = "Example Garden"
                dummyGarden.gardenCity = "New Town"
                dummyGarden.pName = ["AirTemp","Humidity","WaterTemp","Sun","Leaks","pH"]
                
                
                self.currentGarden = dummyGarden
                
                
                self.currentReadings = [[85.0, 82.0], [95.0], [60.0, 64.0, 62.0], [15.0], [1.0], [5.0]]
                currentReadingTypes = ["AirTemp1", "AirTemp2", "Humidity1", "WaterTemp1", "WaterTemp2", "WaterTemp3", "Sun1", "Leaks1", "pH1"]
                self.currentReadingValues = [85.0, 82.0, 95.0, 60.0, 64.0, 62.0, 15.0, 1.0, 5.0]
                customReadingTypes = currentReadingTypes
                self.readingCreatedAt = "a long time ago..."
                rowCount = (self.currentReadingValues.count)
                
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
            //Revert if fails - chartViewController.readingLabels = (self.currentGarden?.pName)!
            chartViewController.readingLabels = customReadingTypes
            chartViewController.selectedReading = self.selectedReading
            chartViewController.selectedReadingIndex = self.selectedReadingIndex
            print("Segue selected Reading index is: \(chartViewController.selectedReadingIndex)")
        }

    }

    
}

extension ReadingsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        //return readings.count
        //return (self.currentGarden?.pName.count)!
        print("Row count = \(rowCount)")
        return rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCellWithIdentifier("Reading2Cell") as! ReadingTable2ViewCell
        print("Table view cell code reached")
        let readingType = currentReadingTypes[indexPath.row]
        var customReadingType = ""
        if customReadingTypes.count <= indexPath.row {
            customReadingType = readingType
        } else {
            customReadingType = customReadingTypes[indexPath.row]
        }
        
        // This hack makes the image displaying work for up to 9 sensors of the same type (e.g. only one integer digit after the type)
        let imageType = String(UTF8String: readingType)!
        cell.readingType2ImageView.image = UIImage(named: imageType[Range(start: imageType.startIndex, end: imageType.endIndex.advancedBy(-1))])
        // Revert if fail - cell.readingType2ImageView.image = UIImage(named: String(UTF8String: readingType)!)
        
        
        cell.reading2Label.text = String(customReadingType)
        cell.value2Label.text = String(self.currentReadingValues[indexPath.row])
        print("Current reading is \(String(readingType)) and the value is \(String(self.currentReadingValues[indexPath.row]))")
        return cell
        
    }
    
}

extension ReadingsViewController: UITableViewDelegate {
    
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
        
        headerCell.gardenName.text = self.currentGarden?.gardenName
        
        headerCell.createdAt.text = "Last reading at \(self.readingCreatedAt)"
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }

}

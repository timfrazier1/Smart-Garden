//
//  ReadingsViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/29/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import UIKit
import Parse

class ReadingsViewController: UIViewController {

    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet var table2View: UITableView!
    
    
    var readingArray: [Reading] = []
    var currentUserGardens: [Garden] = []
    var currentGarden: Garden?
    var currentReadings: Array<Array<Int>> = []
    var currentReadingTypes: [String] = []
    var currentReadingValues: [Int] = []
    var rowCount: Int = 0
    var selectedReading: String = ""
    var selectedReadingIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.gardenRequestForCurrentUser { (result: [PFObject]?, error: NSError?) -> Void in
            self.currentUserGardens = result as? [Garden] ?? []
            self.currentGarden = self.currentUserGardens[0]
            
            
            ParseHelper.readingsRequestForCurrentUser (self.currentGarden!) { (result: [PFObject]?, error: NSError?) -> Void in
                
                self.readingArray = result as? [Reading] ?? []
                self.currentReadings = self.readingArray[0].readings
                
                for i in 0..<self.currentReadings.count {
                    for j in 0..<self.currentReadings[i].count {
                        //self.currentReadingTypes.append("\((self.currentGarden?.pName[i])!)\(j+1)")
                        self.currentReadingTypes.append((self.currentGarden?.pName[i])!)
                        self.currentReadingValues.append(self.currentReadings[i][j])
                    }
                }
                
                self.rowCount = (self.currentReadingValues.count)
                //print("The types are: \(self.currentReadingTypes)")
                //print("The values are: \(self.currentReadingValues)")
                self.table2View.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "displayChart") {
            
            let chartViewController = segue.destinationViewController as! HistoryGraphViewController
            //let path = self.table2View.indexPathForSelectedRow!
            //print("Path = \(path)")
        
            chartViewController.readingArray = self.readingArray
            chartViewController.readingLabels = (self.currentGarden?.pName)!
            chartViewController.selectedReading = self.selectedReading
            chartViewController.selectedReadingIndex = self.selectedReadingIndex
            print("Segue selected Reading index is: \(chartViewController.selectedReadingIndex)")
        }
        
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

    
}

extension ReadingsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        //return readings.count
        //return (self.currentGarden?.pName.count)!
        return rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCellWithIdentifier("Reading2Cell") as! ReadingTable2ViewCell
        
        let readingType = self.currentReadingTypes[indexPath.row]
        
        cell.readingType2ImageView.image = UIImage(named: String(UTF8String: readingType)!)
        cell.reading2Label.text = String(readingType)
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
        self.selectedReadingIndex = (self.currentGarden?.pName.indexOf(currentCell.reading2Label.text!))!
        print("Home selected Reading index is: \(self.selectedReadingIndex)")
        performSegueWithIdentifier("displayChart", sender: self)
        
    }
}

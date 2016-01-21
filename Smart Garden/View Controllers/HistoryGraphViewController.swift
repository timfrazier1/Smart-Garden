//
//  HistoryGraphViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/29/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import Foundation
import UIKit
import Charts

class HistoryGraphViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var linkButton: UIButton!

    @IBAction func linkButtonTapped(sender: AnyObject) {
        
        let targetURL=NSURL(string: "http://thesmartgardenproject.com")
        let application=UIApplication.sharedApplication()
        
        application.openURL(targetURL!);
    }
    
    var readingLabels: [String] = []
    var selectedReading: String = ""
    var selectedReadingIndex: Int = 0
    var selectedGardenIndex: Int = 0
    var chartReadings: [Double] = []
    var chartTimes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkButton.hidden = true
        
        chartReadings = []
        chartTimes = []

        print("Selected reading index is: \(selectedReadingIndex)")
        print("Selected garden index is: \(selectedGardenIndex)")
        
        
        for i in 0..<readingArrayArray[selectedGardenIndex].count {  // For each row in the array of readings for the selected garden in the Parse Database

            chartReadings.append(readingArrayArray[selectedGardenIndex][i].readings[self.selectedReadingIndex])
            
            /***CONVERT FROM NSDate to String ****/
            if let date = readingArrayArray[selectedGardenIndex][i].createdAt { //get the time, in this case the time an object was created.
            //format date
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
                let dateString = dateFormatter.stringFromDate(date)
                // print(dateString) //prints out 10:12
                chartTimes.append(dateString)
            }
            
        }
        
        print("Chart readings are: \(self.chartReadings)")
        if self.chartReadings.count > 1 {
            
            setChart(self.chartTimes.reverse(), values: self.chartReadings.reverse(), description: "10 Most recent \(self.selectedReading) readings \nfor \(gardenNames[selectedGardenIndex])", label: self.selectedReading)
        } else {
            setChart([], values: [], description: "This is just an example garden! \nGet your own Smart Garden kit today at:", label: "")
            linkButton.hidden = false
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double], description: String, label: String) {
        lineChartView.noDataText = "No historical readings available"
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: label)
        chartDataSet.drawCubicEnabled = true
        chartDataSet.cubicIntensity = 0.1
        
        chartDataSet.lineWidth = 4
        
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.circleColors = [UIColor(red: 11/255, green: 82/255, blue: 33/255, alpha: 1)]
        chartDataSet.colors = [UIColor(red: 11/255, green: 82/255, blue: 33/255, alpha: 1)]
        chartDataSet.circleRadius = 5.0
        
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillColor = UIColor(red: 11/255, green: 150/255, blue: 33/255, alpha: 1)
        chartDataSet.fillAlpha = 1
        //chartDataSet.fillFormatter = nil
        
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        //lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        lineChartView.data = chartData
        lineChartView.descriptionText = description
        lineChartView.descriptionFont = UIFont(name: "System", size: 14)
        lineChartView.descriptionTextPosition = CGPointMake(self.view.center.x, self.view.center.y)
        
        lineChartView.descriptionTextAlign = NSTextAlignment.Center
        
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        lineChartView.descriptionTextPosition = CGPointMake(self.view.center.y, self.view.center.x)
        //getScreenSize()
    }
    
    /*
    var screenWidth:CGFloat=0
    var screenHeight:CGFloat=0
    func getScreenSize(){
        screenWidth=UIScreen.mainScreen().bounds.width
        screenHeight=UIScreen.mainScreen().bounds.height
        print("SCREEN RESOLUTION: "+screenWidth.description+" x "+screenHeight.description)
        print("Line chart center point: \(self.lineChartView.center.x) x \(self.lineChartView.center.y)")
        print("Text position: \(lineChartView.descriptionTextPosition!)")
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

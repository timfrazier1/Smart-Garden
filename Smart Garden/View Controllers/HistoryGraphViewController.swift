//
//  HistoryGraphViewController.swift
//  Smart Garden
//
//  Created by Tim Frazier on 11/29/15.
//  Copyright © 2015 FrazierApps. All rights reserved.
//

import UIKit
import Charts

class HistoryGraphViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    var readingLabels: [String] = []
    var readingArray: [Reading] = []
    var selectedReading: String = ""
    var selectedReadingIndex: Int = 0
    var chartReadings: [Double] = []
    var chartTimes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
*/
        //print("Reading Array is: \(readingArray)")
        chartReadings = []
        chartTimes = []
        print("Selected reading index is: \(selectedReadingIndex)")
        for i in 0..<readingArray.count {
            chartReadings.append(Double(readingArray[i].readings[selectedReadingIndex][0]))  // Currently only displays readings for the first sensor in a group!!!!
            
            /***CONVERT FROM NSDate to String ****/
            let date = readingArray[i].createdAt! //get the time, in this case the time an object was created.
            //format date
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
            let dateString = dateFormatter.stringFromDate(date)
            // print(dateString) //prints out 10:12
            chartTimes.append(dateString)
        }
        
        print("Chart readings are: \(self.chartReadings)")
        
        setChart(self.chartTimes.reverse(), values: self.chartReadings.reverse())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        lineChartView.noDataText = "No historical readings available"
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
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

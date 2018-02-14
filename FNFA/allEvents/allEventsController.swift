//
//  allEventsControllerViewController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 13/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class allEventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var modelController: ModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = 94
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (modelController?.events.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellAllEventsController
        
        // Configure the cell...
        let eventDict = modelController?.events[indexPath.row]
        
        cell.eventName.text = (eventDict?["name"] as! String)
        cell.eventCategory.text = (eventDict?["category"] as! String)
        
        let isFav = (eventDict?["isFav"] as! Bool)
        cell.accessoryType = (isFav) ? .checkmark : .none
        
        // Set hour event
        let dateIso = eventDict!["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        if let date = formatter.date(from: dateIso as! String) {
            cell.eventDate!.text = date.hourDate
        }
        
        // Set place event
        cell.eventPlaces!.text = (eventDict?["place"] as! [String]).joined(separator: ", ")
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if let eventDict = modelController?.events[indexPath.row] {
                let isFav = !(eventDict["isFav"] as! Bool)
                eventDict["isFav"] = isFav
                modelController?.saveJSON()
                cell.accessoryType = (isFav) ? .checkmark : .none
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

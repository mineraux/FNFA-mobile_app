//
//  TableViewController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 12/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var modelController: ModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (modelController?.events.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let eventDict = modelController?.events[indexPath.row]
        cell.textLabel?.text = (eventDict?["name"] as! String)
        cell.detailTextLabel?.text = (eventDict?["excerpt"] as! String)
        let isFav = (eventDict?["isFav"] as! Bool)
        cell.accessoryType = (isFav) ? .checkmark : .none
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if let eventDict = modelController?.events[indexPath.row]   {
                let isFav = !(eventDict["isFav"] as! Bool)
                eventDict["isFav"] = isFav
                modelController?.saveJSON()
                cell.accessoryType = (isFav) ? .checkmark : .none
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

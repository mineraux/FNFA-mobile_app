//
//  allEventsControllerViewController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 13/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class allEventsController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var singleFilter_sceance_spe: UIButton!
    @IBOutlet weak var singleFilter_volet_pro: UIButton!
    
    var modelController: ModelController?
    var filteredEvents = [NSMutableDictionary]()
    var activeFilters = [String]()
    var isFiltersHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // rowHeight = taille de la cellule + marge inter cellules = 90 + 12 + 12 = 114
        self.tableView.rowHeight = 114
        
        filteredEvents = (modelController?.events)!
        
        filterTrailingConstraint.constant = 320
        
        styleBtn(btn: singleFilter_sceance_spe)
        styleBtn(btn: singleFilter_volet_pro)
//        styleBtn(btn: singleFilter_seance_scolaire)
//        styleBtn(btn: singleFilter_compet)
        

    }
    
    
    func styleBtn(btn: UIButton!){
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 2
        btn.layer.borderColor = color_darkmauve.cgColor
        btn.setTitleColor(color_darkmauve, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellAllEventsController
        
        // Configure the cell...
        let eventDict = filteredEvents[indexPath.row]
        
        cell.eventThumbnail.layer.cornerRadius = 4
        cell.eventThumbnail.layer.masksToBounds = true
        
        cell.eventName.text = (eventDict["name"] as! String)
        cell.eventCategory.text = (eventDict["category"] as! String)
        cell.eventId = (eventDict["id"] as! Int)
        
        let isFav = (eventDict["isFav"] as! Bool)
//        cell.accessoryType = (isFav) ? .checkmark : .none
        
        // Set hour event
        let dateIso = eventDict["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        if let date = formatter.date(from: dateIso as! String) {
            cell.eventDate!.text = date.hourDate
        }
        
        cell.containerCell.layer.cornerRadius = 4
        cell.containerCell.layer.masksToBounds = true
        
        // Set place event
        cell.eventPlaces!.text = (eventDict["place"] as! [String]).joined(separator: ", ")
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let eventDict = filteredEvents[indexPath.row]
            let isFav = !(eventDict["isFav"] as! Bool)
            eventDict["isFav"] = isFav
            modelController?.saveJSON()
            cell.accessoryType = (isFav) ? .checkmark : .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @IBAction func onTouchFiltersBtn(_ sender: UIButton) {
        
        if let index = activeFilters.index(of: (sender.titleLabel?.text)!) {
            activeFilters.remove(at: index)
            sender.backgroundColor = .clear
            sender.setTitleColor(color_darkmauve, for: .normal)
            
        } else {
            activeFilters.append((sender.titleLabel?.text)!)
            sender.backgroundColor = color_darkmauve
            sender.setTitleColor(UIColor.white, for: .normal)
        }
    
        // Gestion du cas où plusieurs filtres sont sélectionnés
            filteredEvents = (modelController?.events)!
        for filter in activeFilters {
            filteredEvents = filteredEvents.filter { $0["category"] as? String == filter }
        }
            tableView.self.reloadData()
    }
    
    @IBAction func showFilters(_ sender: Any) {
        if isFiltersHidden {
            filterTrailingConstraint.constant = 0

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            filterTrailingConstraint.constant = 320

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }

        isFiltersHidden = !isFiltersHidden
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

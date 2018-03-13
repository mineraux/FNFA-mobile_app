//
//  allEventsControllerViewController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 13/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

// Permet de ne mettre que la 1ere lettre en majuscule
// meme si une string contient plusieurs mots
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}

class allEventsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @objc func daySelected(_ notification: Notification) {
        filteredEvents = (modelController?.events)!
        
        var title = ((button.titleLabel?.text)!).lowercased()
        filteredEvents = filteredEvents.filter { $0["startingDateDayNumber"] as? String == title }
        self.tableView.reloadData()
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var showFiltersBtn: UIButton!
    @IBOutlet weak var singleFilter_sceance_spe: UIButton!
    @IBOutlet weak var singleFilter_volet_pro: UIButton!
    
    @IBOutlet weak var closeFiltersBtn: UIButton!
    
    @IBOutlet weak var backToHome: UIStackView!
    
    var modelController: ModelController?
    var filteredEvents = [NSMutableDictionary]()
    var valueToPass: NSMutableDictionary?
    var activeFilters = [String]()
    
    // Dropdown stuff
    var button = dropDownBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(daySelected), name: .daySelected, object: nil)
        
        filteredEvents = (modelController?.events)!
        
        // rowHeight = taille de la cellule + marge inter cellules = 90 + 12 + 12 = 114
        self.tableView.rowHeight = 114
        
        // Valeur à animer pour deployer le volet des filtres
        filterTrailingConstraint.constant = 355
        
        // Styles btn show filters
        showFiltersBtn.layer.cornerRadius = 25
        showFiltersBtn.contentEdgeInsets = UIEdgeInsets(top: 17, left: 25, bottom: 17, right: 16)
        showFiltersBtn.setImage(UIImage(named:"filtersIco"), for: .normal)
        showFiltersBtn.imageEdgeInsets = UIEdgeInsets(top: 0,left: -13,bottom: 0,right: 0)
        
        // Styles btn close filters
        closeFiltersBtn.layer.cornerRadius = 25
        closeFiltersBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 86)
        
        // Styles btn filters
        styleBtn(btn: singleFilter_sceance_spe)
        styleBtn(btn: singleFilter_volet_pro)
        
        // Dropdown stuff
        button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: 65.0).isActive = true
        
        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 0).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //button.dropView.dropDownOptions = ["Hello", "Wass up"]
        
        for event in filteredEvents {
            
            let dateIso = event["startingDate"]
            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: dateIso as! String) {
                
                if button.dropView.dropDownOptions.contains((date.nameNumberDate).capitalized) {
                    
                } else {
                    button.dropView.dropDownOptions.append((date.nameNumberDate).capitalized)
                }
                
            }
        }
        
        button.setTitle(button.dropView.dropDownOptions[0], for: .normal)
    }
    
    func styleBtn(btn: UIButton!){
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 18
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor(named: "Black40")?.cgColor
        btn.setTitleColor(UIColor(named: "Black40"), for: .normal)
        btn.setTitle(btn.titleLabel?.text?.uppercased(), for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 17, bottom: 12, right: 17)
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
        let eventDict = filteredEvents[indexPath.row]
        
        cell.eventThumbnail.layer.cornerRadius = 4
        cell.eventThumbnail.layer.masksToBounds = true
        
        cell.eventName.text = (eventDict["name"] as! String)
        cell.eventCategory.text = (eventDict["category"] as! String).uppercased()
        cell.eventId = (eventDict["id"] as! Int)
        
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
        
        favIconeManager(indexPath: indexPath, addToFavBtn: cell.BtnAddToFav)
        
        return cell
    }
    
    // Gere quelle icone de favoris afficher pour chaque cell.
    // On utilise IndexPath pour être sur de cibler la bonne cellule
    // et ne pas avoir de problème lors du recyclage des cellules
    func favIconeManager(indexPath: IndexPath, addToFavBtn: UIButton) {
        let eventDict = filteredEvents[indexPath.row]
        if eventDict["isFav"] as! Bool == true {
            let image = UIImage(named: "heart_full")
            addToFavBtn.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "heart_empty")
            addToFavBtn.setImage(image, for: .normal)
        }
    }

    @IBAction func onTouchFiltersBtn(_ sender: UIButton) {
        
        let titleLowercased = sender.titleLabel?.text?.lowercased()
        let titleCapitalized = titleLowercased?.capitalizingFirstLetter()
        
        if let index = activeFilters.index(of: (titleCapitalized)!) {
            activeFilters.remove(at: index)
            sender.backgroundColor = .clear
            sender.setTitleColor(color_darkmauve, for: .normal)
            
        } else {
            activeFilters.append((titleCapitalized)!)
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
        filterTrailingConstraint.constant = 0

        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.tableView.alpha = 0.3
        })
    }
    
    @IBAction func closeFilters(_ sender: Any) {
        filterTrailingConstraint.constant = 355
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.tableView.alpha = 1
        })
    }
    
    // Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "test", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SingleEventController {
            destination.event = [filteredEvents[(tableView.indexPathForSelectedRow?.row)!]]
            print((tableView.indexPathForSelectedRow?.row)!)
            //print(destination.event)
        }
    }

}

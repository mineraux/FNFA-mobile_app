//
//  favoritesController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 14/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let reloadData = Notification.Name("reloadData")
}

class favoritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var modelController: ModelController?
    var dateUsed = [String]()
    var reperetitre = [Int]()
    let stackView = UIStackView()
    @IBOutlet weak var tableView: UITableView!
    var events = [NSMutableDictionary]()
    
    var dict4Avril = [NSMutableDictionary]()
    var dict5Avril = [NSMutableDictionary]()
    var dict6Avril = [NSMutableDictionary]()
    var dict7Avril = [NSMutableDictionary]()
    var dict8Avril = [NSMutableDictionary]()
    
    var sections = [[NSMutableDictionary]()]
    
    @objc func reloadData(_ notification: Notification) {
        
        refreshFav()
        
        if modelController?.getEventsInFav().count == 0 {
            stackView.isHidden = false
        } else {
            stackView.isHidden = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove border botton on navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Add background color for scroll bounce
        let bgView = UIView()
        bgView.backgroundColor = UIColor(named: "Gold")
        self.tableView.backgroundView = bgView
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = 114
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .reloadData, object: nil)
        
        //Image View
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 259.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 210.0).isActive = true
        imageView.image = UIImage(named: "visuel_wishlist_vide.png")
        
        //Text Label
        let textLabel = UILabel()
        textLabel.widthAnchor.constraint(equalToConstant: 259.0).isActive = true
        textLabel.numberOfLines = 0
        textLabel.text  = "Vous n'avez encore rien ajouté dans votre selection"
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.white
        
        //Stack View
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 16.0
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if modelController?.getEventsInFav().count == 0 {
            stackView.isHidden = false
        } else {
            stackView.isHidden = true
        }
        
        refreshFav()
    }
    
    // Rafraichit la tableView au chargement pour mettre à jour les favoris
    override func viewWillAppear(_ animated: Bool) {
        refreshFav()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellFavoritesController
        
        let day = sections[indexPath.section]
        let event = day[indexPath.row]
        
        cell.eventName.text = (event["name"] as! String)
        cell.eventCategory.text = (event["category"] as! String).uppercased()
        cell.eventPlace.text = (event["place"] as! [String]).joined(separator: ", ")
        
        let dateIso = event["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        if let date = formatter.date(from: dateIso as! String) {
            cell.eventDate!.text = date.hourDate
        }
        
        cell.containerCell.layer.cornerRadius = 4
        cell.containerCell.layer.masksToBounds = true
        
        cell.eventId = (event["id"] as! Int)
        
        cell.eventThumbnail.layer.cornerRadius = 4
        cell.eventThumbnail.layer.masksToBounds = true
        
        
        let image = UIImage(named: "heart_full")
        cell.isFavBtn.setImage(image, for: .normal)
        
        
        let imageName = String(describing:cell.eventId!)
        cell.eventThumbnail!.image = UIImage(named:imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(44)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        if sections[section].count > 0 {
            let stratingDate = sections[section][0]["startingDate"] as! String
            
            let dateIso = stratingDate
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            formatter.timeZone = TimeZone(identifier: "Europe/Paris")
            
            if let date = formatter.date(from: dateIso) {
                // jour (ex mercredi)
                headerView.nameDay.text = date.nameDate.uppercased()
                
                // numero + moi (ex 10 avril)
                headerView.numberMonthLabel.text = date.numberMonthDate
            }
        }

        return headerView
    }
    
    func refreshFav() {
        dict4Avril = (modelController?.getEventsInFav()
            .findBy(date: (modelController?.timestamp4Avril)!)?
            .sorted(by: .date))!
        
        dict5Avril = (modelController?.getEventsInFav()
            .findBy(date: (modelController?.timestamp5Avril)!)?
            .sorted(by: .date))!
        
        dict6Avril = (modelController?.getEventsInFav()
            .findBy(date: (modelController?.timestamp6Avril)!)?
            .sorted(by: .date))!
        
        dict7Avril = (modelController?.getEventsInFav()
            .findBy(date: (modelController?.timestamp7Avril)!)?
            .sorted(by: .date))!
        
        dict8Avril = (modelController?.getEventsInFav()
            .findBy(date: (modelController?.timestamp8Avril)!)?
            .sorted(by: .date))!
        
        sections = [dict4Avril, dict5Avril, dict6Avril, dict7Avril, dict8Avril]
        
        if dict4Avril.count == 0 {
            sections = sections.filter { $0 != dict4Avril }
        }
        
        if dict5Avril.count == 0 {
             sections = sections.filter { $0 != dict5Avril }
        }
        
        if dict6Avril.count == 0 {
             sections = sections.filter { $0 != dict6Avril }
        }
        
        if dict7Avril.count == 0 {
             sections = sections.filter { $0 != dict7Avril }
        }
        
        if dict8Avril.count == 0 {
             sections = sections.filter { $0 != dict8Avril }
        }
        
        tableView.reloadData()
    }
    
    // Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SingleEventController {
            
            let row = self.tableView.indexPathForSelectedRow?.row
            let section = self.tableView.indexPathForSelectedRow?.section
            
            destination.event = [sections[section!][row!]]
        }
    }
}

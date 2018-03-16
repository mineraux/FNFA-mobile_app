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
    
    
    
    @objc func reloadData(_ notification: Notification) {
        self.tableView.reloadData()
        
        dateUsed = []
        reperetitre = []
        
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
        stackView.spacing   = 16.0
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }
    
    // Rafraichit la tableView au chargement pour mettre à jour les favoris
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()

        // set le tableau vide pour le cas ou on change de view et qu'on revient sur les fav
        // (sinon le tableau est déjà rempli et les conditions qui définissent la taille de la cellule ne sont pas respectées)

        dateUsed = []
        reperetitre = []
        
        events = (modelController?.getEventsInFav())!
        
        if modelController?.getEventsInFav().count == 0 {
            stackView.isHidden = false
        } else {
            stackView.isHidden = true
        }
        
        let favEvents4Avril = (modelController?.events
            .findBy(date: (modelController?.timestamp4Avril)!)?
            .sorted(by: .date))!
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (modelController?.getEventsInFav().count)!
    }
    
    func tableView(_ tableView: UITableView, willendDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellFavoritesController
        let favDict = modelController?.getEventsInFav()[indexPath.row]
        
        for id in reperetitre {
            if (favDict?["id"] as! Int) == id {
                cell.tag = 2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellFavoritesController
        let favDict = modelController?.getEventsInFav()[indexPath.row]

        cell.eventName.text = (favDict?["name"] as! String)
        
        cell.eventCategory.text = (favDict?["category"] as! String).uppercased()
        cell.eventPlace!.text = (favDict?["place"] as! [String]).joined(separator: ", ")

        // Set hour event
        var dateIso = favDict!["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        self.tableView.rowHeight = 114
        cell.marginTopContainerCell.constant = 0

        if let date = formatter.date(from: dateIso as! String) {
            cell.eventDate!.text = date.hourDate
        }

        // Choppe la date de l'event
        if let date = formatter.date(from: dateIso as! String) {
            // jour (ex mercredi)
            let string = date.nameDate
            
            // numero + moi (ex 10 avril)
            let numberMonth = date.numberMonthDate
            
            if dateUsed.contains(string) {
            } else {
                dateUsed.append(string)
                reperetitre.append((favDict?["id"] as! Int))
            }
            
            cell.tag = 1
            for id in reperetitre {
                if (favDict?["id"] as! Int) == id {
                    cell.tag = 2
                }
            }
            
            if cell.tag == 2 {
                self.tableView.rowHeight = (114 + 58)
                cell.marginTopContainerCell.constant = 70
                
                // Montserrat regular 11
                let nameDayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 30))
                nameDayLabel.center = CGPoint(x: 80, y: 15)
                nameDayLabel.textAlignment = .left
                nameDayLabel.text = string.uppercased()
                nameDayLabel.textColor = UIColor(named: "Black40")
                nameDayLabel.font = UIFont(name: "Montserrat-Regular", size: 11)
                cell.addSubview(nameDayLabel)
                
                // Montserrat bold 24
                let numberMonthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 155, height: 30))
                numberMonthLabel.center = CGPoint(x: 60, y: 40)
                numberMonthLabel.textAlignment = .center
                numberMonthLabel.text = numberMonth
                numberMonthLabel.textColor = UIColor.white
                numberMonthLabel.font = UIFont(name: "Montserrat-Bold", size: 24)
                cell.addSubview(numberMonthLabel)
            } else {
                self.tableView.rowHeight = 114
                cell.marginTopContainerCell.constant = 0
            }
        }
        cell.containerCell.layer.cornerRadius = 4
        cell.containerCell.layer.masksToBounds = true

        cell.eventId = (favDict!["id"] as! Int)
    
        cell.eventThumbnail.layer.cornerRadius = 4
        cell.eventThumbnail.layer.masksToBounds = true
        
        let imageName = String(describing:cell.eventId!)
        cell.eventThumbnail!.image = UIImage(named:imageName)
        
        return cell
    }
    
    // Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "test", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SingleEventController {
            destination.event = [events[(tableView.indexPathForSelectedRow?.row)!]]
        }
    }

}

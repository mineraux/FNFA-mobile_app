//
//  favoritesController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 14/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class favoritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var modelController: ModelController?
    var dateUsed = [String]()
    var indexPrev: IndexPath = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = 114
    }
    
    // Rafraichit la tableView au chargement pour mettre à jour les favoris
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        // set le tableau vide pour le cas ou on change de view et qu'on revient sur les fav
        // (sinon le tableau est déjà rempli et les conditions qui définissent la taille de la cellule ne sont pas respectées)
        
        dateUsed = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (modelController?.getEventsInFav().count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellFavoritesController
        
        let favDict = modelController?.getEventsInFav()[indexPath.row]
        cell.eventName.text = (favDict?["name"] as! String)
        
        // Set hour event
        var dateIso = favDict!["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        
        
        if let date = formatter.date(from: dateIso as! String) {
            cell.eventDate!.text = date.hourDate
        }
        
//        dateIso = favDict?["startingDate"]
//        if let date = formatter.date(from: dateIso as! String) {
//            let string = date.nameDate
//            let numberMonth = date.numberMonthDate
//
//            if dateUsed.contains(string) {
//                self.tableView.rowHeight = 114
//            } else {
//                self.tableView.rowHeight = (114 + 58)
//                cell.marginTopContainerCell.constant = 70
//
//                dateUsed.append(string)
//
//                // Montserrat regular 11
//                let nameDayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 30))
//                nameDayLabel.center = CGPoint(x: 80, y: 15)
//                nameDayLabel.textAlignment = .left
//                nameDayLabel.text = string.uppercased()
//                nameDayLabel.textColor = UIColor(named: "Black40")
//                nameDayLabel.font = UIFont(name: "Montserrat-Regular", size: 11)
//                cell.addSubview(nameDayLabel)
//
//                // Montserrat bold 24
//                let numberMonthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 155, height: 30))
//                numberMonthLabel.center = CGPoint(x: 60, y: 40)
//                numberMonthLabel.textAlignment = .center
//                numberMonthLabel.text = numberMonth
//                numberMonthLabel.textColor = UIColor.white
//                numberMonthLabel.font = UIFont(name: "Montserrat-Bold", size: 24)
//                cell.addSubview(numberMonthLabel)
//            }
//        }
        
        cell.containerCell.layer.cornerRadius = 4
        cell.containerCell.layer.masksToBounds = true
        
        cell.eventId = (favDict!["id"] as! Int)
        
        var indexCurrent = indexPath
        test(indexPrev: indexCurrent, indexCurrent: indexPrev)
        indexPrev = indexPath
        
        return cell
    }
    
    func test(indexPrev: IndexPath, indexCurrent: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexCurrent) as! cellFavoritesController
        let prevCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPrev) as! cellFavoritesController
        print(cell.eventName.text)
        print(prevCell.eventName.text)
        print("______")
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

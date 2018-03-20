//
//  SingleEventTableViewController.swift
//  FNFA
//
//  Created by Robin Minervini on 18/03/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit
import UserNotifications

class SingleEventTableViewController: UITableViewController {
    
    @IBOutlet weak var eventThumbnail: UIImageView!
    @IBOutlet weak var eventCategory: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventExerpt: UILabel!
    @IBOutlet weak var eventAuthor: UILabel!
    @IBOutlet weak var favIcon: UIButton!
    @IBOutlet weak var typePublic: UILabel!
    
    @IBOutlet weak var eventDuration: UILabel!
    
    @IBOutlet weak var linkToSingleEvent: UIView!
    
    @IBOutlet weak var eventNameTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var linkToSiteTopConstraint: NSLayoutConstraint!
    
    var modelController: ModelController?
    
    var event = [NSMutableDictionary]()
    
    var currentEvent: NSMutableDictionary!
    
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        currentEvent = event[0]
        
        // Categorie de l'evenement
        eventCategory.text = (currentEvent["category"] as! String).uppercased()
        
        // Nom de l'evenement
        eventName.text = (currentEvent["name"] as! String)
        
        eventId = currentEvent["id"] as! Int
        
        // Date de l'evenement
        let dateIso = currentEvent["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        if let date = formatter.date(from: dateIso as! String) {
            eventDate.text =  date.hourDate
        }
        
        // Lieux de l'evenement
        eventPlace.text = (currentEvent["place"] as! [String]).joined(separator: ", ")
        
        // Description de l'evenement
        eventExerpt.text = (currentEvent["excerpt"] as! String)
        
        // Définir la durée de l'evenement
        var isoDate = currentEvent["startingDate"]!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateRangeStart = dateFormatter.date(from: isoDate as! String)!
        
        isoDate = currentEvent["endingDate"]!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateRangeEnd = dateFormatter.date(from: isoDate as! String)!
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: dateRangeStart, to: dateRangeEnd)
        
        let hour = String(describing: components.hour ?? 0)
        let minutes = String(describing: components.minute ?? 0)
        let eventDurationString = hour + " h " + minutes
        eventDuration.text = eventDurationString
        
        if (currentEvent["author"] as! String).count > 0 {
            eventAuthor.text = (currentEvent["author"] as! String) + " | " + (currentEvent["producer"] as! String)
        } else {
            eventAuthor.text = (currentEvent["author"] as! String)
        }
        
        let eventID = currentEvent["id"] as! Int
        let imageName = String(describing:eventID)
        
        eventThumbnail.image = UIImage(named:imageName)
        
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: eventThumbnail.frame.size.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        eventThumbnail.addSubview(overlay)
        
        if (currentEvent["age"] as! Int) > 0 {
            typePublic.isHidden = false
            typePublic.text = "enfants".uppercased() + " (\(currentEvent["age"]!) ans)"
        } else {
            typePublic.isHidden = true
        }
        
        tableView.allowsSelection = false
        
         //Redirection vers le site
                let gesture = UITapGestureRecognizer(target: self, action: #selector(redirectToWebsite))
                linkToSingleEvent.addGestureRecognizer(gesture)
    }
    
    @objc func redirectToWebsite() {
        if let url = URL(string: currentEvent["link"] as! String) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if currentEvent["isFav"] as! Bool == true {
            let image = UIImage(named: "heart_full")
            favIcon.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "heart_empty")
            favIcon.setImage(image, for: .normal)
        }
        
        // Gere le cas ou le type de public n'est pas renseigné
        if typePublic.text != "ENFANTS" {
            eventNameTopConstraint.constant = 0
        } else {
            eventNameTopConstraint.constant = 20
        }
        
        if eventAuthor.text == "" {
            linkToSiteTopConstraint.constant = 0
        } else {
            linkToSiteTopConstraint.constant = 30
        }
        
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        
        let events = modelController?.events
        
        for event in events! {
            if (event["id"] as! Int) == eventId {
                if (event["isFav"] as! Bool) == false {
                    let eventDateIso = event["startingDate"] as! String
                    timedNotification(date: eventDateIso) { (success) in
                        if success {
                            print("Successfully Notified")
                        }
                    }
                } else {
                    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                        var identifiers: [String] = []
                        for notification:UNNotificationRequest in notificationRequests {
                            if notification.identifier == "customNotification\(String(describing: self.eventId))" {
                                identifiers.append(notification.identifier)
                            }
                        }
                        print("customNotification\(String(describing: self.eventId)) canceled")
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                    }
                }
            }
        }
        
        modelController?.addToFavWithId(eventId: currentEvent["id"] as! Int)
        if currentEvent["isFav"] as! Bool == true {
            let image = UIImage(named: "heart_full")
            favIcon.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "heart_empty")
            favIcon.setImage(image, for: .normal)
        }
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.favIcon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.favIcon.transform = CGAffineTransform.identity
                }
        })
    }
    
    func timedNotification(date: String, completion: @escaping (_ Success: Bool) -> ()) {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        let updatedAt = formatter.date(from: date)!
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: updatedAt)
        components.hour? -= 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Festival national du film d'animation"
        content.subtitle = "Un de vos programme favoris va bientôt commencer."
        content.body = "\(eventName.text!) commence dans 1h. Rendez vous ici : \(eventPlace.text!)"
        
        let request = UNNotificationRequest(identifier: "customNotification\(String(describing: eventId))", content:content, trigger:trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

}

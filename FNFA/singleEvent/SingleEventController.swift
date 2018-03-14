//
//  SingleEventController.swift
//  FNFA
//
//  Created by Robin Minervini on 25/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class SingleEventController: UIViewController {
    
    @IBOutlet weak var eventThumbnail: UIImageView!
    @IBOutlet weak var eventCategory: UILabel!
    @IBOutlet weak var eventTypePublic: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventExerpt: UILabel!
    @IBOutlet weak var eventAuthor: UILabel!
    @IBOutlet weak var isFav: UIImageView!
    @IBOutlet weak var eventDuration: UILabel!
    
    var event = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let currentEvent = event[0]

        // Categorie de l'evenement
        eventCategory.text = (currentEvent["category"] as! String).uppercased()

        // Nom de l'evenement
        eventName.text = (currentEvent["name"] as! String)

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

        // Définir si l'evenement est en favoris pour determiner quel coeur afficher
        if currentEvent["isFav"] as! Bool == true {
            let image = UIImage(named: "heart_full")
            isFav.image = image
        } else {
            let image = UIImage(named: "heart_empty")
            isFav.image = image
        }

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
        var eventDurationString = hour + " h " + minutes
        eventDuration.text = eventDurationString

        if (currentEvent["author"] as! String).count > 0 {
            eventAuthor.text = (currentEvent["author"] as! String) + " | " + (currentEvent["producer"] as! String)
        } else {
            eventAuthor.text = currentEvent["author"] as! String
        }
        
        let eventID = currentEvent["id"] as! Int
        let imageName = String(describing:eventID)
        
        eventThumbnail.image = UIImage(named:imageName)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

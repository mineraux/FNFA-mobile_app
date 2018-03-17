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
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventExerpt: UILabel!
    @IBOutlet weak var eventAuthor: UILabel!
    @IBOutlet weak var favIcon: UIButton!
    @IBOutlet var scroller: UIScrollView!
    @IBOutlet weak var typePublic: UILabel!
    
    @IBOutlet weak var eventDuration: UILabel!
    
    @IBOutlet weak var linkToSingleEvent: UIView!
    
    @IBOutlet weak var eventNameTopConstraint: NSLayoutConstraint!
    
    var modelController: ModelController?
    
    var event = [NSMutableDictionary]()
    
    var currentEvent: NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroller.contentSize = CGSize(width: scroller.contentSize.width, height: 700)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        currentEvent = event[0]

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
            typePublic.text = "enfants".uppercased()
        } else {
            typePublic.isHidden = true
        }
        
        // Redirection vers le site
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
        
        print(typePublic.text!.count)
        
        // Gere le cas ou le type de public n'est pas renseigné
        if typePublic.text != "ENFANTS" {
            eventNameTopConstraint.constant = 0
        } else {
            eventNameTopConstraint.constant = 20
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        //modelController?.addToFavs(filteredEvents: event, eventId: currentEvent["id"] as! Int, BtnAddToFav: favIcon)
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
    
}

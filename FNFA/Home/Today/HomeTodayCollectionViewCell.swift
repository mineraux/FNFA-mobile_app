//
//  HomeTodayCollectionViewCell.swift
//  FNFA
//
//  Created by Alexandre Massé on 16/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit
import UserNotifications

extension UITableViewCell: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

class HomeTodayCollectionViewCell: UICollectionViewCell {
    
    var modelController: ModelController?
    var eventId: Int?
    var filteredEvents = [NSMutableDictionary]()
    
    @IBOutlet weak var eventCategory: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        filteredEvents = (modelController?.getEventsByDate(events: (modelController?.events)!, date: "mercredi 4"))!   
    }
    
    @IBAction func favAction(_ sender: Any) {
        
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
                        print("customNotification\(String(describing: self.eventId!)) canceled")
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                    }
                }
            }
        }
        
        modelController?.addToFavs(filteredEvents: filteredEvents, eventId: eventId!, BtnAddToFav: favButton)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.favButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.favButton.transform = CGAffineTransform.identity
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
        
        let request = UNNotificationRequest(identifier: "customNotification\(String(describing: eventId!))", content:content, trigger:trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

//
//  cellFavoritesController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 14/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit
import UserNotifications

class cellFavoritesController: UITableViewCell {
    
    @IBOutlet weak var eventThumbnail: UIImageView!
    @IBOutlet weak var eventCategory: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var containerCell: UIView!
    @IBOutlet weak var isFavBtn: UIButton!
    @IBOutlet weak var marginTopContainerCell: NSLayoutConstraint!
    
    var modelController: ModelController?
    var filteredEvents = [NSMutableDictionary]()
    var eventId: Int?
    var currentEvent = [NSMutableDictionary]()
    var favEvents = [NSMutableDictionary]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        favEvents = (modelController?.getEventsInFav())!
        filteredEvents = (modelController?.events)!
        
        
        let image = UIImage(named: "heart_full")
        isFavBtn.setImage(image, for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func removeFav(_ sender: Any) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "customNotification" {
                    identifiers.append(notification.identifier)
                }
            }
            print("customNotification\(String(describing: self.eventId!)) canceled")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        
        modelController?.addToFavs(filteredEvents: filteredEvents, eventId: eventId!, BtnAddToFav: isFavBtn)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.isFavBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.isFavBtn.transform = CGAffineTransform.identity
                }
        })
    }
}

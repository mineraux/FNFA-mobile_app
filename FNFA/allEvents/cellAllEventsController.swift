//
//  cellAllEventsController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 13/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class cellAllEventsController: UITableViewCell {

    @IBOutlet weak var eventThumbnail: UIImageView!
    @IBOutlet weak var eventCategory: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPlaces: UILabel!
    @IBOutlet weak var containerCell: UIView!
    @IBOutlet weak var BtnAddToFav: UIButton!
    
    var modelController: ModelController?
    var eventId: Int?
    var filteredEvents = [NSMutableDictionary]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        filteredEvents = (modelController?.events)!
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addToFav(_ sender: Any) {
        for event in filteredEvents {
            if event["id"] as! Int == eventId {
                    let isFav = !(event["isFav"] as! Bool)
                    event["isFav"] = isFav
                    modelController?.saveJSON()
                if event["isFav"] as! Bool == true {
                    let image = UIImage(named: "heart_full")
                    self.BtnAddToFav.setImage(image, for: .normal)
                } else {
                    let image = UIImage(named: "heart_empty")
                    self.BtnAddToFav.setImage(image, for: .normal)
                }
                break
            }
        }
    }
}

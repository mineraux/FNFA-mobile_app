//
//  cellFavoritesController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 14/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

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
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

    @IBAction func removeFav(_ sender: Any) {
        modelController?.removeOfFavs(eventId: eventId!)
        
//        UIView.animate(
//            withDuration: 0.2,
//            animations: {
//                self.isFavBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        },
//            completion: { _ in
//                UIView.animate(withDuration: 0.2) {
//                    self.isFavBtn.transform = CGAffineTransform.identity
//                }
//        })
    }
}

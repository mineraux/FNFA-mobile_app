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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

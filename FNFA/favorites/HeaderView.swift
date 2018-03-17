//
//  HeaderView.swift
//  FNFA
//
//  Created by Robin Minervini on 17/03/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class HeaderView: UITableViewCell {

    @IBOutlet weak var nameDay: UILabel!
    @IBOutlet weak var numberMonthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

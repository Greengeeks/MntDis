//
//  EquipmentTableViewCell.swift
//  Riding
//
//  Created by Andrea Pellegrin on 16/11/2019.
//  Copyright © 2019 Andrea Pellegrin. All rights reserved.
//

import UIKit

class EquipmentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewO: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

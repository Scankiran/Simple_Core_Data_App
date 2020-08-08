//
//  InformationCell.swift
//  saglikOlsun
//
//  Created by Furkan on 18.04.2020.
//  Copyright © 2020 Furkan Ibili. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  TableCell.swift
//  saglikOlsun
//
//  Created by Furkan on 12.04.2020.
//  Copyright © 2020 Furkan Ibili. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    @IBOutlet var `case`: UILabel!
    @IBOutlet var recovered: UILabel!
    @IBOutlet var death: UILabel!
    @IBOutlet var country: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

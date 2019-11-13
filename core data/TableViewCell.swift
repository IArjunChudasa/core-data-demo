//
//  TableViewCell.swift
//  core data
//
//  Created by admin on 13/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

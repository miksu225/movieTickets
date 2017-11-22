//
//  showsListTableViewCell.swift
//  movieTickets
//
//  Created by Koulutus on 20.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class showsListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelShowStartDay: UILabel!
    @IBOutlet weak var labelShowStartTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  movieTableViewCell.swift
//  movieTickets
//
//  Created by Koulutus on 15.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class movieTableViewCell: UITableViewCell {


    @IBOutlet weak var labelMovie: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelTheater: UILabel!
    @IBOutlet weak var labelSeatsLeft: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

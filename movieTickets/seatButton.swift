//
//  seatButton.swift
//  movieTickets
//
//  Created by Koulutus on 29.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class seatButton: UIButton {

    var fillColor : UIColor = UIColor.green
    var borderColor : UIColor = UIColor.green
    
    


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        fillColor.setFill()
        path.fill()
        borderColor.setStroke()
        path.stroke()
        
    }
    
   
    
    

}

//
//  seatNavigationController.swift
//  movieTickets
//
//  Created by Koulutus on 11.1.2018.
//  Copyright © 2018 MikkoS. All rights reserved.
//

import UIKit

class seatNavigationController: UINavigationController {
    
    var passedshow : Show = Show(showid: 0, theater: Theater(theaterid: 0, name: "", seatstotal: 0), startday: "", starttime: "", endtime: "", seatstaken: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       let vc = self.childViewControllers.first as! seatSelectViewController
        
        vc.show = passedshow;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("seatnavigaation prepare")
        let target = segue.destination as! seatSelectViewController
        
        target.show = passedshow
    }*/
    

}

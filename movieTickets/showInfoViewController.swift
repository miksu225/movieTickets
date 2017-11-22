//
//  showInfoViewController.swift
//  movieTickets
//
//  Created by Koulutus on 22.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class showInfoViewController: UIViewController {
    
    let db = Db.shared()
    var show : Show = Show(theaterid: 0, startday: "", starttime: "", endtime: "")

    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBAction func rewindToMovieInfo(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelStartDate.text = show.startday
        labelStartTime.text = show.starttime
        labelEndTime.text = show.endtime
        
        if db.exists() {
            if db.open() {
                
                //let resulttest : FMResultSet = db.selecttest()!
            }
            db.close()
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

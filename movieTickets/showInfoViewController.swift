//
//  showInfoViewController.swift
//  movieTickets
//
//  Created by Koulutus on 22.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class showInfoViewController: UIViewController {
    
    //let db = Db.shared()
    let db = Db("moviedatabase.db")
    var show : Show = Show(showid: 0, theater: Theater(theaterid: 0, name: "", seatstotal: 0), startday: "", starttime: "", endtime: "", seatstaken: 0)
    var theater : Theater = Theater(theaterid: 0, name: "", seatstotal: 0)
    var seatsleft : Int = 0

    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBOutlet weak var labelSeatsTotal: UILabel!
    @IBOutlet weak var labelSeatsLeft: UILabel!
    @IBAction func rewindToMovieInfo(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if db.exists() {
            if db.open() {
                let resultset : FMResultSet = db.selectstatement(sqlstatement: "select * from theaters where theaterid = \(show.theater.theaterid)")!
                
                while resultset.next() {
                    theater.theaterid = Int(resultset.int(forColumn: "theaterid"))
                    theater.name = resultset.string(forColumn: "name")!
                    theater.seatstotal = Int(resultset.int(forColumn: "seatstotal"))
                }
                
                
                let resultset2 : FMResultSet = db.selectstatement(sqlstatement: "select count(showid) as seatstaken from tickets where showid = \(show.showid)")!
                
                while resultset2.next() {
                    seatsleft = theater.seatstotal - Int(resultset2.int(forColumn: "seatstaken"))
                }
                
            }
            db.close()
        }
        
        labelStartDate.text = show.startday
        labelStartTime.text = show.starttime
        labelEndTime.text = show.endtime
        labelSeatsTotal.text = String(theater.seatstotal)
        labelSeatsLeft.text = String(seatsleft)
        
        
        
        

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

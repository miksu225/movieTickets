//
//  showInfoViewController.swift
//  movieTickets
//
//  Created by Koulutus on 22.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class showInfoViewController: UIViewController {
    
    let db = Db.shared()
    let signs = Signs()
    
    var show : Show = Show(showid: 0, theater: Theater(theaterid: 0, name: "", seatstotal: 0), startday: "", starttime: "", endtime: "", seatstaken: 0)
   
    var seatsleft : Int = 0

    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBOutlet weak var labelSeatsTotal: UILabel!
    @IBOutlet weak var labelSeatsLeft: UILabel!
    
    @IBAction func unwindToMovieInfo(_ sender: UIStoryboardSegue) {
        labelSeatsLeft.text = String(show.theater.seatstotal - show.seatstaken)
    }
    
    @IBAction func SeatSelectPressed(_ sender: UIButton) {
        var ncID = ""
        
        if show.theater.seatstotal == 90 {
            ncID = "idNavController90"
        }
        else if show.theater.seatstotal == 120 {
            ncID = "idNavController120"
        }
        else if show.theater.seatstotal == 50 {
            ncID = "idNavController50"
        }
        else {
            //use 90 as default
            ncID = "idNavController90"
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: ncID) as! seatNavigationController
        nc.passedshow = show
        self.present(nc, animated:true, completion:nil)
    }
    
    
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        
        signs.signOut(self.storyboard)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if db.exists() {
            if db.open() {
                let resultset : FMResultSet = db.selectstatement(sqlstatement: "select * from theaters where theaterid = \(show.theater.theaterid);")!
                
                while resultset.next() {
                    show.theater.theaterid = Int(resultset.int(forColumn: "theaterid"))
                    show.theater.name = resultset.string(forColumn: "name")!
                    show.theater.seatstotal = Int(resultset.int(forColumn: "seatstotal"))
                }
                
                
                let resultset2 : FMResultSet = db.selectstatement(sqlstatement: "select count(showid) as seatstaken from tickets where showid = \(show.showid)")!
                
                while resultset2.next() {
                    seatsleft = show.theater.seatstotal - Int(resultset2.int(forColumn: "seatstaken"))
                }
                
            }
            db.close()
        }
        
        labelStartDate.text = show.startday
        labelStartTime.text = show.starttime
        labelEndTime.text = show.endtime
        labelSeatsTotal.text = String(show.theater.seatstotal)
        labelSeatsLeft.text = String(seatsleft)
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

   /* // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("showInfo prepare")
        let target = segue.destination as! seatNavigationController
        
        target.passedshow = show
        
    }
    */

}

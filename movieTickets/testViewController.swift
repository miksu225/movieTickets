//
//  testViewController.swift
//  movieTickets
//
//  Created by Koulutus on 14.12.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    // yksi insert toimii
    // kaksi inserttiä, eka toimii
    // yksi insertti ja yksi selecti, eka selecti toimii
    // kaksi selectiä yhden open/closen välissä, molemmat toimii
    // kaksi selectiä erillisten open/closen välissä, ensimmäinen toimii
    
    let db = Db.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if db.exists() {
            if db.open() {
                print("resultset1")
                let resultset : FMResultSet = db.selectstatement(sqlstatement: "select * from tickets where showid = 1;")!
                
                while resultset.next() {
                    print(resultset.int(forColumn: "ticketid"))
                }
                
            }
            db.close()
        }
        
        if db.exists() {
            if db.open() {
                print(db.dbpath)
                print("resultset2")
                let resultset2 : FMResultSet = db.selectstatement(sqlstatement: "select * from tickets where showid = 2;")!
                
                while resultset2.next() {
                    print(resultset2.int(forColumn: "ticketid"))
                }
            }
            db.close()
        }
      /*  if db.exists() {
            if db.open() {
                print("eka insert")
                db.runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (1, 3, 9, 1);")
            }
            db.close()
        }

        if db.exists() {
            if db.open() {
                print("toka insert")
                db.runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (1, 3, 9, 1);")
            }
            db.close()
        }*/
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

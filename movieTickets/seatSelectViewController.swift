//
//  seatSelectViewController.swift
//  movieTickets
//
//  Created by Koulutus on 28.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class seatSelectViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let db = Db.shared()
    //let db = Db("moviedatabase.db")
    var seats : [Seat] = []
     var show : Show = Show(showid: 0, theater: Theater(theaterid: 0, name: "", seatstotal: 0), startday: "", starttime: "", endtime: "", seatstaken: 0)
    

    @IBAction func rewindToShowInfo(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
     func saveSeat() {
        let selectedSeats = getSelectedSeats()
        //print("valmistaudutaan")
        if db.exists() {
           
            //print("olemassa")
            if db.open() {
                
                print("avataan")
                for seat in selectedSeats {
                    print(show.showid)
                    print(seat.seatnumber)
                    print(seat.seatrow)
                    db.runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (\(show.showid), \(seat.seatnumber), \(seat.seatrow), 1);")
                    //print("lisätään")
                }
                
            }
            db.close()
        }
        print("seatstaken: " + String(show.seatstaken))
        show.seatstaken += 1;
        print("seatstaken: " + String(show.seatstaken))
        getSeatsTaken()
    }
    
    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seatButtonPressed(_ sender: seatButton) {
        print("seat pressed")
        print("seatstotal: " + String(show.theater.seatstotal))
        print("id: " + String(show.showid))
       /* if sender.backgroundColor == UIColor.green {
            sender.backgroundColor = UIColor.yellow
        }
        else if sender.backgroundColor == UIColor.yellow{
            sender.backgroundColor = UIColor.green
        }*/
        
        // when selecting new seat, go through all rowviews and seatButtons and change color back to green if seat is selected (color orange) and it is not already taken (color red)
        //using UIViews as rows
        /*if sender.fillColor != UIColor.red {
            for view in self.view.subviews {
                //find UIViews (rows)
                if let rowview = view as? UIView {
                    for button in rowview.subviews {
                        //find seatButtons
                        if let seat = button as? seatButton {
                            if seat != sender {
                                if seat.fillColor == UIColor.orange{
                                    seat.fillColor = UIColor.green
                                    seat.borderColor = UIColor.green
                                    seat.setNeedsDisplay()
                                }
                            }
                        }
                    }
                }
                
            }
        }*/
        
        // when selecting new seat, go through all rowviews and seatButtons and change color back to green if seat is selected (color orange) and it is not already taken (color red)
        //using StackViews as rows
        if sender.fillColor != UIColor.red {
            for view in self.view.subviews {
                //find StackViews (rows)
                if let rowstack = view as? UIStackView {
                    for button in rowstack.subviews {
                        //find seatButtons
                        if let seat = button as? seatButton {
                            if seat != sender {
                                if seat.fillColor == UIColor.orange{
                                    seat.fillColor = UIColor.green
                                    seat.borderColor = UIColor.green
                                    seat.setNeedsDisplay()
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
        if  sender.fillColor != UIColor.red {
            if sender.fillColor == UIColor.green{
                sender.fillColor = UIColor.orange
                sender.borderColor = UIColor.orange
            }
            else{
                sender.fillColor = UIColor.green
                sender.borderColor = UIColor.green
            }
        }
        
        
        sender.setNeedsDisplay()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // using UIViews as rows
        /*for view in self.view.subviews {
            //find UIViews (rows)
            if let rowview = view as? UIView {
                for button in rowview.subviews {
                    //find seatButtons
                    if let seat = button as? seatButton {
                        seats.append(Seat(seat: seat, seatnumber: Int(seat.currentTitle!)!, seatrow: (seat.superview?.tag)!))
                    }
                }
            }
            
        }*/
        
        //using stackviews as rows
        for view in self.view.subviews {
            //find StackViews (rows)
            if let rowstack = view as? UIStackView {
                for button in rowstack.subviews {
                    // find seatButtons
                    if let seat = button as? seatButton {
                        seats.append(Seat(seat: seat, seatnumber: Int(seat.currentTitle!)!, seatrow: (seat.superview?.tag)!))
                    }
                    
                }
            }
        }
        getSeatsTaken()
        
    }
    
    func getSelectedSeats () -> [Seat] {
        var selectedSeats : [Seat] = []
        for seat in seats {
            if seat.seat.fillColor == UIColor.orange {
                selectedSeats.append(seat)
            }
        }
        
        return selectedSeats
    }
    
    func getSeatsTaken() {
        
        if db.exists() {
            if db.open() {
                let resultset : FMResultSet = db.selectstatement(sqlstatement: "select * from tickets where showid = \(show.showid)")!
                
                while resultset.next() {
                    // filter through all seats and return array with seats that has specific
                    //seat and seatrow values (values from each resultset row)
                    var seat = seats.filter({ $0.seatnumber == resultset.int(forColumn: "seat") && $0.seatrow == resultset.int(forColumn: "seatrow") })
                    
                    seat[0].seat.fillColor = UIColor.red
                    seat[0].seat.borderColor = UIColor.red
                    seat[0].seat.setNeedsDisplay()
                }
            }
            
            db.close()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            NSLog("Not a save button")
            return
        }
        saveSeat()
        
        let target = segue.destination as! showInfoViewController
        
        target.show = show
    }
    

}

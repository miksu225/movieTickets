//
//  ViewController.swift
//  movieTickets
//
//  Created by Koulutus on 8.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var db : Db = Db.init(dbname: "moviedatabase.db")
    
    /*
     
     create table if not exists movies (movieid integer primary key autoincrement, name text);
     
     create table if not exists shows (showid integer primary key autoincrement, movieid integer, startday text, starttime text, endtime text, foreign key (movieid) references movies (movieid));
     
     create table if not exists theaters (theaterid integer primary key autoincrement, name text,
     seatstotal integer);
     
     create table if not exists tickets (ticketid integer primary key autoincrement, showid integer, userid integer, foreign key (showid) references shows (showid));
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("aloitetaan")
        
        if !db.exists() {
            if db.open() {
                print("db auki")
                db.runstatement(sqlstatement: "create table if not exists movies (movieid integer primary key autoincrement, name text);")
                
                db.runstatement(sqlstatement: "create table if not exists shows (showid integer primary key autoincrement, movieid integer, startday text, starttime text, endtime text, foreign key (movieid) references movies (movieid));")
                
                db.runstatement(sqlstatement: "create table if not exists theaters (theaterid integer primary key autoincrement, name text, seatstotal integer);")
                
                db.runstatement(sqlstatement: "create table if not exists tickets (ticketid integer primary key autoincrement, showid integer, userid integer, foreign key (showid) references shows (showid));")
                
                print("taulut luotu")
            }
            db.close()
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


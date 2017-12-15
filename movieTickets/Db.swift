//
//  db.swift
//  movieTickets
//
//  Created by Koulutus on 8.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import Foundation

class Db {
    private static let sharedDB = Db("moviedatabase.db")
    var dbname : String
    var dbpath : String
    private var connectiontoFMDB : FMDatabase
    
    
    
      init(_ dbname: String) {
        NSLog("INITOIDAAN!!!!")
         self.dbname = dbname
        let pathdummy = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        self.dbpath = pathdummy[0].appendingPathComponent(dbname).path
        NSLog(dbpath)
        self.connectiontoFMDB = FMDatabase(path: dbpath)
        NSLog("db init debug test: " + connectiontoFMDB.debugDescription)
        if !exists() {
            if connectiontoFMDB.open() {
                createTablesAndData()
            }
            connectiontoFMDB.close()
           
        }
        
 
    }
    
    class func shared() -> Db {
        return sharedDB
    }
    
    func exists() -> Bool {
        if FileManager.default.fileExists(atPath: dbpath) {
            print("exists")
            return true
        }
        else {
            print("not exists")
            return false
        }
    }
    func open() -> Bool {
        if connectiontoFMDB == FMDatabase(path: dbpath) {
            print("yhteys on olemassa")
        }
        else {
            print("yhteys ei ole olemassa")
            print("luodaan uusi yhteys")
            connectiontoFMDB = FMDatabase(path: dbpath)
        }
        
        if connectiontoFMDB.open() {
            print("database open")
            return true
        }
        else {
            print("database not open")
            return false
        }
    }
    
    func close() {
        connectiontoFMDB.close()
    }
    
    func runstatement(sqlstatement: String) {
        NSLog("nslog test: " + connectiontoFMDB.debugDescription)
        NSLog(sqlstatement)
        connectiontoFMDB.executeStatements(sqlstatement)
        
         NSLog(connectiontoFMDB.debugDescription)
    }
    
    func selectstatement(sqlstatement: String) -> FMResultSet? {
        let resultset : FMResultSet? = connectiontoFMDB.executeQuery(sqlstatement, withArgumentsIn: [])
        NSLog(connectiontoFMDB.debugDescription)
        //NSLog(connectiontoFMDB.lastErrorMessage())
        
        return resultset
    }
    
    func selecttest() -> FMResultSet? {
        let resulttest : FMResultSet? = selectstatement(sqlstatement: "select * from shows where movieid = 550;")
        
        return resulttest
    }
    
    func createTablesAndData() {

            if connectiontoFMDB.open() {
                print("db auki")
                runstatement(sqlstatement: "create table if not exists movies (movieid integer primary key , name text);")
                
                runstatement(sqlstatement: "create table if not exists shows (showid integer primary key autoincrement, movieid integer, theaterid integer, startday text, starttime text, endtime text, foreign key (movieid) references movies (movieid), foreign key (theaterid) references theaters (theaterid));")
                
                runstatement(sqlstatement: "create table if not exists theaters (theaterid integer primary key autoincrement, name text, seatstotal integer);")
                
                runstatement(sqlstatement: "create table if not exists tickets (ticketid integer primary key autoincrement, showid integer, seat integer, seatrow integer, userid integer, foreign key (showid) references shows (showid));")
                
                print("taulut luotu")
                
                //movies
                runstatement(sqlstatement: "insert into movies (movieid, name) values (284053, 'Thor: Ragnarök');")
                runstatement(sqlstatement: "insert into movies (movieid, name) values (550, 'Fight Club');")
                runstatement(sqlstatement: "insert into movies (movieid, name) values (297762, 'Wonder Woman');")
                
                //theaters
                runstatement(sqlstatement: "insert into theaters (name, seatstotal) values ('blue', 90);")
                runstatement(sqlstatement: "insert into theaters (name, seatstotal) values ('green', 120);")
                runstatement(sqlstatement: "insert into theaters (name, seatstotal) values ('red', 90);")
                runstatement(sqlstatement: "insert into theaters (name, seatstotal) values ('yellow', 50);")
                
                //shows
                runstatement(sqlstatement: "insert into shows (movieid, theaterid, startday, starttime, endtime) values (550, 1, '2017-01-01', '14:30:00', '16:30:00');")
                runstatement(sqlstatement: "insert into shows (movieid, theaterid, startday, starttime, endtime) values (550, 2, '2017-01-02', '14:30:00', '16:30:00');")
                runstatement(sqlstatement: "insert into shows (movieid, theaterid, startday, starttime, endtime) values (550, 1, '2017-01-01', '12:30:00', '14:30:00');")
                runstatement(sqlstatement: "insert into shows (movieid, theaterid, startday, starttime, endtime) values (550, 1, '2017-01-03', '14:30:00', '16:30:00');")
                runstatement(sqlstatement: "insert into shows (movieid, theaterid, startday, starttime, endtime) values (550, 1, '2017-01-02', '18:30:00', '20:30:00');")
                runstatement(sqlstatement: "insert into shows (movieid, theaterid, startday, starttime, endtime) values (284053, 3, '2017-01-01', '13:30:00', '15:30:00');")
                runstatement(sqlstatement: "insert into shows (movieid, theaterid, startday, starttime, endtime) values (284053, 1, '2017-01-01', '17:00:00', '19:00:00');")
                runstatement(sqlstatement: "insert into shows (movieid, theaterid, startday, starttime, endtime) values (297762, 1, '2017-01-01', '17:00:00', '19:00:00');")
                
                //tickets
                runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (1, 5, 2, 1);")
                runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (2, 3, 1, 2);")
                runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (1, 5, 4, 2);")
                runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (1, 1, 2, 2);")
                runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (2, 1, 3, 2);")
                runstatement(sqlstatement: "insert into tickets (showid, seat, seatrow, userid) values (2, 2, 3, 2);")
                
            }
            connectiontoFMDB.close()
            
        
    }
    
}

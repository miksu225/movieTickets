//
//  db.swift
//  movieTickets
//
//  Created by Koulutus on 8.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class Db {
    var dbname : String
    var dbpath : String
    var connectiontoFMDB : FMDatabase
    
    init(dbname: String) {
        
         self.dbname = dbname
        
        let pathdummy = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        self.dbpath = pathdummy[0].appendingPathComponent(dbname).path
        NSLog(dbpath)
        self.connectiontoFMDB = FMDatabase(path: dbpath)

        
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
        if connectiontoFMDB.open() {
            return true
        }
        else {
            return false
        }
    }
    
    func close() {
        connectiontoFMDB.close()
    }
    
    func runstatement(sqlstatement: String) {
        connectiontoFMDB.executeStatements(sqlstatement)
        NSLog(connectiontoFMDB.debugDescription)
    }
    
    
    
}

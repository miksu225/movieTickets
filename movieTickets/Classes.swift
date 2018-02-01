//
//  jsonParser.swift
//  movieTickets
//
//  Created by Koulutus on 15.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

struct Movie : Codable {
    let id : Int
    let original_title : String
    let release_date : String
    let poster_path : String
    let overview : String
    
    init() {
        self.id = 0
        self.original_title = ""
        self.release_date = ""
        self.poster_path = ""
        self.overview = ""
    }

}

struct Images : Codable {
    let images : Config
    
    init() {
        self.images = Config()
    }
}

struct Config : Codable {
    let secure_base_url : String
    let poster_sizes : [String]
    
    init() {
        self.secure_base_url = ""
        self.poster_sizes = []
    }
}

class Show {
    var showid : Int
    var theater : Theater
    var startday : String
    var starttime : String
    var endtime : String
    var seatstaken : Int
    
    init(showid : Int, theater : Theater, startday: String, starttime : String, endtime : String, seatstaken : Int) {
        self.showid = showid
        self.theater = theater
        self.startday = startday
        self.starttime = starttime
        self.endtime = endtime
        self.seatstaken = seatstaken
    }
}

class Theater {
    var theaterid : Int
    var name : String
    var seatstotal : Int
    
    init(theaterid : Int, name : String, seatstotal : Int) {
        self.theaterid = theaterid
        self.name = name
        self.seatstotal = seatstotal
    }
}

class Seat {
    var seat : seatButton
    var seatnumber : Int
    var seatrow : Int
    
    init(seat : seatButton, seatnumber : Int, seatrow : Int) {
        self.seat = seat
        self.seatnumber = seatnumber
        self.seatrow = seatrow
    }
}

class Seat2 {
    var seatnumber : Int
    var seatrow : Int
    
    init(_ seatnumber : Int, _ seatrow : Int) {
        self.seatnumber = seatnumber
        self.seatrow = seatrow
    }
}

class Signs {
    func signOut(_ storyboard : UIStoryboard?) {
        do {
            try Auth.auth().signOut()
            
            let signInPage = storyboard?.instantiateViewController(withIdentifier: "idLoginViewController") as! LogInViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}



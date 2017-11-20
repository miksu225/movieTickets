//
//  jsonParser.swift
//  movieTickets
//
//  Created by Koulutus on 15.11.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import Foundation

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



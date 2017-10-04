//
//  People.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/21/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import Foundation


class People: Comparable {
    let name: String
    let birthYear: String
    let homeworldUrl: String
    let height: String
    let eyeColor: String
    let hairColor: String
    let url: String
    let vehicles: [String]
    let starships: [String]
    
    init(name: String, birthYear: String, homeworldUrl: String, height: String, eyeColor: String, hairColor: String, url: String, vehicles: [String], starships: [String]){
        self.name = name
        self.birthYear = birthYear
        self.homeworldUrl = homeworldUrl
        self.height = height
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        self.url = url
        self.vehicles = vehicles
        self.starships = starships
    }
    
    static func < (lhs: People, rhs: People) -> Bool {
        return Int(lhs.height)! < Int(rhs.height)!
    }
    
    static func > (lhs: People, rhs: People) -> Bool {
            return Int(lhs.height)! > Int(rhs.height)!
    }
    
    static func == (lhs: People, rhs: People) -> Bool {
        var returnValue = false
        if Int(lhs.height)! == Int(rhs.height)!
        {
            returnValue = true
        }
        return returnValue
    } 
}

extension People {
    convenience init?(json: [String: Any]) {
        struct Key {
            static let caracterName = "name"
            static let birthYear = "birth_year"
            static let homeworldUrl = "homeworld"
            static let height = "height"
            static let eyeColor = "eye_color"
            static let hairColor = "hair_color"
            static let url = "url"
            static let vehicles = "vehicles"
            static let starships = "starships"
        }
        
        guard let artistName = json[Key.caracterName] as? String,
            let birthYear = json[Key.birthYear] as? String,
            let homeworldUrl = json[Key.homeworldUrl] as? String,
            let height = json[Key.height] as? String,
            let eyeColor = json[Key.eyeColor] as? String,
            let hairColor = json[Key.hairColor] as? String,
            let url = json[Key.url] as? String,
            let vehicles = json[Key.vehicles] as? [String],
            let starships = json[Key.starships] as? [String]
        else {
                print("entre al guard")
                return nil
        }
        
        self.init(name: artistName, birthYear: birthYear, homeworldUrl: homeworldUrl, height: height, eyeColor: eyeColor, hairColor: hairColor, url: url, vehicles: vehicles, starships: starships)
        }
}


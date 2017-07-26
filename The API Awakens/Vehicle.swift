//
//  Vehicle.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/21/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import Foundation

class Vehicle {
    let name: String
    let manufacturer: String
    let costInCredits: String
    let length: String
    let vehicleClass: String
    let crew: String
    let url: String
    
    init(name: String, manufacturer: String, costInCredits: String, length: String, vehicleClass: String, crew: String, url: String){
        self.name = name
        self.manufacturer = manufacturer
        self.costInCredits = costInCredits
        self.length = length
        self.vehicleClass = vehicleClass
        self.crew = crew
        self.url = url
    }
}

extension Vehicle {
    convenience init?(json: [String: Any]) {
        struct Key {
            static let vehicleName = "name"
            static let manufacturer = "manufacturer"
            static let costInCredits = "cost_in_credits"
            static let length = "length"
            static let vehicleClass = "vehicle_class"
            static let crew = "crew"
            static let url = "url"
        }
        
        guard let starshipName = json[Key.vehicleName] as? String,
            let manufacturer = json[Key.manufacturer] as? String,
            let costInCredits = json[Key.costInCredits] as? String,
            let length = json[Key.length] as? String,
            let starshipClass = json[Key.vehicleClass] as? String,
            let crew = json[Key.crew] as? String,
            let url = json[Key.url] as? String
            else {
                print("entre al guard")
                return nil
        }
        
        self.init(name: starshipName, manufacturer: manufacturer, costInCredits: costInCredits, length: length, vehicleClass: starshipClass, crew: crew, url: url)
    }
}

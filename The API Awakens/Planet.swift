//
//  Planet.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/27/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import Foundation

class Planet {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Planet {

    convenience init?(json: [String: Any]) {
        struct Key {
            static let name = "name"
        }
        
        guard let name = json[Key.name] as? String else {
            print("entre al guard")
            return nil
        }
        self.init(name: name)
    }
}

//
//  ViewController.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/17/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let client = APIClient()
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    /*    client.searchForPeople() { people, error in
            self.url = people[0].url
            print("people \(people[0].url)")
        }
        
        print("url 2 \(url)")
        
        client.lookupCharacter(withUrl: "https://swapi.co/api/people/1/") { people, error in
            print("imprimo person \(people?.name)")
        }
        
     */   
    /*    client.searchForStarships() { starships, error in
            print("starships imprimo \(starships[0].name)")
        
        }
      */
      /*  client.lookupStarship(withUrl: "https://swapi.co/api/starships/12") { starship, error in
            print("starship unica \(starship?.name)")
        }
        */
        
       /* client.searchForVehicles() { vehicles, error in
            
            print("vehiclos !! \(vehicles[0].vehicleClass)")
        
        } */
        
        client.lookupVehicle(withUrl: "http://swapi.co/api/vehicles/4/") { vehicle, error in
            print("vehiculo url \(vehicle?.name)")
        
        }
        
       /* client.searchForArtists(withTerm: searchController.searchBar.text!) { [weak self] artists, error in
            self?.dataSource.update(with: artists)
            self?.tableView.reloadData()
        }*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


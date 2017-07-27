//
//  ViewController.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/17/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var picker: UIPickerView!
    
    let client = APIClient()
    var url = ""
    var peopleArray: [People] = [People]()
    var vehiclesArray: [Vehicle] = [Vehicle]()
    var starshipsArray: [Starship] = [Starship]()
    var entityTypeTapped = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        switch entityTypeTapped {
        case "characters": self.title = "Characters"
                            searchForPeople()
        case "vehicles": self.title = "Vehicles"
            searchForVehicles()
        case "starships": self.title = "Starships"
            searchForStarships()
        default: break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch entityTypeTapped {
        case "characters": print("number of rows! \(self.peopleArray.count)")
                            return self.peopleArray.count
        case "vehicles": print("number of rows! \(self.vehiclesArray.count)")
                        return self.vehiclesArray.count
        case "starships": print("number of rows! \(self.starshipsArray.count)")
                        return self.starshipsArray.count
        default: fatalError()
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch entityTypeTapped {
        case "characters": print("muestro el name ! \(self.peopleArray[row].name)")
        return self.peopleArray[row].name
        case "vehicles": print("muestro el name ! \(self.vehiclesArray[row].name)")
        return self.vehiclesArray[row].name
        case "starships": print("muestro el name ! \(self.starshipsArray[row].name)")
        return self.starshipsArray[row].name
        default: fatalError()
        }
        
        
    }

    func searchForPeople(){
        for index in 1...9 {
            client.searchForPeople(page: index) { people, error in
            // self.url = people[0].url
            //   print("number of rows solo de people! \(people.count)")
            self.peopleArray.append(contentsOf: people)
            //  print("number of rows! \(self.peopleArray.count)")
            //  print("people \(people[0].url)")
            // Connect data:
            self.picker.delegate = self
            self.picker.dataSource = self
            }
        }

    }
    
    func lookupCharacter(){
        client.lookupCharacter(withUrl: "https://swapi.co/api/people/1/") { people, error in
            print("imprimo person \(people?.name)")
        }
    }
    
    func searchForStarships(){
         for index in 1...4 {
            client.searchForStarships(page: index) { starships, error in
            print("starships imprimo \(starships[0].name)")
            self.starshipsArray.append(contentsOf: starships)
            // Connect data:
            self.picker.delegate = self
            self.picker.dataSource = self
            }
        }
    }
    
    func lookupStarship(){
        client.lookupStarship(withUrl: "https://swapi.co/api/starships/12") { starship, error in
            print("starship unica \(starship?.name)")
            }

    }
    
    func searchForVehicles(){
        
         for index in 1...4 {
            client.searchForVehicles(page: index) { vehicles, error in
            
            print("vehiclos !! \(vehicles[0].vehicleClass)")
            self.vehiclesArray.append(contentsOf: vehicles)
            // Connect data:
            self.picker.delegate = self
            self.picker.dataSource = self
            }
    }
    }
    
    func lookupVehicle(){
        client.lookupVehicle(withUrl: "http://swapi.co/api/vehicles/4/") { vehicle, error in
            print("vehiculo url \(vehicle?.name)")
    }
    }

}


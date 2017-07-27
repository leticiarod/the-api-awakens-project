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
    
    @IBOutlet var labelCollection: [UILabel]!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var contentLabel: [UILabel]!
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch entityTypeTapped {
        case "characters": let url = self.peopleArray[row].url
            print("selected !! \(url)")
                        lookupCharacter(by: url)
            
        case "vehicles": let url = self.vehiclesArray[row].url
            lookupVehicle(by: url)
        case "starships": let url = self.starshipsArray[row].url
            lookupStarship(by: url)
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
    
    func lookupCharacter(by url: String){
        //"https://swapi.co/api/people/1/"
        client.lookupCharacter(withUrl: url) { people, error in
            if let people = people {
            
            self.setComponentsUI(for: people)
            }
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
    
    func lookupStarship(by url: String){
        //"https://swapi.co/api/starships/12"
        client.lookupStarship(withUrl: url) { starship, error in
            //print("starship unica \(starship?.name)")
            if let starship = starship {
                self.setComponentsUI(for: starship)
            }
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
    
    func lookupVehicle(by url: String){
        //"http://swapi.co/api/vehicles/4/"
        client.lookupVehicle(withUrl: url) { vehicle, error in
           // print("vehiculo url \(vehicle?.name)")
            if let vehicle = vehicle {
            self.setComponentsUI(for: vehicle)
            }
        }
    }
    
    func setComponentsUI(for character: People){
        titleLabel.text = character.name
        
        contentLabel[0].text = character.birthYear
        
        client.lookupPlanet(withUrl: character.homeworldUrl) { planet, error in
            if let planet = planet {
            self.contentLabel[1].text = planet.name
            }
        }
        contentLabel[2].text = character.height
        contentLabel[3].text = character.eyeColor
        contentLabel[4].text = character.hairColor
    }
    
    func setComponentsUI(for vehicle: Vehicle){
        
        labelCollection[0].text = "Make"
        labelCollection[1].text = "Cost"
        labelCollection[2].text = "Length"
        labelCollection[3].text = "Class"
        labelCollection[4].text = "Crew"
        
        titleLabel.text = vehicle.name
        
        contentLabel[0].text = vehicle.manufacturer
        contentLabel[1].text = vehicle.costInCredits
        contentLabel[2].text = vehicle.length
        contentLabel[3].text = vehicle.vehicleClass
        contentLabel[4].text = vehicle.crew
        
    }
    
    func setComponentsUI(for starship: Starship){
        
        labelCollection[0].text = "Make"
        labelCollection[1].text = "Cost"
        labelCollection[2].text = "Length"
        labelCollection[3].text = "Class"
        labelCollection[4].text = "Crew"
        
        titleLabel.text = starship.name
        
        contentLabel[0].text = starship.manufacturer
        contentLabel[1].text = starship.costInCredits
        contentLabel[2].text = starship.length
        contentLabel[3].text = starship.starshipClass
        contentLabel[4].text = starship.crew
        
    }
    
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        for index in 1...9 {
            client.searchForPeople(page: index) { people, error in
               // self.url = people[0].url
                print("number of rows solo de people! \(people.count)")
                self.peopleArray.append(contentsOf: people)
                print("number of rows! \(self.peopleArray.count)")
                //print("people \(people[0].url)")
                // Connect data:
                self.picker.delegate = self
                self.picker.dataSource = self
            }
        }
       
        
        
        
        print("url 2 \(url)")
      /*
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
        
      /*  client.lookupVehicle(withUrl: "http://swapi.co/api/vehicles/4/") { vehicle, error in
            print("vehiculo url \(vehicle?.name)")
        
        } */
        
       /* client.searchForArtists(withTerm: searchController.searchBar.text!) { [weak self] artists, error in
            self?.dataSource.update(with: artists)
            self?.tableView.reloadData()
        }*/
        
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
        print("number of rows! \(self.peopleArray.count)")
        return self.peopleArray.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("muestro el name ! \(self.peopleArray[row].name)")
        return self.peopleArray[row].name
    }


}


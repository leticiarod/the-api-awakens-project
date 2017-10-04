//
//  ShowMoreCharacterController.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 10/4/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

class ShowMoreCharacterController: UIViewController {

    
    @IBOutlet weak var vehicleContainer: UIStackView!
    @IBOutlet weak var starshipContainer: UIStackView!
    
    @IBOutlet weak var vehicleLabel: UILabel!
    
    @IBOutlet weak var starshipLabel: UILabel!
    
    let client = APIClient()
    
    var vehiclesCharacter: [UIButton] = [UIButton]()
    var starshipsCharacter: [UIButton] = [UIButton]()
    
    var people: People? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // vehicleLabel.isHidden = true
       // starshipLabel.isHidden = true
        
        if let people = people {
            print("me llego el people: \(people.name)")
            
            //  let vehiclesCharacter: [Vehicle] = [Vehicle]()
            
           if people.vehicles.count == 0 {
                self.createLabelOfEmpty(with: "This character doesn't have any Vehicles", in: self.vehicleContainer)
            }
 
            for url in people.vehicles{
                client.lookupVehicle(withUrl: url) { vehicle, error in
                    //vehiclesCharacter.append(vehicle)
                    let button = UIButton()
                    if let vehicleName = vehicle?.name  {
                        button.setTitle(vehicleName, for: .normal)
                        button.setTitleColor(.black, for: .normal)
                        button.titleLabel?.adjustsFontSizeToFitWidth = true
                        self.vehiclesCharacter.append(button)
                        self.vehicleContainer.addArrangedSubview(button)
                       // self.vehicleLabel.isHidden = false
                    }
                                    }
            }
            
            if people.starships.count == 0 {
                self.createLabelOfEmpty(with: "This character doesn't have any Starships", in: self.starshipContainer)
            }
 
            
            for url in people.starships{
                client.lookupStarship(withUrl: url) { starship, error in
                    let button = UIButton()
                    if let starshipName = starship?.name  {
                        button.setTitle(starshipName, for: .normal)
                        button.setTitleColor(.black, for: .normal)
                        button.titleLabel?.adjustsFontSizeToFitWidth = true
                        self.starshipsCharacter.append(button)
                        self.starshipContainer.addArrangedSubview(button)
                      //  self.starshipLabel.isHidden = false
                    }
                    
                }
            }

        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createLabelOfEmpty(with title: String, in stackview: UIStackView){
        let label: UILabel = UILabel()
        label.text = title
        label.textColor = .black
        label.numberOfLines = 2
        //label.adjustsFontSizeToFitWidth = true
        stackview.addArrangedSubview(label)
    }

}

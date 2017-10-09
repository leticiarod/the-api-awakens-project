//
//  ShowMoreCharacterController.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 10/4/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

class ShowMoreCharacterController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var vehicleContainer: UIStackView!
   
    @IBOutlet weak var vehicleLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    let client = APIClient()
    
    var vehiclesCharacter: [String] = [String]()
    
    
    var people: People? = nil
    
    let myGroup = DispatchGroup()
    
    let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("HOLA VEHICULOS !! \(people)")
        
        if let people = people {
            print("me llego el people: \(people.name)")
            
            //  let vehiclesCharacter: [Vehicle] = [Vehicle]()
            
      /*     if people.vehicles.count == 0 {
                self.createLabelOfEmpty(with: "This character doesn't have any Vehicles", in: self.vehicleContainer)
            }
 */
            for url in people.vehicles{
                myGroup.enter()
                activityIndicator.addActivityIndicatorToTableView(to: self.view)
                activityIndicator.startActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
                client.lookupVehicle(withUrl: url) { vehicle, error in
                    //vehiclesCharacter.append(vehicle)
      //              let button = UIButton()
                    if let vehicleName = vehicle?.name  {
        //                button.setTitle(vehicleName, for: .normal)
          //              button.setTitleColor(.black, for: .normal)
            //            button.titleLabel?.adjustsFontSizeToFitWidth = true
                        self.vehiclesCharacter.append(vehicleName)
                       // self.vehicleContainer.addArrangedSubview(button)
                       // self.vehicleLabel.isHidden = false
                    }
                 self.myGroup.leave()
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
    
    
   /* func createLabelOfEmpty(with title: String, in stackview: UIStackView){
        let label: UILabel = UILabel()
        label.text = title
        label.textColor = .black
        label.numberOfLines = 2
        //label.adjustsFontSizeToFitWidth = true
        stackview.addArrangedSubview(label)
    }
 */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let people = people {
            return(people.vehicles.count)
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        myGroup.notify(queue: .main) {
            self.activityIndicator.stopActivityIndicator(activityIndicator: self.activityIndicator.activityIndicator)
            cell.textLabel?.text = self.vehiclesCharacter[indexPath.row]
            
        }
        
        return(cell)

    }
    
    

}

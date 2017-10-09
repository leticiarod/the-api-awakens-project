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
        
        if let people = people {
            for url in people.vehicles{
                myGroup.enter()
                activityIndicator.addActivityIndicatorToTableView(to: self.view)
                activityIndicator.startActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
                client.lookupVehicle(withUrl: url) { vehicle, error in
                if let vehicleName = vehicle?.name  {
                    self.vehiclesCharacter.append(vehicleName)
                }
                 self.myGroup.leave()
                }
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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

//
//  StarshipsViewController.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 10/6/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

class StarshipsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var starshipsCharacter: [String] = [String]()
    
    @IBOutlet weak var starshipContainer: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let client = APIClient()
    
    var people: People? = nil
    
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let people = people {
            for url in people.starships{
                myGroup.enter()
                client.lookupStarship(withUrl: url) { starship, error in
                    if let starshipName = starship?.name  {
                        self.starshipsCharacter.append(starshipName)
                        self.myGroup.leave()
                    }
                    
                }
            }
        }
 
    }

    override func viewWillAppear(_ animated: Bool) {
        
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
            return(people.starships.count)
        }
        else {
            return 0
        }
        
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        myGroup.notify(queue: .main) {
        cell.textLabel?.text = self.starshipsCharacter[indexPath.row]

        }
        
        return(cell)
       
    }

  
    
}

//
//  StarshipsViewController.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 10/6/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

class StarshipsViewController: UIViewController {
    
    var starshipsCharacter: [UIButton] = [UIButton]()
    
    @IBOutlet weak var starshipContainer: UIStackView!
    
    let client = APIClient()
    
    var people: People? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

         print("HOLA starships!! 1 ")
        if let people = people {
            print("HOLA starships!!: \(people.name)")
        }
        
        if let people = people {
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

//
//  HomeViewController.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/27/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let client = APIClient()
    var url = ""
    var peopleArray: [People] = [People]()

    @IBOutlet var viewCollection: [UIView]! {
        
            didSet {
                let bottomLine = CALayer()
                //  let width = CGFloat(1.0)
                var y = 0.0
                viewCollection.forEach {
                    y += Double($0.layer.frame.height)
                    //Double($0.layer.frame.width)
                    bottomLine.frame = CGRect(x: 0.0, y: $0.layer.frame.height - 1, width: $0.layer.frame.width, height: 1.0)
                    bottomLine.backgroundColor = UIColor.lightGray.cgColor
                   // $0.layer.borderWidth = CGFloat(UITextBorderStyle.none.rawValue)
                    $0.layer.addSublayer(bottomLine)
                  //  $0.layer.borderWidth = 1
                  //  $0.layer.borderColor = UIColor.lightGray.cgColor
                  //  $0.layer.frame = CGRect(x: 0, y: $0.frame.size.height - width, width:  $0.frame.size.width, height: $0.frame.size.height)
                  //  $0.layer.masksToBounds = true
                }
                
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func charactersButtonPressed(_ sender: Any) {
        
    }

    
    @IBAction func vehiclesButtonPressed(_ sender: Any) {
    }
    
    @IBAction func starshipsButtonPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("pase por el prepare")
        let viewController = segue.destination as! ViewController
        if segue.identifier == "characters" {
            viewController.entityTypeTapped = "characters"
        }
        else {
            if segue.identifier == "vehicles" {
                viewController.entityTypeTapped = "vehicles"
            }
            else {
                if segue.identifier == "starships" {
                    viewController.entityTypeTapped = "starships"
                }
            }
        }
        
     //   self.navigationController?.navigationBar.tintColor = UIColor.white
    //
     //   let backItem = UIBarButtonItem()
      //  backItem.title = "Back"
       // navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed

    }
    
}

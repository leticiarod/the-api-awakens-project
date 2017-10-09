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
            var y = 0.0
            viewCollection.forEach {
                y += Double($0.layer.frame.height)
                bottomLine.frame = CGRect(x: 0.0, y: Double(y), width: Double($0.layer.frame.width), height: 1.0)
                bottomLine.backgroundColor = UIColor.lightGray.cgColor
                $0.layer.addSublayer(bottomLine)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    }
}

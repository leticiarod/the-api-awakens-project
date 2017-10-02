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
                    bottomLine.frame = CGRect(x: 0.0, y: Double(y), width: Double($0.layer.frame.width), height: 1.0)
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
        
        
        // Status bar white font
       // navigationBar.barStyle = UIBarStyle.Black
      //  navigationBar.tintColor = UIColor.whiteColor()
        
       // let color = UIColor(red:0.11, green:0.13, blue:0.14, alpha:1.0)
        
       navigationController?.navigationBar.barTintColor = UIColor.white
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
      //  self.navigationController?.navigationBar.tintColor = UIColor.white
     //   navigationController?.status = UIBarStyle.
     //   navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      //  navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        
        //#CCCCCC
        
     //
    //
     //   let backItem = UIBarButtonItem()
      //  backItem.title = "Back"
       // navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed

    }
    
}

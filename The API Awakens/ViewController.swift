//
//  ViewController.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/17/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

enum UnitType {
    case englishMetric
    case BritishUnits
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var contentLabel: [UILabel]!
    @IBOutlet weak var smallest: UILabel!
    @IBOutlet weak var largest: UILabel!
    
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var bornValueLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var homeValueLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightValueLabel: UILabel!
    @IBOutlet weak var eyesLabel: UILabel!
    @IBOutlet weak var eyesValueLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var hairValueLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var englishValueLabel: UIButton!
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    
    
    
    let client = APIClient()
    var url = ""
    var peopleArray: [People] = [People]()
    var vehiclesArray: [Vehicle] = [Vehicle]()
    var starshipsArray: [Starship] = [Starship]()
    var entityTypeTapped = ""
    var lightGreyColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
    var darkGreyColor = UIColor(red:0.11, green:0.13, blue:0.14, alpha:1.0)
    
    //
    var peopleHeightArray: [Int] = [Int]()
    
    //
    var vehiclesLengthArray: [Int] = [Int]()
    
    //
    var starshipsLengthArray: [Int] = [Int]()
    
    
    var valueArray: [Double] = [Double]()
    
    //
    var heightValueAux = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add border line at labels
        addBottomBorder()
        
        // Customize navigation bar of view controller
        customizeNavigationBar()
        
        // Set title by option chosen by the user in the home menu
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
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews \(peopleHeightArray.count)")
        
        for item in peopleHeightArray {
            print(" imprimo height de people array \(item)")
        }
    }
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
        print("Hola !!")
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
        case "characters":
        return self.peopleArray[row].name
        case "vehicles": return self.vehiclesArray[row].name
        case "starships": return self.starshipsArray[row].name
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
        let myGroup = DispatchGroup()
        for index in 1...9 {
            myGroup.enter()
            client.searchForPeople(page: index) { people, error in
                self.peopleArray.append(contentsOf: people)
                // Connect data:
                self.picker.delegate = self
                self.picker.dataSource = self
            myGroup.leave()
            }
            
        }
        
        myGroup.notify(queue: .main) {
            
            print("Finished all requests.")
            
            var arrangedPeopleHeightArrayAux: [People] = [People]()
            
            //
            for character in self.peopleArray {
                if let height = String(character.height) {
                    if height != "unknown" {
                    arrangedPeopleHeightArrayAux.append(character)
                }
            }
            }
            
            //
            let arrangedPeopleHeightArray: [People] = self.arrangeArray(arrangedPeopleHeightArrayAux)
            
            //
            self.populateQuickFactsBar(arrangedPeopleHeightArray)

        }
        
        
    }
    
    func lookupCharacter(by url: String){
        client.lookupCharacter(withUrl: url) { people, error in
            if let people = people {
            self.setComponentsUI(for: people)
            }
        }
    }
    
    func searchForStarships(){
         for index in 1...4 {
            client.searchForStarships(page: index) { starships, error in
            self.starshipsArray.append(contentsOf: starships)
            // Connect data:
            self.picker.delegate = self
            self.picker.dataSource = self
            }
        }
    }
    
    func lookupStarship(by url: String){
        client.lookupStarship(withUrl: url) { starship, error in
            if let starship = starship {
                self.setComponentsUI(for: starship)
            }
            }

    }
    
    func searchForVehicles(){
        
         for index in 1...4 {
            client.searchForVehicles(page: index) { vehicles, error in
            self.vehiclesArray.append(contentsOf: vehicles)
            // Connect data:
            self.picker.delegate = self
            self.picker.dataSource = self
            }
    }
    }
    
    func lookupVehicle(by url: String){
        client.lookupVehicle(withUrl: url) { vehicle, error in
            if let vehicle = vehicle {
            self.setComponentsUI(for: vehicle)
            }
        }
    }
    
    func setComponentsUI(for character: People){
        englishLabel.text = "English"
        englishValueLabel.setTitle("Metric", for: .normal)
        titleLabel.text = character.name
        
        contentLabel[0].text = character.birthYear
        
        client.lookupPlanet(withUrl: character.homeworldUrl) { planet, error in
            if let planet = planet {
            self.contentLabel[1].text = planet.name
            }
        }
        
        heightValueAux = character.height
        
        contentLabel[2].text = customize(height: heightValueAux, for: UnitType.englishMetric)
        contentLabel[3].text = character.eyeColor
        contentLabel[4].text = character.hairColor
    }
    
    func setComponentsUI(for vehicle: Vehicle){
        
        
        setLabelComponents()
        titleLabel.text = vehicle.name
        
        contentLabel[0].text = vehicle.manufacturer
        contentLabel[1].text = vehicle.costInCredits
        contentLabel[2].text = vehicle.length
        contentLabel[3].text = vehicle.vehicleClass
        contentLabel[4].text = vehicle.crew
    }
    
    func setComponentsUI(for starship: Starship){
        
        setLabelComponents()
        
        titleLabel.text = starship.name
        
        contentLabel[0].text = starship.manufacturer
        contentLabel[1].text = starship.costInCredits
        contentLabel[2].text = starship.length
        contentLabel[3].text = starship.starshipClass
        contentLabel[4].text = starship.crew
        
    }
    
    func setLabelComponents(){
        labelCollection[0].text = "Make"
        labelCollection[1].text = "Cost"
        labelCollection[2].text = "Length"
        labelCollection[3].text = "Class"
        labelCollection[4].text = "Crew"
    }

    func addBottomBorder() {
        bornLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        bornValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        homeLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        homeValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        heightLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        heightValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        eyesLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        eyesValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        hairLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        hairValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        englishLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        englishValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        picker.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
    }
    
    func customizeNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = darkGreyColor
        
        let textAttributes = [NSForegroundColorAttributeName:lightGreyColor, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)] as [String : Any]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = lightGreyColor
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30)], for: UIControlState.normal)
    }
    
    func arrangeArray<T: Comparable>(_ array: [T]) -> [T]{
        
        let ascendingSizes = array.sorted(by: { $0 < $1 })
        
        return ascendingSizes
    }
    
    func populateQuickFactsBar(_ arrangedPeopleHeightArray: [People]){
        self.smallest.text = String(describing: arrangedPeopleHeightArray[0].name)
        self.largest.text = String(describing: arrangedPeopleHeightArray[arrangedPeopleHeightArray.count - 1].name)
    }
    
    
    @IBAction func unitsButtonPressed(_ sender: Any){
        
        // 1 m = 100cm = 39,4 in
        
        //100 - 39.4
        //164 - X
        //x = (164 * 39,4)100 = 64,6
        //x=164*0.394 = 64.6
     //   100 - 39.4
      //  x   - 64.6
        
      //  163,9 = 164
        
       // 2.54 * 64.6
        
        let labelValue = englishLabel.text
        
        // To Inch
        if labelValue == "English" {
            englishLabel.text = "British"
            englishValueLabel.setTitle("Units", for: .normal)
            if  heightValueAux != "unknown" {
                if let doubleHeightValue = Double(heightValueAux) {
                let value = doubleHeightValue * 0.394
                let stringHeight = String(value.rounded())
                heightValueAux = stringHeight
                    heightValueLabel.text = customize(height: stringHeight, for: UnitType.BritishUnits)
            }
            }
        }
        // To meters
        else {
            englishLabel.text = "English"
            englishValueLabel.setTitle("Metric", for: .normal)
            if heightValueAux != "unknown" {
               if let doubleHeightValue = Double(heightValueAux) {
                let value = doubleHeightValue * 2.54
                let stringHeight = String(value.rounded())
                heightValueAux = stringHeight
                heightValueLabel.text = customize(height: stringHeight, for: UnitType.englishMetric)
            }
            }
        }
    }
    
    func customize(height value: String, for type: UnitType) -> String{
        print("size del string \(value.characters.count) \(value)")
        switch value.characters.count {
        case 2:
            if type == .englishMetric {
            return "0.\(value)m"
                
            }
            else {
            return "0.\(value)in"}
        case 3: let toIndex = value.index(value.startIndex, offsetBy: 1)
                let fromIndex = value.index(value.startIndex, offsetBy: 1)
        if type == .englishMetric {
            return "\(value.substring(to: toIndex)).\(value.substring(from: fromIndex))m"
        }
        else {
            return "\(value.substring(to: toIndex)).\(value.substring(from: fromIndex))in"
            }
            
        case 4: let index = value.index(value.startIndex, offsetBy: 2)
        if type == .englishMetric {
                        return "0.\(value.substring(to: index))m"
            }
        else {
            return "0.\(value.substring(to: index))in"
            }
        case 5: //166.0
            let toIndex = value.index(value.startIndex, offsetBy: 1)
            //let fromIndex = value.index(value.startIndex, offsetBy: 1)
        let start = value.index(value.startIndex, offsetBy: 1)
        let end = value.index(value.endIndex, offsetBy: -2)
        let range = start..<end
            if type == .englishMetric {
            return "\(value.substring(to: toIndex)).\(value.substring(with: range))m"
            }
            else{
            return "\(value.substring(to: toIndex)).\(value.substring(with: range))in"
            }
        default:
            //
            fatalError()
        }
    }
}


extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
}

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

enum ElementType {
    case character
    case vehicle
    case starship
    case planet
    case other
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
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var stackViewContainer: UIStackView!
    
    @IBOutlet weak var costTextField: UITextField!
    
    let client = APIClient()
    var url = ""
    var peopleArray: [People] = [People]()
    var vehiclesArray: [Vehicle] = [Vehicle]()
    var starshipsArray: [Starship] = [Starship]()
    var entityTypeTapped = ""
    var lightGreyColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
    var darkGreyColor = UIColor(red:0.11, green:0.13, blue:0.14, alpha:1.0)
    var greyColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
    
    // Used to store the hegiht or lenght value of an entity globally.
    var heightValueAux = ""
    
    // Used to store the cost in credits value of an entity globally.
    var costInCredits = ""
    
    // Used to know which is the current exchange
    var currentExchange = ""
    
    let usdButton = UIButton()
    let creditsButton = UIButton()
    
    var buttonsArray: [UIButton] = [UIButton]()
    
    var characterAux: People? = nil
    
    let activityIndicator = ActivityIndicator()
    
    /* DispatchGroup allows for aggregate synchronization of work. You can use them to submit multiple different work items and track when they all complete, even though they might run on different queues. This behavior can be helpful when progress can’t be made until all of the specified tasks are complete. */
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add border line at labels
        addBottomBorder()
        
        // Customize navigation bar of view controller
        customizeNavigationBar()
        
        // Hide the labels corrosponding to the info of each entity while the picker is loading.
        hideInfoLabels()
        
        // Creates the exchange buttons.
        createExchangeButtons()
        
        // Add target to costTextField in order to Enable check when a UITextField changes
        costTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Set title by option chosen by the user in the home menu
        switch entityTypeTapped {
        case "characters": self.title = "Characters"
        costTextField.isUserInteractionEnabled = false
        activityIndicator.addActivityIndicatorToPickerView(view: self.view)
        activityIndicator.startActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        searchForPeople()
        case "vehicles": self.title = "Vehicles"
        activityIndicator.addActivityIndicatorToPickerView(view: self.view)
        activityIndicator.startActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        searchForVehicles()
        case "starships": self.title = "Starships"
        showMoreButton.isHidden = true
        activityIndicator.addActivityIndicatorToPickerView(view: self.view)
        activityIndicator.startActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        searchForStarships()
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowMoreCharacter" {
            guard let tabVc = segue.destination as? UITabBarController else {
                return
            }
            guard let vehicleNavigationContainer = tabVc.viewControllers?[0] as? UINavigationController else {
                return
            }
            
            guard let starshipsNavigationContainer = tabVc.viewControllers?[1] as? UINavigationController else {
                return
            }
            
            guard let vehiclesViewController = vehicleNavigationContainer.viewControllers.first as? ShowMoreCharacterController else {
                return
            }
            guard let starshipsViewController = starshipsNavigationContainer.viewControllers.first as? StarshipsViewController else {
                return
            }
    
            starshipsViewController.people = self.characterAux
            vehiclesViewController.people = self.characterAux
        }
        
    }
    
    func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch entityTypeTapped {
        case "characters": return self.peopleArray.count
        case "vehicles": return self.vehiclesArray.count
        case "starships": return self.starshipsArray.count
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
    
    // Selects an item from the picker wheel.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch entityTypeTapped {
        case "characters": let url = self.peopleArray[row].url
        activityIndicator.addActivityIndicator(to: self.view)
        activityIndicator.startActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        lookupCharacter(by: url)
        case "vehicles":   let url = self.vehiclesArray[row].url
        activityIndicator.addActivityIndicator(to: self.view)
        activityIndicator.startActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        lookupVehicle(by: url)
        case "starships":  let url = self.starshipsArray[row].url
        activityIndicator.addActivityIndicator(to: self.view)
        activityIndicator.startActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        lookupStarship(by: url)
        default: fatalError()
        }
    }
    
    func searchForPeople(){
        for index in 1...9 {
            myGroup.enter()
            client.searchForPeople(page: index) { people, error in
                if let error = error {
                    self.show(error: error, for: .character, url: nil)
                } else {
                    self.peopleArray.append(contentsOf: people)
                    // Connect data:
                    self.picker.delegate = self
                    self.picker.dataSource = self
                    self.myGroup.leave()
                }
            }
        }
        
        myGroup.notify(queue: .main) {
            //Finished all requests.
            
            // Stops the activity indicator
            self.activityIndicator.stopActivityIndicator(activityIndicator: self.activityIndicator.activityIndicator)
            
            var arrangedPeopleHeightArrayAux: [People] = [People]()
            
            for character in self.peopleArray {
                if let height = String(character.height) {
                    if height != "unknown" {
                        arrangedPeopleHeightArrayAux.append(character)
                    }
                }
            }
            
            // Arranges the height array from smallest to largest to populate the quick facts bar.
            let arrangedPeopleHeightArray: [People] = self.arrangeArray(arrangedPeopleHeightArrayAux)
            
            // Populates Quick Facts Bar.
            self.populateQuickFactsBar(arrangedPeopleHeightArray,nil,nil)
        }
    }
    
    func lookupCharacter(by url: String){
        client.lookupCharacter(withUrl: url) { people, error in
            if let error = error {
                self.show(error: error, for: .character, url: nil)
            }
            else {
                if let people = people {
                    self.setComponentsUI(for: people)
                }
            }
        }
    }
    
    func searchForStarships(){
        for index in 1...4 {
            myGroup.enter()
            client.searchForStarships(page: index) { starships, error in
                if let error = error {
                    self.show(error: error, for: .starship, url: nil)
                }
                else {
                    self.starshipsArray.append(contentsOf: starships)
                    // Connect data:
                    self.picker.delegate = self
                    self.picker.dataSource = self
                    self.myGroup.leave()
                }
                
            }
        }
        
        myGroup.notify(queue: .main) {
            //Finished all requests.
            
            // Stops the activity indicator
            self.activityIndicator.stopActivityIndicator(activityIndicator: self.activityIndicator.activityIndicator)
            
            var arrangedStarshipLengthArrayAux: [Starship] = [Starship]()
            
            for starship in self.starshipsArray {
                if let length = String(starship.length) {
                    if length != "unknown" && length != "1,600" {
                        arrangedStarshipLengthArrayAux.append(starship)
                    }
                }
            }
            
            // Arranges length array from smallest to largest to populate the quick facts bar.
            let arrangedStarshipLengthArray: [Starship] = self.arrangeArray(arrangedStarshipLengthArrayAux)
            
            // Populates Quick Facts Bar.
            self.populateQuickFactsBar(nil,nil,arrangedStarshipLengthArray)
        }
    }
    
    func lookupStarship(by url: String){
        client.lookupStarship(withUrl: url) { starship, error in
            if let error = error {
                self.show(error: error, for: .starship, url: nil)
            }
            else {
                if let starship = starship {
                    self.setComponentsUI(for: starship)
                }
            }
        }
    }
    
    func searchForVehicles(){
        for index in 1...4 {
            myGroup.enter()
            client.searchForVehicles(page: index) { vehicles, error in
                if let error = error {
                    self.show(error: error, for: .vehicle, url: nil)
                }
                else {
                    self.vehiclesArray.append(contentsOf: vehicles)
                    // Connect data:
                    self.picker.delegate = self
                    self.picker.dataSource = self
                    self.myGroup.leave()
                }
            }
        }
        
        myGroup.notify(queue: .main) {
            //Finished all requests.
            
            // Stops the activity indicator.
            self.activityIndicator.stopActivityIndicator(activityIndicator: self.activityIndicator.activityIndicator)
            
            var arrangedVehicleLengthArrayAux: [Vehicle] = [Vehicle]()
            
            for vehicle in self.vehiclesArray {
                if let length = String(vehicle.length) {
                    if length != "unknown"{
                        arrangedVehicleLengthArrayAux.append(vehicle)
                    }
                }
            }
            
            // Arranges length array from smallest to largest to populate the quick facts bar.
            let arrangedVehicleLengthArray: [Vehicle] = self.arrangeArray(arrangedVehicleLengthArrayAux)
            
            // Populates Quick Facts Bar.
            self.populateQuickFactsBar(nil,arrangedVehicleLengthArray,nil)
            
        }
    }
    
    func lookupVehicle(by url: String){
        client.lookupVehicle(withUrl: url) { vehicle, error in
            if let error = error {
                self.show(error: error, for: .vehicle, url: nil)
            }
            else {
                if let vehicle = vehicle {
                    self.setComponentsUI(for: vehicle)
                }
            }
        }
    }
    
    func lookupPlanet(by url: String){
        client.lookupPlanet(withUrl: url) { planet, error in
            if let error = error {
                self.show(error: error, for: .planet, url: nil)
            }
            else {
                if let planet = planet {
                    self.costTextField.text = planet.name
                }
            }
        }
    }
    // Sets the corresponding label names according to the Characters entity.
    func setComponentsUI(for character: People){
        // Stops the activity indicator
        activityIndicator.stopActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        
        self.characterAux = character
        
        englishLabel.text = "English"
        englishValueLabel.setTitle("Metric", for: .normal)
        titleLabel.text = character.name
        
        contentLabel[0].text = character.birthYear
        
        let url = character.homeworldUrl
        lookupPlanet(by: url)
        
        heightValueAux = character.height
        contentLabel[1].text = heightValueAux
        contentLabel[2].text = character.eyeColor
        contentLabel[3].text = character.hairColor
        // Shows all the labels of the "Information Box"
        showInfoLabels()
        // Shows the More Button
        visualizeMoreButton()
    }
    
    // Sets the corresponding label names according to the Vehicles entity.
    func setComponentsUI(for vehicle: Vehicle){
        // Stops the activity indicator
        activityIndicator.stopActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        
        //Sets the corresponding text to the labels according to the vehicles info.
        setLabelComponents()
        
        currentExchange = "Credits"
        
        englishLabel.text = "English"
        englishValueLabel.setTitle("Metric", for: .normal)
        
        usdButton.setTitleColor(greyColor, for: .normal)
        creditsButton.setTitleColor(.white, for: .normal)
        
        titleLabel.text = vehicle.name
        
        contentLabel[0].text = vehicle.manufacturer
        contentLabel[0].adjustsFontSizeToFitWidth = true
        
        costInCredits = vehicle.costInCredits
        
        costTextField.text = costInCredits
        
        costTextField.adjustsFontSizeToFitWidth = true
        
        heightValueAux = vehicle.length
        
        contentLabel[1].text = heightValueAux
        
        contentLabel[2].text = vehicle.vehicleClass
        contentLabel[3].text = vehicle.crew
        
        // Adds the “Galactic Credits” and "US Dollars" buttons to a stack view.
        addSubViewToStackView(buttonsArray)
        // Shows all the labels of the "Information Box"
        showInfoLabels()
    }
    
    // Sets the corresponding label names according to the Starships entity.
    func setComponentsUI(for starship: Starship){
        
        // Stops the activity indicator
        activityIndicator.stopActivityIndicator(activityIndicator: activityIndicator.activityIndicator)
        
        //Sets the corresponding text to the labels according to the starships info.
        setLabelComponents()
        
        englishLabel.text = "English"
        englishValueLabel.setTitle("Metric", for: .normal)
        
        usdButton.setTitleColor(greyColor, for: .normal)
        creditsButton.setTitleColor(.white, for: .normal)
        
        titleLabel.text = starship.name
        
        contentLabel[0].text = starship.manufacturer
        contentLabel[0].numberOfLines = 1;
        contentLabel[0].adjustsFontSizeToFitWidth = true
        
        costInCredits = starship.costInCredits
        
        costTextField.text = costInCredits
        costTextField.adjustsFontSizeToFitWidth = true
        
        heightValueAux = starship.length
        
        contentLabel[1].text = heightValueAux
        
        contentLabel[2].text = starship.starshipClass
        contentLabel[3].text = starship.crew
        
        // Adds the “Galactic Credits” and "US Dollars" buttons to a stack view.
        addSubViewToStackView(buttonsArray)
        
        // Shows all the labels of the "Information Box"
        showInfoLabels()
    }
    
    // Sorts a given array of generic type from smallest to largest.
    func arrangeArray<T: Comparable>(_ array: [T]) -> [T]{
        
        let ascendingSizes = array.sorted(by: { $0 < $1 })
        
        return ascendingSizes
    }
    
    // Populates the quick facts bar.
    func populateQuickFactsBar(_ arrangedPeopleHeightArray: [People]?, _ arrangedVehicleLengthArray: [Vehicle]?,_ arrangedStarshipLengthArray: [Starship]?){
        
        if let arrangedPeopleHeightArray = arrangedPeopleHeightArray {
            self.smallest.text = String(describing: arrangedPeopleHeightArray[0].name)
            self.largest.text = String(describing: arrangedPeopleHeightArray[arrangedPeopleHeightArray.count - 1].name)
        }
        
        if let arrangedVehicleLengthArray = arrangedVehicleLengthArray {
            self.smallest.text = String(describing: arrangedVehicleLengthArray[0].name)
            self.largest.text = String(describing: arrangedVehicleLengthArray[arrangedVehicleLengthArray.count - 1].name)
        }
        
        if let arrangedStarshipLengthArray = arrangedStarshipLengthArray {
            self.smallest.text = String(describing: arrangedStarshipLengthArray[0].name)
            self.largest.text = String(describing: arrangedStarshipLengthArray[arrangedStarshipLengthArray.count - 1].name)
        }
    }
    
    
    @IBAction func unitsButtonPressed(_ sender: Any){
        // 1 m = 100cm = 39,4 in
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
    
    func usdButtonClicked(sender: UIButton){
        //1 Credit = 0,62 USD
        usdButton.setTitleColor(.white, for: .normal)
        creditsButton.setTitleColor(greyColor, for: .normal)
        
        if let cost = costTextField.text{
            costInCredits = cost
        }
        
        if costInCredits != "0" && !costInCredits.contains("-") {
            if currentExchange == "USD" {
                costTextField.text = costInCredits
            }
            else {
                currentExchange = "USD"
                if let cost = Double(costInCredits){
                    let costInCreditsValue = cost * 0.62
                    costTextField.text = String(costInCreditsValue.rounded())
                }
            }
        }
        else {
            show(error: .negativeExchangeRate, for: .other, url: nil)
        }
    }
    
    func creditsButtonClicked(sender: UIButton){
        usdButton.setTitleColor(greyColor, for: .normal)
        creditsButton.setTitleColor(.white, for: .normal)
        
        if let cost = costTextField.text{
        costInCredits = cost
        }
        
        if costInCredits != "0" && !costInCredits.contains("-") {
            if currentExchange == "Credits" {
                costTextField.text = costInCredits
            }
            else {
                currentExchange = "Credits"
                if let cost = Double(costInCredits){
                    let costInUSDValue = cost / 0.62
                    costTextField.text = String(costInUSDValue.rounded())
                }
            }
        }
        else {
            show(error: .negativeExchangeRate, for: .other, url: nil)
        }
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    // MARK: - Helper Methods
    
    // USER INTERFACE
    
    // Creates buttons “Galactic Credits” and "US Dollars" to later convert from “Galactic Credits” to "US Dollars" and viceversa.
    func createExchangeButtons(){
        usdButton.setTitle("USD", for: .normal)
        usdButton.setTitleColor(greyColor, for: .normal)
        usdButton.addTarget(self, action: #selector(usdButtonClicked(sender:)), for:.touchUpInside)
        
        creditsButton.setTitle("Credits", for: .normal)
        creditsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        creditsButton.addTarget(self, action: #selector(creditsButtonClicked(sender:)), for:.touchUpInside)
        
        buttonsArray.append(usdButton)
        buttonsArray.append(creditsButton)
    }
    
    // Sets all labels to visible = false
    func hideInfoLabels(){
        titleLabel.isHidden = true
        bornLabel.isHidden = true
        bornValueLabel.isHidden = true
        homeLabel.isHidden = true
        costTextField.isHidden = true
        heightLabel.isHidden = true
        heightValueLabel.isHidden = true
        eyesLabel.isHidden = true
        eyesValueLabel.isHidden = true
        hairLabel.isHidden = true
        hairValueLabel.isHidden = true
        englishLabel.isHidden = true
        englishValueLabel.isHidden = true
        showMoreButton.isHidden = true
        showMoreButton.isUserInteractionEnabled = false
        stackViewContainer.isHidden = true
    }
    
    // Sets all labels of the "Information Box" to hidden = false
    func showInfoLabels(){
        titleLabel.isHidden = false
        bornLabel.isHidden = false
        bornValueLabel.isHidden = false
        homeLabel.isHidden = false
        costTextField.isHidden = false
        heightLabel.isHidden = false
        heightValueLabel.isHidden = false
        eyesLabel.isHidden = false
        eyesValueLabel.isHidden = false
        hairLabel.isHidden = false
        hairValueLabel.isHidden = false
        englishLabel.isHidden = false
        englishValueLabel.isHidden = false
        stackViewContainer.isHidden = false
        
    }
    
    // Sets the showMoreButton to hidden = false so when user selects the Character option in the home screen can see the "Show More" option.
    func visualizeMoreButton() {
        showMoreButton.isHidden = false
        showMoreButton.isUserInteractionEnabled = true
    }
    
    //  Given an array of buttons, this buttons are added to the stack view menu.
    func addSubViewToStackView(_ array: [UIButton]){
        for button in array {
            stackViewContainer.addArrangedSubview(button)
        }
    }
    
    // Adds a bottom border to the labels of the "Info box" when all the related fields on the screen are being populated.
    func addBottomBorder() {
        bornLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        bornValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        homeLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        heightLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        heightValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        eyesLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        eyesValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        hairLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        hairValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        englishLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        englishValueLabel.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        picker.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        costTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        stackViewContainer.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
    }
    
    // Adds custom styles to the Navigation Bar and back button.
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
    
    // Gives format to the values of height and length according to the given unit type and size.
    func customize(height value: String, for type: UnitType) -> String{
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
            if value.contains("."){
                let fromIndex = value.index(value.startIndex, offsetBy: 2)
                return "\(value.substring(to: toIndex)).\(value.substring(from: fromIndex))in"
            }
            else  {
                return "\(value.substring(to: toIndex)).\(value.substring(from: fromIndex))m"
            }
        }
        else {
            if value.contains("."){
                let fromIndex = value.index(value.startIndex, offsetBy: 2)
                return "\(value.substring(to: toIndex)).\(value.substring(from: fromIndex))in"
            }
            else {
                return "\(value.substring(to: toIndex)).\(value.substring(from: fromIndex))in"
            }
            
            }
        case 4: let index = value.index(value.startIndex, offsetBy: 2)
        if type == .englishMetric {
            return "0.\(value.substring(to: index))m"
        }
        else {
            return "0.\(value.substring(to: index))in"
            }
        case 5:
            let toIndex = value.index(value.startIndex, offsetBy: 1)
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
            fatalError()
        }
    }
    
    // Sets the corresponding text to the labels in case the entity be a Vehicle or a Starship.
    func setLabelComponents(){
        labelCollection[0].text = "Make"
        labelCollection[1].text = "Cost"
        labelCollection[2].text = "Length"
        labelCollection[3].text = "Class"
        labelCollection[4].text = "Crew"
    }
    
    
    // - ERRORS
    
    // Create an UIAlertController to show the error.
    func createAlert(with message: String, for typeOfItem: ElementType, url: String?){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            //execute some code when this option is selected
            switch typeOfItem {
            case .character: self.searchForPeople()
            case .vehicle: self.searchForVehicles()
            case .starship: self.searchForStarships()
            case .planet:
                if let url = url {
                    self.lookupPlanet(by: url)
                }
            case .other: return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Creates and Alert according to the error and the type of entity (Character, Vehicle or Starship).
    func show(error: APIError, for typeOfElement: ElementType, url: String?){
        if case .invalidData = error {
            self.createAlert(with: "Invalid data", for: typeOfElement, url: url)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        else {
            if case .jsonParsingFailure(message: "JSON data does not contain reuslts") = error {
                self.createAlert(with: "JSON Parsing Failure", for: typeOfElement, url: url)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            else {
                if case .jsonConversionFailure = error {
                    self.createAlert(with: "JSON Conversion Failure", for: typeOfElement, url: url)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                else {
                    if case .requestFailed = error {
                        self.createAlert(with: "Request Failed", for: typeOfElement, url: url)
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    else {
                        if case .responseUnsuccessful = error {
                            self.createAlert(with: "Unsuccessful Response", for: typeOfElement, url: url)
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                        else {
                            self.createAlert(with: "Entered number can't be negative neither 0", for: typeOfElement, url: url)
                        }
                    }
                }
            }
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

//
//  FirstViewController.swift
//  Assignment4
//
//  Created by prashant joshi on 10/20/17.
//  Copyright © 2017 prashant joshi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sportPicker: UIPickerView!
    @IBOutlet weak var sportSlider: UISlider!
    
    var countryAndSportsList:Dictionary<String,Array<String>>?
    var listOfCountries:Array<String>?
    var selectedCountry:String?
    var listOfSports:Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(sportPicker != nil){
            sportPicker.dataSource = self
            sportPicker.delegate = self
        }
        let data:Bundle = Bundle.main
        let sportPlist:String? = data.path(forResource: "sports", ofType: "plist")
        if sportPlist != nil {
            countryAndSportsList = (NSDictionary.init(contentsOfFile: sportPlist!) as! Dictionary)
            listOfCountries = countryAndSportsList?.keys.sorted()
            selectedCountry = listOfCountries![0]
            listOfSports = countryAndSportsList![selectedCountry!]!.sorted()
        }
        sportSlider.setValue(0, animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard (listOfCountries != nil) && listOfSports != nil else { return 0 }
        sportSlider.minimumValue = 0
        sportSlider.maximumValue = Float((listOfSports?.count)!)-1
        switch component {
        case 0: return listOfCountries!.count
        case 1: return listOfSports!.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        guard (listOfCountries != nil) && listOfSports != nil else { return "None" }
        sportSlider.minimumValue = 0
        sportSlider.maximumValue = Float((listOfSports?.count)!)-1
        switch component {
        case 0: return listOfCountries![row]
        case 1: return listOfSports![row]
        default: return "None"
        }
    }

    @IBAction func sportSliderValueChanged(_ sender: UISlider) {
        sportSlider.minimumValue = 0
        sportSlider.maximumValue = Float((listOfSports?.count)!)-1
        sportPicker.selectRow(Int(sportSlider.value), inComponent: 1, animated: true)
        sportPicker.delegate = self
        sportPicker.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        guard (listOfCountries != nil) && listOfSports != nil else { return }
        
        if component == 0 {
            sportSlider.minimumValue = 0
            sportSlider.maximumValue = Float((listOfSports?.count)!)-1
            selectedCountry = listOfCountries![row]
            listOfSports = countryAndSportsList![selectedCountry!]!.sorted()
            pickerView.reloadComponent(1)
        }
        
        if(component == 1){
            sportSlider.minimumValue = 0
            sportSlider.maximumValue = Float((listOfSports?.count)!)-1
            let n = row
            sportSlider.setValue(Float(n), animated: true)
        }
    }


}


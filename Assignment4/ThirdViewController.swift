//
//  ThirdViewController.swift
//  Assignment4
//
//  Created by prashant joshi on 10/21/17.
//  Copyright © 2017 prashant joshi. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var alertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.keyboardType = .asciiCapable
        textView.returnKeyType = UIReturnKeyType.done
        switchButton.isOn = false
        activityIndicatorView.stopAnimating()
        segment.selectedSegmentIndex = 0
        textView.isHidden = true
        alertButton.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onSegmentChange(_ sender: Any) {
        hideKeyboard()
        switch segment.selectedSegmentIndex{
        case 0:
            switchButton.isHidden = false
            activityIndicatorView.isHidden = false
            textView.isHidden = true
            alertButton.isHidden = true
        case 1:
            switchButton.isHidden = true
            activityIndicatorView.isHidden = true
            alertButton.isHidden = true
            textView.isHidden = false
        case 2:
            switchButton.isHidden = true
            activityIndicatorView.isHidden = true
            textView.isHidden = true
            alertButton.isHidden = false
        default:
            break;
        }
    }
    
    @IBAction func onSwitchOnOff(_ sender: Any) {
        if(switchButton.isOn){
            activityIndicatorView.startAnimating()
        }
        else{
            activityIndicatorView.stopAnimating()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            view.endEditing(false)
            return false
        }
        else{
            return true
        }
    }
    
    @IBAction func onAlertButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Do you like the iPhone?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
    }
}

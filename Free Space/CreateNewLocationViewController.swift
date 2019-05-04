//
//  CreateNewLocationViewController.swift
//  Free Space
//
//  Created by BC Swift Student Loan 1 on 4/29/19.
//  Copyright © 2019 Richard Li. All rights reserved.
//

import UIKit

class CreateNewLocationViewController: UIViewController {
    var location = Location()
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.text = location.address
        print("\(location.coordinate)")
    }
    
    @IBAction func locationNameDoneKeyPressed(_ sender: UITextField) {
        location.name = locationNameTextField.text ?? ""
        locationNameTextField.resignFirstResponder()
        print("\(location.name)")
    }
    @IBAction func addressDoneKeyPressed(_ sender: UITextField) {
        location.address = addressTextField.text ?? ""
        addressTextField.resignFirstResponder()
        print("\(location.address)")
    }
    @IBAction func locationNameTapped(_ sender: UITextField) {
        locationNameTextField.becomeFirstResponder()
    }
    @IBAction func addressTapped(_ sender: UITextField) {
        addressTextField.becomeFirstResponder()
    }
    @IBAction func nextPressed(_ sender: UIBarButtonItem) {
        location.name = locationNameTextField.text ?? ""
        addressTextField.text = location.address
        performSegue(withIdentifier: "AddNewSubLocationWithNewLocation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewSubLocationWithNewLocation" {
            let destination = segue.destination as! CreateNewSublocationViewController
            destination.location = self.location
        }
    }
}

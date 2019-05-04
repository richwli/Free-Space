//
//  CreateNewSublocationViewController.swift
//  Free Space
//
//  Created by BC Swift Student Loan 1 on 4/29/19.
//  Copyright © 2019 Richard Li. All rights reserved.
//

import UIKit

class CreateNewSublocationViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var additionalDescriptionTextView: UITextView!
    
    var location: Location!
    //var sublocation: Sublocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sublocation = Sublocation()
        self.additionalDescriptionTextView.delegate = self
    }
    
    @IBAction func floorDoneButtonPressed(_ sender: UITextField) {
        location.room = floorTextField.text ?? ""
        floorTextField.resignFirstResponder()
    }
    @IBAction func roomDoneButtonPressed(_ sender: UITextField) {
        location.floor = roomNumberTextField.text ?? ""
        roomNumberTextField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            location.description = additionalDescriptionTextView.text ?? ""
            additionalDescriptionTextView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func floorTapped(_ sender: UITextField) {
        floorTextField.becomeFirstResponder()
    }
    @IBAction func roomTapped(_ sender: UITextField) {
        roomNumberTextField.becomeFirstResponder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        additionalDescriptionTextView.becomeFirstResponder()
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewController
        location.room = floorTextField.text ?? "" //I reversed the labels whoops
        location.floor = roomNumberTextField.text ?? ""
        location.description = additionalDescriptionTextView.text ?? ""
        location.saveData() { success in
            if success {
                print("Segue success!")
            } else {
                print("^^^ Final segue failure!!!")
            }
        }
    }
    

}

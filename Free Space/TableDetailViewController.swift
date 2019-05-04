//
//  TableDetailViewController.swift
//  Free Space
//
//  Created by BC Swift Student Loan 1 on 4/29/19.
//  Copyright © 2019 Richard Li. All rights reserved.
//

import UIKit

class TableDetailViewController: UIViewController {
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    var location = Location()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationNameLabel.text = location.name
        addressLabel.text = location.address
        floorLabel.text = location.floor
        roomNumberLabel.text = location.room
        additionalInfoLabel.text = location.description
        // Do any additional setup after loading the view.
    }

}

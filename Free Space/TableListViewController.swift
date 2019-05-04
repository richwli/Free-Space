//
//  TableListViewController.swift
//  Free Space
//
//  Created by BC Swift Student Loan 1 on 4/25/19.
//  Copyright © 2019 Richard Li. All rights reserved.
//

import UIKit

class TableListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var locations: Locations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        locations = Locations()
}
    
    override func viewWillAppear(_ animated: Bool) {
        locations.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTableDetailSegue" {
            let destination = segue.destination as! TableDetailViewController
            let index = self.tableView.indexPathForSelectedRow!
            destination.location = locations.locationsArray[index.row]
        }
    }
}

extension TableListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = locations.locationsArray[indexPath.row].name
        return cell
    }
}

//
//  locations.swift
//  Free Space
//
//  Created by BC Swift Student Loan 1 on 4/28/19.
//  Copyright © 2019 Richard Li. All rights reserved.
//

import Foundation
import Firebase

class Locations {
    var locationsArray: [Location] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    func loadData(completed: @escaping () -> ())  {
        db.collection("locations").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.locationsArray = []
            // there are querySnapshot!.documents.count documents in teh spots snapshot
            for document in querySnapshot!.documents {
                let location = Location(dictionary: document.data())
                location.documentID = document.documentID
                self.locationsArray.append(location)
            }
            completed()
        }
    }
}

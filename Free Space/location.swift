//
//  location.swift
//  Free Space
//
//  Created by BC Swift Student Loan 1 on 4/28/19.
//  Copyright © 2019 Richard Li. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import Firebase

class Location {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var documentID: String
    var postingUserID: String
    var floor: String
    var room: String
    var description: String
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "longitude": longitude, "latitude": latitude, "floor": floor, "room": room, "description": description]
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, postingUserID: String, documentID: String, floor: String, room: String, description: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.postingUserID = postingUserID
        self.documentID = documentID
        self.floor = floor
        self.room = room
        self.description = description
    }
    
    convenience init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), postingUserID: "", documentID: "", floor: "", room: "", description: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let floor = dictionary["floor"] as! String? ?? ""
        let room = dictionary["room"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        self.init(name: name, address: address, coordinate: coordinate, postingUserID: postingUserID, documentID: "", floor: floor, room: room, description: description)
    }
    
    func saveData(completed: @escaping(Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        // if we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("locations").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("locations").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
}

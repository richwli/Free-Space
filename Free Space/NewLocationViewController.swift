//
//  NewLocationViewController.swift
//  Free Space
//
//  Created by BC Swift Student Loan 1 on 4/28/19.
//  Copyright © 2019 Richard Li. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewLocationViewController: UIViewController {
    var region: MKCoordinateRegion!
    let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
    var previousLocation: CLLocation?
    let locationManager = CLLocationManager()
    var address: String!
    var coordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        trackUserLocation()
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation (latitude: latitude, longitude: longitude)
    }
    
    func trackUserLocation() {
        mapView.setRegion(region, animated: true)
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
        //print("\(previousLocation)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewLocationSegue" {
            let destination = segue.destination as! CreateNewLocationViewController
            destination.location.address = self.address ?? ""
            destination.location.coordinate = self.coordinates ?? getCenterLocation(for: mapView).coordinate
        }
    }
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        // Segues to setting up details
        performSegue(withIdentifier: "AddNewLocationSegue", sender: nil)
    }
    
    
}
extension NewLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager){
        //print ("Hello World 1")
        trackUserLocation()
    }
}

extension NewLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        //print ("Hello World 2")
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        guard let previousLocation = self.previousLocation else {return}
        
        guard center.distance(from: previousLocation) > 25 else {return}
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks,error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
        
            guard let placemark = placemarks?.first else {
                return
            }
            let name = placemark.name ?? ""
            let subthoroughfare = placemark.subThoroughfare ?? ""
            let thoroughfare =  placemark.thoroughfare ?? ""
            let locality = placemark.thoroughfare ?? ""
            self.address = "\(subthoroughfare) \(thoroughfare)"
            self.coordinates = center.coordinate
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(self.address!)"
                //self.addressLabel.text = "\(subthoroughfare) \(thoroughfare)"
                
            }
            
        }
    }
}

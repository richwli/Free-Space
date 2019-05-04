//
//  ViewController.swift
//  Free Space
//
//  Created by BC Swift Student Loan 1 on 4/11/19.
//  Copyright © 2019 Richard Li. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseUI
import GoogleSignIn


class ViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
    var region: MKCoordinateRegion!
    var authUI: FUIAuth!
    var locations: Locations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
        checkLocationServices()
        setupLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locations = Locations()
        getAnnotations()
    }
    //print("\(locationManager)")
    
    func getAnnotations() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        locations.loadData { ()
            for location in self.locations.locationsArray {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = location.name
                annotation.subtitle = "Floor: \(location.floor), Room: \(location.room)"
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        signIn()
        getRegion()
        getAnnotations()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
        ]
        if authUI.auth?.currentUser == nil {
            self.authUI.providers = providers
            present(authUI.authViewController(),animated: true, completion: nil)
        }
    }
    
    func getRegion() {
        if let location = locationManager.location {
             let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            let region = MKCoordinateRegion(center: myLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //
    }
    }
    
    func checkLocationAuthorization () {
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            addBarButton.isEnabled = true
            mapView.showsUserLocation = true
            getRegion()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            addBarButton.isEnabled = false
            break
        case .notDetermined:
            addBarButton.isEnabled = false
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            addBarButton.isEnabled = false
            break
        case .authorizedAlways:
            break
        }
    }
    @IBAction func unwindToViewController(_ sender: UIStoryboardSegue){}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewLocationSegue" {
            let destination = segue.destination as! NewLocationViewController
            destination.region = self.region
        }
        
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
         performSegue(withIdentifier: "NewLocationSegue", sender: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print ("We signed out bois")
            signIn()
        } catch {
            print("We cannot signout bois")
        }
}
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        region = MKCoordinateRegion.init(center: myLocation, span: span)
        
        //mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            print("*** We signed in with the user \(user.email ?? "unknown e-mail" )")
    }
}
}

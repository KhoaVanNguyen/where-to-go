//
//  ViewController.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/24/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreLocation
import MapKit
class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    let locationAuthStatus = CLLocationManager.authorizationStatus()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        configureAuthorizedStatus()
        addTapGesture()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dropPin))
        tap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(tap)
    }
    
    @IBAction func center_TouchUpInside(_ sender: Any) {
        centerUserOnMapView()
    }
}
extension MapVC: MKMapViewDelegate{
    func centerUserOnMapView(){
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
        
    }
    
    func dropPin(){
        print("Hello")
    }
}
extension MapVC: CLLocationManagerDelegate{
    func configureAuthorizedStatus(){
        if locationAuthStatus == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            centerUserOnMapView()
        }
    }
}



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
class MapVC: UIViewController, UIGestureRecognizerDelegate {

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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dropPin(sender:)))
        tap.numberOfTapsRequired = 2
//        tap.delegate = self
        mapView.addGestureRecognizer(tap)
    }
    
    @IBAction func center_TouchUpInside(_ sender: Any) {
        centerUserOnMapView(withCoordinate: nil)
    }
}
extension MapVC: MKMapViewDelegate{
    func centerUserOnMapView(withCoordinate pinCoordinate : CLLocationCoordinate2D?){
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
        
        if pinCoordinate != nil {
             let region = MKCoordinateRegionMakeWithDistance(pinCoordinate!, 1000, 1000)
             mapView.setRegion(region, animated: true)
        }else {
             let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
             mapView.setRegion(region, animated: true)
        }
        
        
        
    }
    
    func dropPin(sender: UIGestureRecognizer){
        removePin()
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        let pin = DropPin(coordinate: coordinate, indentifier: "droppablePin")
        
        mapView.addAnnotation(pin)
        centerUserOnMapView(withCoordinate: coordinate)
    }
    func removePin() {
        for anno in mapView.annotations{
            mapView.removeAnnotation(anno)
        }
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
            centerUserOnMapView(withCoordinate: nil)
        }
    }
}



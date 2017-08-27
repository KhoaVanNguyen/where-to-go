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
import Alamofire
class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    var job: String = "android"
    
    var jobs = [Job]()
    
    @IBOutlet weak var pullUpViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    let screenSize = UIScreen.main.bounds
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    var locationManager = CLLocationManager()
    let locationAuthStatus = CLLocationManager.authorizationStatus()
    
    
    var collectionView: UICollectionView?
    var flowLayout = UICollectionViewLayout()
    
    var urlArrays = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        configureAuthorizedStatus()
        addTapGesture()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        
        
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        pullUpView.addSubview(collectionView!)
        
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
    
    func animatePullUpView(){
        pullUpViewConstraint.constant = 250
       
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    func addSwipe(){
        let pullDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.closePullUpView))
        pullDownGesture.direction = .down
        pullUpView.addGestureRecognizer(pullDownGesture)
    
    }
    func closePullUpView(){
        pullUpViewConstraint.constant = 1
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    func addSpinner(){
        
        spinner?.removeFromSuperview()
        
        
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2 ), y: 100)
        spinner?.tintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        spinner?.color = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        spinner?.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        spinner?.activityIndicatorViewStyle = .gray
        spinner?.startAnimating()
        pullUpView.addSubview(spinner!)
    }
    func addProgressLbl(){
        
        progressLbl?.removeFromSuperview()
        
        progressLbl = UILabel()
        
        progressLbl?.text = "12/50 photos loading..."
        progressLbl?.textColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        progressLbl?.translatesAutoresizingMaskIntoConstraints = false
        pullUpView.addSubview(progressLbl!)
        progressLbl?.textAlignment = .center
        
        
        progressLbl?.centerXAnchor.constraint(equalTo:  pullUpView.centerXAnchor ).isActive = true
        
        progressLbl?.centerYAnchor.constraint(equalTo: pullUpView.centerYAnchor, constant: 50).isActive = true
        progressLbl?.leadingAnchor.constraint(equalTo: pullUpView.leadingAnchor).isActive = true
        progressLbl?.trailingAnchor.constraint(equalTo: pullUpView.trailingAnchor).isActive = true
        progressLbl?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    
    func downloadJobs(url: String, handler: @escaping (_ status: Bool) -> Void){
       Alamofire.request(url).responseJSON { (response) in
        if response.result.error != nil {
            return
        }else {
          
            if let data = response.result.value as? [String:Any]{
                
                if let jobs = data["results"] as? [[String:Any]]{
                    
                    for element in jobs{
                        let job = Job(job: element)
                        self.jobs.append(job)
                    }
                    self.collectionView?.reloadData()
                }
                
                
                
            }
    
            handler(true)
        }
        }
    }
}
extension MapVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pin.animatesDrop = true
        pin.pinTintColor = UIColor.blue
        return pin
    }
    
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
        animatePullUpView()
        addSwipe()
        addSpinner()
        addProgressLbl()
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        let pin = DropPin(coordinate: coordinate, indentifier: "droppablePin")
        
        let location = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        reverseGeocoding(location: location) { (dict) in
            
            let city = dict["City"] as! String
            let country = dict["CountryCode"] as! String
            let url = getIndeedURL(job: self.job, location: city, radius: 25, jt: "fulltime", co: country)
            
            let strimUrl = url.components(separatedBy: " ").joined(separator: "%20")

            self.downloadJobs(url: strimUrl, handler: { (handler) in
                if handler {
                    print("success")
                    print(self.jobs.count)
                }
            })
        }
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
extension MapVC: UICollectionViewDelegate{
    
}
extension MapVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        return cell
    }
}



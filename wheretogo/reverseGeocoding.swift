//
//  reverseGeocoding.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/26/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import CoreLocation
func reverseGeocoding(location: CLLocation, complete: @escaping (_ dict: [AnyHashable:Any] ) -> Void) {
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
        if error != nil {
            return
        }else {
            guard let placemark = placemarks?[0] else {
                return
            }
            
            guard let dict = placemark.addressDictionary else {
                return
            }
            
            complete(dict)
            
//            if let city = placemark.addressDictionary?["ZIP"] as? String{
//                print(city)
//                complete(city)
//                
//            }
        }
    }

}

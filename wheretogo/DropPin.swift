//
//  DropPin.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/24/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import MapKit

class DropPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var indentifier: String
    init(coordinate: CLLocationCoordinate2D, indentifier: String){
        self.coordinate = coordinate
        self.indentifier = indentifier
        super.init()
    }
}

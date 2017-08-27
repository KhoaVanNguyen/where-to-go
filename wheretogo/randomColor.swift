//
//  randomColor.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/27/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import UIKit
func randomColor() -> UIColor {
    let red = CGFloat(arc4random()) / CGFloat(UInt32.max)
    let green = CGFloat(arc4random()) / CGFloat(UInt32.max)
    
    let blue = CGFloat(arc4random()) / CGFloat(UInt32.max)
    
    let randomColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    return randomColor
}

//
//  ImageExtension.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/27/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation

import UIKit


func getImageView(withText text: NSString) -> UIImageView{
    let imageView = UIImageView(frame: CGRect(x: 50, y: 120, width: 60, height: 60))
    //
    let font = UIFont(name: "Helvetica", size: 80)
    let point = CGPoint(x: 0, y: 0)
    
    let image = UIImage(named: "white")?.maskWithColor(color: randomColor()).addText(text: text, atPoint: point, textColor: UIColor.black, textFont: font)
    
    imageView.image = image
    
    return imageView
}

extension UIImage{
    func addText(text: NSString,atPoint point: CGPoint, textColor: UIColor?, textFont: UIFont?) -> UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        
        let defaultFont = UIFont(name: "Helvetica", size: 40)
        
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let textAttributes = [
            NSFontAttributeName: textFont ?? defaultFont!,
            NSForegroundColorAttributeName: textColor ?? UIColor.black,
            NSParagraphStyleAttributeName: style,
            NSBaselineOffsetAttributeName: NSNumber(value: 0)
            
            ] as [String:Any]
        
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        
        let rect = CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
        
        text.draw(in: rect, withAttributes: textAttributes)
        
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImage {
    
    public func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
    
}

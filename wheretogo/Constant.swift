//
//  Constant.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/25/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation

//let FlickrKey = "9f5016b5ed8fd47a29b9dc9bc6d06366"

let BASE_URL = "http://api.indeed.com/ads/apisearch?publisher=2771142258014455"

func getIndeedURL(job: String,location: String,radius: Int,jt: String, co: String) -> String{
    return "\(BASE_URL)&q=\(job)&l=\(location)&radius=\(radius)&jt=\(jt)&co=\(co)&v=2&format=json"
}





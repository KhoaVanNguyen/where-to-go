//
//  Job.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/27/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation


struct Job {
    var jobtitle: String
    var company: String
    var date: String
    var snippet: String
    var url: String
    var jobkey: String
    
    init(jobTitle: String, company: String,date: String, snippet: String, url: String, jobKey: String) {
        self.jobkey = jobKey
        self.jobtitle = jobTitle
        self.company = company
        self.date = date
        self.snippet = snippet
        self.url = url
    }
    
    init(job: [String:Any]) {
//        if let jobtitle = job["jobtitle"] as? String {
//            self.jobtitle = jobtitle
//        }
//        if let company = job["company"] as? String {
//            self.company = company
//        }
//        if let date = job["date"] as? String {
//            self.date = date
//        }
//        if let snippet = job["snippet"] as? String {
//            self.snippet = snippet
//        }
//        if let url = job["url"] as? String {
//            self.url = url
//        }
//        if let jobkey = job["jobkey"] as? String {
//            self.jobkey = jobkey
//        }
        
        self.jobtitle = job["jobtitle"] as! String
        self.company = job["company"] as! String
        self.date = job["date"] as! String
        self.snippet = job["snippet"] as! String
        self.url = job["url"] as! String
        self.jobkey = job["jobkey"] as! String
    }
}















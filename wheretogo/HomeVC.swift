//
//  HomeVC.swift
//  wheretogo
//
//  Created by Khoa Nguyen on 8/27/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var jobTF: FancyTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func next_TouchUpInside(_ sender: Any) {
        guard let job = jobTF.text else {
            return
        }
        
        
        performSegue(withIdentifier: "toGoMapView", sender: job )
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGoMapView" {
            if let mapVC = segue.destination as? MapVC{
                if let jobTitle = sender as? String{
                    mapVC.job = jobTitle
                }
            }
        }
    }
}



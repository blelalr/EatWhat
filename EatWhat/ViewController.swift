//
//  ViewController.swift
//  EatWhat
//
//  Created by eros.chen on 2017/3/8.
//  Copyright © 2017年 eros.chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController{

    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet  var map: MKMapView!
    
    let distance = 0// 0.3~2.0 km default 0.5km
    var currentLocation : CLLocation?
    
    let locationManager = LocationManager()
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        distanceLable.text = String(format: "%.1f", sender.value)
        
    }
    @IBAction func searchClickListener(_ sender: Any) {
//                     .requestLocation(completionHandler: { currentLocation in }
        locationManager.requestLocation { (currentLocation) in
            print("from ViewController: \(currentLocation)")
        }
        
    }
    
}


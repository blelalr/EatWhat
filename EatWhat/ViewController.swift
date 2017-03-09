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

class ViewController: UIViewController, LocationUpdateProtocol {

    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet  var map: MKMapView!
    
    let distance = 0// 0.3~2.0 km default 0.5km
    var currentLocation : CLLocation?
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        distanceLable.text = String(format: "%.1f", sender.value)
        
    }
    @IBAction func searchClickListener(_ sender: Any) {

        let locationMgr = LocationManager.SharedManager
        locationMgr.delegate = self
        locationMgr.requestLocation()
        
    }
    
    //LocationUpdateProtocol
    func locationDidUpdateToLocation(location: CLLocation) {
        currentLocation = location
        let latitude  = currentLocation?.coordinate.latitude
        let longitude = currentLocation?.coordinate.longitude
        
        print("******* Current Location *******")
        print("Latitude : \(latitude)")
        print("Longitude : \(longitude)")
        print("*********************************")
        
//        setUI()
    }
    
    func setUI(){
    
        
        
    }

}


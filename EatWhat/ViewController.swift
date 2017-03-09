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
    
    var currentLocation : CLLocation!
    
    @IBAction func searchClickListener(_ sender: Any) {

        let locationMgr = LocationManager.SharedManager
        locationMgr.delegate = self
        locationMgr.requestLocation()
    }
    
    //LocationUpdateProtocol 
    func locationDidUpdateToLocation(location: CLLocation) {
        currentLocation = location
        print("Latitude : \(self.currentLocation.coordinate.latitude)")
        print("Longitude : \(self.currentLocation.coordinate.longitude)")
    }

}


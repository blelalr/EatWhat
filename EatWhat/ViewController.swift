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

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet  var map: MKMapView!
    let locationManager = CLLocationManager()
    @IBAction func searchClickListener(_ sender: Any) {
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLocations")
        
        let location = locations.first!
        print("\(location.coordinate)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("didFailWithError")
        
    }

}


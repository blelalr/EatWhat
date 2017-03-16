//
//  ViewController.swift
//  EatWhat
//
//  Created by eros.chen on 2017/3/8.
//  Copyright © 2017年 eros.chen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController{

    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var resultDistanceLabel: UILabel!
    @IBOutlet weak var resultTimeLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    let distance = 0// 0.3~2.0 km default 0.5km
    
    let locationManager = LocationManager()
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        distanceLable.text = String(format: "%.1f", sender.value)
        
    }
    @IBAction func searchClickListener(_ sender: Any) {
//                     .requestLocation(completionHandler: { currentLocation in }
        locationManager.requestLocation { (location) in
            print("from ViewController: \(location)")
            self.apiGetRestaurant(location: location)
        }
        
        
        
    }
    
    func apiGetRestaurant(location:CLLocation){
        let distance = self.sliderBar.value
        let session = URLSession.shared
        
        let url = URL(string: "https://food-locator-dot-hpd-io.appspot.com/v1/location_query?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&distance=\(distance)")!
        
        print("\(url)")
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("API下載錯誤: \(error)")
                return
            }
            
            let data = data!
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let results = jsonObject as? [[String: Any]], let firstResult = results.first {
                
                let currentLocationPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
                let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark)
                
                let latitude = firstResult["latitude"] as! Double
                let longitude = firstResult["longitude"] as! Double
                
                let destionationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let destinationPlacemark = MKPlacemark(coordinate: destionationCoordinate, addressDictionary: nil)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                
                let request = MKDirectionsRequest()
                request.source = currentLocationMapItem
                request.destination = destinationMapItem
                request.transportType = .walking
                
                let directions = MKDirections(request: request)
                directions.calculateETA(completionHandler: { response, error in
                    
                    if let error = error {
                        print("路徑規劃錯誤: \(error)")
                        return
                    }
                    
                    let response = response!
                    print("結果: \(response.expectedTravelTime / 60.0), \(response.distance)")
                    
                    print("\(firstResult)")
                    
                    let pointAnnotation  = MKPointAnnotation()
                    pointAnnotation.coordinate = destionationCoordinate
                    self.map.removeAnnotations(self.map.annotations)
                    self.map.addAnnotation(pointAnnotation)
                    self.map.showsUserLocation = true
                    
                    let degree = 1/111 * 0.5
                    var mapRegion = MKCoordinateRegion()
                    mapRegion.center = destionationCoordinate
                    mapRegion.span.latitudeDelta = degree
                    mapRegion.span.longitudeDelta = degree
                    
                    self.map.setRegion(mapRegion, animated: true)
                    
                
                    
                    
                })
                
                
//                self.storeNameLabel.text = firstResult["name"] as! String
//                self.ratingLabel.text = "\(firstResult["rating"] as! Double)"
//                self.addressLabel.text = firstResult["address"] as! String
            }
            
        })
        
        task.resume()
    }
    
}


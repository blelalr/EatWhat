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
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var storeImage: UIImageView!
    
    let distance = 0// 0.3~2.0 km default 0.5km
    let locationManager = LocationManager()
    var phone: String?
    
    let queue = DispatchQueue.global(qos: .background)
    var time:DispatchTime! {
        return DispatchTime.now() + 1.0 // seconds
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        distanceLable.text = String(format: "%.1f", sender.value)
        
    }
    
    @IBAction func callStore(_ sender: Any) {
        
        guard let number = URL(string: "telprompt://" + phone!) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
        
    }
    @IBAction func searchClickListener(_ sender: Any) {
//                     .requestLocation(completionHandler: { currentLocation in }
        locationManager.requestLocation { (location) in
            print("from ViewController: \(location)")
            self.startTask(curLocation: location)
        }
    }
    
    func startTask(curLocation: CLLocation){
        let distance = self.sliderBar.value
        let session = URLSession.shared
        
        let url = URL(string: "https://food-locator-dot-hpd-io.appspot.com/v1/location_query?latitude=\(curLocation.coordinate.latitude)&longitude=\(curLocation.coordinate.longitude)&distance=\(distance)")!
        
        print("\(url)")
        
        queue.async(execute: {
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("API下載錯誤: \(error)")
                    return
                }
                
                let data = data!
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let results = jsonObject as? [[String: Any]] {
                    let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
                    print("\(results[randomIndex])")
                    DispatchQueue.main.asyncAfter(deadline: self.time, execute:{
                        DispatchQueue.main.async {
                            self.setData(result: results[randomIndex])
                        }
                        OperationQueue().addOperation {
                            self.getStoreImageFromURL(result: results[randomIndex])
                        }
                        OperationQueue().addOperation {
                            self.drawMap(result: results[randomIndex], curLocation: curLocation)
                        }
                        
                    })
                }
                
            })
            task.resume()
        })
        
    }
    
    func setData(result:[String: Any]){
        self.storeLabel.text = (result["name"] as! String)
        self.rateLabel.text = "\(result["rating"] as! Double)"
        self.address.text = (result["address"] as! String)
        self.phone = (result["phone"] as! String)
    }
    
    func drawMap(result: [String : Any], curLocation: CLLocation){
        let currentLocationPlacemark = MKPlacemark(coordinate: curLocation.coordinate, addressDictionary: nil)
        let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark)
        
        let latitude = result["latitude"] as! Double
        let longitude = result["longitude"] as! Double
        
        let destionationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let destinationPlacemark = MKPlacemark(coordinate: destionationCoordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirectionsRequest()
        request.source = currentLocationMapItem
        request.destination = destinationMapItem
        request.transportType = .walking
        
        //        let directions = MKDirections(request: request)
        //        directions.calculate(completionHandler: { (response : MKDirectionsResponse?, error : Error?) in
        //            response?.routes.first?.polyline
        //        })
        
        
        let directions = MKDirections(request: request)
        directions.calculateETA(completionHandler: { response, error in
            
            if let error = error {
                print("路徑規劃錯誤: \(error)")
                return
            }
            
            let response = response!
            print("結果: \(response.expectedTravelTime / 60.0), \(response.distance)")
            DispatchQueue.main.async {
                self.resultTimeLabel.text = "\(String(format: "%.1f", response.expectedTravelTime / 60.0)) 分鐘"
                self.resultDistanceLabel.text = "\(response.distance) 公尺"
            }
            
            
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
    }

    
    func getStoreImageFromURL(result: [String : Any]){
        var imageData = (data: Data())
        let url = URL(string: result["photo"] as! String)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            imageData.append(data!)
        
            if error == nil{
                DispatchQueue.main.async {
                    self.storeImage.image = UIImage(data: imageData)
                }
            }
            
        })
        dataTask.resume()
        
    }
    
}


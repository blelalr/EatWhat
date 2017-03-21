//
//  MyDataSource.swift
//  EatWhat
//
//  Created by Eros on 2017/3/20.
//  Copyright © 2017年 eros.chen. All rights reserved.
//

import UIKit
import MapKit


class StoreListCell: UITableViewCell {
    var phone: String?
    @IBOutlet weak var cellStoreName: UILabel!
    @IBOutlet weak var cellRate: UILabel!
    @IBOutlet weak var cellDistance: UILabel!
    @IBOutlet weak var cellTime: UILabel!
    @IBOutlet weak var cellAddress: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBAction func cellActionCall(_ sender: Any) {
        guard let number = URL(string: "telprompt://" + phone!) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
}

class MyDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var resultList: [[String: Any]]?
    var curLocation: CLLocation?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datasource = resultList {
            return datasource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell", for: indexPath) as! StoreListCell
        if let result = resultList {
            cell.cellStoreName.text = (result[indexPath.row]["name"] as! String)
            cell.cellRate.text = "\(result[indexPath.row]["rating"] as! Double)"
            cell.cellAddress.text = (result[indexPath.row]["address"] as! String)
            cell.phone = (result[indexPath.row]["phone"] as! String)
            var imageData = Data()
            let url = URL(string: result[indexPath.row]["photo"] as! String)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                imageData.append(data!)
                if error == nil{
                    DispatchQueue.main.async {
                        cell.cellImage.image = UIImage(data: imageData)
                    }
                }
                
            })
            dataTask.resume()
            
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let result = resultList {
//            self.drawMap(result:result[indexPath.row])
        }
    
        
    }
    
//    func drawMap(result: [String : Any]){
//        let currentLocationPlacemark = MKPlacemark(coordinate: (curLocation?.coordinate)!, addressDictionary: nil)
//        let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark)
//        
//        let latitude = result["latitude"] as! Double
//        let longitude = result["longitude"] as! Double
//        
//        let destionationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let destinationPlacemark = MKPlacemark(coordinate: destionationCoordinate, addressDictionary: nil)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//        
//        let request = MKDirectionsRequest()
//        request.source = currentLocationMapItem
//        request.destination = destinationMapItem
//        request.transportType = .walking
//        
//        //        let directions = MKDirections(request: request)
//        //        directions.calculate(completionHandler: { (response : MKDirectionsResponse?, error : Error?) in
//        //            response?.routes.first?.polyline
//        //        })
//        
//        
//        let directions = MKDirections(request: request)
//        directions.calculateETA(completionHandler: { response, error in
//            
//            if let error = error {
//                print("路徑規劃錯誤: \(error)")
//                return
//            }
//            
//            let response = response!
//            print("結果: \(response.expectedTravelTime / 60.0), \(response.distance)")
//            DispatchQueue.main.async {
//                //                self.resultTimeLabel.text = "\(String(format: "%.1f", response.expectedTravelTime / 60.0)) 分鐘"
//                //                self.resultDistanceLabel.text = "\(Int(response.distance)) 公尺"
//            }
//            
//            
//            let pointAnnotation  = MKPointAnnotation()
//            pointAnnotation.coordinate = destionationCoordinate
//            self.map.removeAnnotations(self.map.annotations)
//            self.map.addAnnotation(pointAnnotation)
//            self.map.showsUserLocation = true
//            
//            let degree = 1/111 * 0.5
//            var mapRegion = MKCoordinateRegion()
//            mapRegion.center = destionationCoordinate
//            mapRegion.span.latitudeDelta = degree
//            mapRegion.span.longitudeDelta = degree
//            
//            self.map.setRegion(mapRegion, animated: true)
//            
//        })
//    }

    
}

//
//  ViewController.swift
//  EatWhat
//
//  Created by eros.chen on 2017/3/8.
//  Copyright © 2017年 eros.chen. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, UITableViewDelegate, MKMapViewDelegate{

    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!

    var distance: Double? // 0.3~2.0 km default 0.5km
    let locationManager = LocationManager()
    var dataResource = MyDataSource()
    var curLocation: CLLocation?
    var myRoute : MKRoute!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataResource
        tableView.delegate = self
        map.delegate = self
        requestLocation()
        
    }
    
    func requestLocation(){
        locationManager.requestLocation { (location, error) in
            if let error = error {
                self.locationErrorAlert(error: error)
                return
            }
            self.curLocation = location
            self.dataResource.curLocation = location
            self.startTask(curLocation: self.curLocation!)
        }
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        distanceLable.text = String(format: "%.1f", sender.value)
    }
    
    @IBAction func searchClickListener(_ sender: Any) {
        requestLocation()
    }
    
    func startTask(curLocation: CLLocation) {
        distance = Double(self.sliderBar.value)
        let session = URLSession.shared
        let url = URL(string: "https://food-locator-dot-hpd-io.appspot.com/v1/location_query?latitude=\(curLocation.coordinate.latitude)&longitude=\(curLocation.coordinate.longitude)&distance=\(distance!)")!
        print("\(url)")
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("API下載錯誤: \(error)")
                self.apiErrorAlert(error: error)
                return
            }
            let data = data!
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let results = jsonObject as? [[String: Any]] {
                self.dataResource.resultList = results
                DispatchQueue.main.async {
                        let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
                        self.drawMap(result: results[randomIndex])
                        self.tableView.reloadData()
                        self.tableView.selectRow(at: IndexPath.init(row: randomIndex, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.middle);
                }
            }
        })
        task.resume()
    }
    
    func apiErrorAlert(error: Error) {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "下載錯誤",
            message: "請確認網路連線狀態",
            preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "重新下載",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.startTask(curLocation: self.curLocation!)
        })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func locationErrorAlert(error: Error) {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "定位錯誤",
            message: "請確認是否開啟定位服務",
            preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "重新定位",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.requestLocation()
        })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let result = self.dataResource.resultList {
            print("\(result[indexPath.row])")
            drawMap(result: result[indexPath.row])
        }
    }
    
    func drawMap(result: [String : Any]){
        let currentLocationPlacemark = MKPlacemark(coordinate: self.curLocation!.coordinate, addressDictionary: nil)
        let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark)
        
        let destionationCoordinate = CLLocationCoordinate2D(latitude: result["latitude"] as! Double, longitude: result["longitude"] as! Double)
        let destinationPlacemark = MKPlacemark(coordinate: destionationCoordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirectionsRequest()
        request.source = currentLocationMapItem
        request.destination = destinationMapItem
        request.transportType = .walking
        
        DispatchQueue.main.async {
            
            let pointAnnotation  = MKPointAnnotation()
            pointAnnotation.coordinate = destionationCoordinate
            
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotation(pointAnnotation)
            self.map.showsUserLocation = true
            
            let directions = MKDirections(request: request)
            
            directions.calculate(completionHandler: {response, error in
                if error == nil {
                    if let route = self.myRoute {
                        self.map.remove(route.polyline)
                    }
                    self.myRoute = response!.routes[0] as MKRoute
                    self.map.add(self.myRoute.polyline)
                }
            })
            
            let degree = 1/111 * self.distance!
            var mapRegion = MKCoordinateRegion()
            mapRegion.center = destionationCoordinate
            mapRegion.span.latitudeDelta = degree
            mapRegion.span.longitudeDelta = degree
            
            self.map.setRegion(mapRegion, animated: true)
        }

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let myLineRenderer = MKPolylineRenderer(polyline: myRoute.polyline)
        myLineRenderer.strokeColor = UIColor.blue
        myLineRenderer.lineWidth = 5
        
        return myLineRenderer
    }
    
}


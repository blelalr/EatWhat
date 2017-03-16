import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var completionHandler: ((CLLocation) -> Void)?
    
    var isRequestingLocation = false
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(completionHandler: @escaping (CLLocation) -> Void) {
        self.completionHandler = completionHandler
        isRequestingLocation = true
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isRequestingLocation {
            return
        }
        
        isRequestingLocation = false
        let location = locations.first!
        completionHandler?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("didFailWithError")
        
    }
    
}

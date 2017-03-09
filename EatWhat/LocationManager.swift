import MapKit

protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation(location : CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let SharedManager = LocationManager()
    private var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var delegate : LocationUpdateProtocol!
    
    private override init () {
        super.init()
        self.locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocation(){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.first!
        self.delegate.locationDidUpdateToLocation(location: self.currentLocation!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("didFailWithError")
        
    }
    
}


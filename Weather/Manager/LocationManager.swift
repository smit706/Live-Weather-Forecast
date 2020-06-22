import UIKit
import CoreLocation

protocol LocationServiceDelegate {
    func currentLocation(location: CLLocation)
}

class LocationManager: NSObject {
    
    static let sharedInstane: LocationManager = {
        return LocationManager()
    }()
    var locationManager:CLLocationManager!
    var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }
}

//MARK: - Location manager delegate

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            if let delegate = self.delegate{
                delegate.currentLocation(location: location)
            }
        }
    }
}

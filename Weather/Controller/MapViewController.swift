//
//  MapViewController.swift
//  Weather
//
//  Created by Student on 2020-04-08.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var currentLocation: CLLocation!
    var currentTempretureData: CurrentWeatherData!
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomToUserLocation()
    }
    
    func zoomToUserLocation() {
       let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 25000, longitudinalMeters: 25000)
        //mapView.isZoomEnabled = true
        mapView.delegate = self
        mapView.setRegion(region, animated: true)
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        annotation.title = currentTempretureData.name
        annotation.subtitle = "Tempreture: \(Int(currentTempretureData.main.temp))° (\(currentTempretureData!.weather[0].main))"
        mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage.init(named: "MapPin")
        
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.selectAnnotation(annotation, animated: true)
    }
}

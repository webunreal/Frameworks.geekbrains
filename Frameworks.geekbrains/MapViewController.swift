//
//  MapViewController.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 31.03.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    private lazy var mapView: GMSMapView = {
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
        let camera = GMSCameraPosition.camera(withTarget: defaultCoordinate, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        return mapView
    }()
    private var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        
        configureLocationManager()
        findCurrentLocation()
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    
    private func findCurrentLocation() {
        locationManager?.requestLocation()
        locationManager?.startUpdatingLocation()
    }
    
    private func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15.0)
        addMarker(coordinate: coordinate)
        mapView.camera = camera
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

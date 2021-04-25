//
//  MapViewController.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 31.03.2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

final class MapViewController: UIViewController {
    
    private lazy var mapView: GMSMapView = {
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
        let camera = GMSCameraPosition.camera(withTarget: defaultCoordinate, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        return mapView
    }()
    private let locationManager = LocationManager()
    private var isTracking = false
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private let lastTrack = LastTrack()
    private var coordinatesForRealm: [Location] = []
    private let location = Location()
    private let realm = try? Realm()
    private let markerImage = MarkerImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)

        configureNavigationBar()
        configureLocationManager()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        
        navigationItem.setLeftBarButtonItems([
            UIBarButtonItem(
                title: "Start New Track",
                style: .plain,
                target: self,
                action: #selector(startNewTrack)),
            UIBarButtonItem(
                image: UIImage(systemName: "camera"),
                style: .plain,
                target: self,
                action: #selector(takePicture))
        ], animated: true)
        
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(
                title: "Show Last Track",
                style: .plain,
                target: self,
                action: #selector(showLastTrack)),
            UIBarButtonItem(
                title: "Finish Track",
                style: .plain,
                target: self,
                action: #selector(finishTrack))
        ], animated: true)
    }
    
    private func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let self = self else { return }
                guard let location = location else { return }
                self.routePath?.add(location.coordinate)
                self.route?.path = self.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self.mapView.animate(to: position)
                
                self.addMarker(position: location.coordinate)
                
                if self.isTracking {
                    self.location.latitude = location.coordinate.latitude
                    self.location.longitude = location.coordinate.longitude
                    self.coordinatesForRealm.append(self.location)
                }
            }
    }
    
    private func addMarker(position: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker(position: position)
        if let image = markerImage.loadImage() {
            marker.icon = image
        }
        marker.map = mapView
    }
    
    @objc private func startNewTrack() {
        route?.map = nil
        isTracking = true
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        coordinatesForRealm.removeAll()
    }
    
    @objc private func takePicture() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc private func showLastTrack() {
        if routePath != nil {
            let alert = UIAlertController(title: "Stop current Track?", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                self.finishTrack()
                self.buildLastTrack()
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            buildLastTrack()
        }
    }
    
    @objc private func finishTrack() {
        isTracking = false
        routePath = nil
        saveLastTrackToRealm()
        mapView.clear()
    }
    
    private func buildLastTrack() {
        guard let lastCoordinates = realm?.objects(LastTrack.self).first?.coordinates else { return }
        
        route?.map = nil
        routePath = GMSMutablePath()
        for item in lastCoordinates {
            routePath?.add(item.coordinate)
        }
        
        route?.path = routePath
        route?.map = mapView
        
        var bounds = GMSCoordinateBounds()
        for index in 1...routePath!.count() {
            bounds = bounds.includingCoordinate(routePath!.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    private func saveLastTrackToRealm() {
        guard let realm = realm else { return }
        
        if let lastCoordinates = realm.objects(LastTrack.self).first?.coordinates {
            try? realm.write {
                realm.delete(lastCoordinates)
            }
        }
        
        try? realm.write {
            for item in coordinatesForRealm {
                lastTrack.coordinates.append(item)
            }
            realm.add(lastTrack)
        }
    }
}

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let image = self?.extractImage(from: info) else { return }
            self?.markerImage.saveImage(image)
        }
    }
    
    private func extractImage(from info: [String: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            return image
        } else {
            return nil
        }
    }
}

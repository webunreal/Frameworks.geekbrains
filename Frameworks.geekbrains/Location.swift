//
//  Location.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 05.04.2021.
//

import Foundation
import RealmSwift
import CoreLocation

final class Location: Object {
    var latitude = 0.0
    var longitude = 0.0
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}

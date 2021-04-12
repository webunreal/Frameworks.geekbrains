//
//  LastTrack.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 05.04.2021.
//

import Foundation
import RealmSwift

final class LastTrack: Object {
    dynamic var coordinates = List<Location>()
}

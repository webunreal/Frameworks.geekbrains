//
//  User.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 07.04.2021.
//

import Foundation
import RealmSwift

final class User: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
}

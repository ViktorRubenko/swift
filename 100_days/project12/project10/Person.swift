//
//  Person.swift
//  project10
//
//  Created by Victor Rubenko on 03.03.2021.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

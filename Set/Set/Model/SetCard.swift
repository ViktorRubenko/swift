//
//  SetCard.swift
//  Set
//
//  Created by Victor Rubenko on 28.01.2021.
//

import Foundation


struct SetCard: Hashable, CustomStringConvertible {
    
    let number: Values
    let shape: Values
    let shading: Values
    let color: Values
    
    var description: String {
        return "SetCard: (number: \(number.index), shape: \(shape.index), shading: \(shading.index), color: \(color.index)"
    }
    
    // Each feature can have 3 possibilities
    enum Values: Int, CaseIterable {
        case v1 = 1, v2, v3
        
        var index: Int {
            return self.rawValue
        }
    }
}

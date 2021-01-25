//
//  SetCard.swift
//  SetGame_custom
//
//  Created by Victor Rubenko on 21.01.2021.
//

import Foundation


struct SetCard: Equatable {
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return (
            lhs.number == rhs.number &&
                lhs.shape == rhs.shape &&
                lhs.color == rhs.color &&
                lhs.fill == rhs.fill
        )
    }
    
    let index: Int
    let number: Variants
    let shape: Variants
    let color: Variants
    let fill: Variants
    
    enum Variants: Int {
        case v1 = 1, v2, v3
        
        static var all: [Variants] {
            return [.v1, .v2, .v3]
        }
        var index: Int {
            return self.rawValue - 1
        }
    }
}


extension SetCard: CustomStringConvertible {
    var description: String {
        return "SetCard: (\(number) \(shape) \(color) \(fill))"
    }
}

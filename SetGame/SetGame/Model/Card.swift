//
//  Card.swift
//  SetGame
//
//  Created by Victor Rubenko on 17.01.2021.
//

import Foundation


struct Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
 
    init(id: Int) {
        self.id = id
    }
    
}

//
//  Card.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 12.01.2021.
//

import Foundation


struct Card {
    var isFaceUp = false
    var isMatched = false
    var id: Int
    
    static var idFactory = 0
    
    static func getUniqueId() -> Int {
        idFactory += 1
        return idFactory
    }
    
    init() {
        self.id = Card.getUniqueId()
    }
}

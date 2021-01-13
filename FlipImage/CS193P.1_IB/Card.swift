//
//  Card.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 12.01.2021.
//

import Foundation


struct Card: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.id == rhs.id
        }
    
    var isFaceUp = false
    var isMatched = false
    private(set) var id: Int
    
    private static var idFactory = 0
    
    private static func getUniqueId() -> Int {
        idFactory += 1
        return idFactory
    }
    
    init() {
        self.id = Card.getUniqueId()
    }
}

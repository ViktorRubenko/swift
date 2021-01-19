//
//  SetCard.swift
//  SetGame
//
//  Created by Victor Rubenko on 18.01.2021.
//

import Foundation


struct SetCard: Hashable{
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return (
            lhs.id == rhs.id &&
            lhs.number == rhs.number &&
            lhs.color == rhs.color &&
            lhs.shape == rhs.shape &&
            lhs.fill == rhs.fill
        )
    }
    
    let id: Int
    let number: VarValue
    let color: VarValue
    let shape: VarValue
    let fill: VarValue
    
    
    enum VarValue: Int, CaseIterable {
        case v1 = 1, v2, v3
    }
}

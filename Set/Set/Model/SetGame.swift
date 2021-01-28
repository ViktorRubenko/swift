//
//  SetGame.swift
//  Set
//
//  Created by Victor Rubenko on 28.01.2021.
//

import Foundation


struct SetGame {
    private let deck = SetCardDeck()
    private var cardsSelected = [SetCard]()
    private(set) var isSet = false
        
    private func calculateSet() -> Bool {
        if cardsSelected.count == 3 {
            let concurences = [
                cardsSelected.reduce(0, { $0 + $1.number.index}),
                cardsSelected.reduce(0, { $0 + $1.shape.index}),
                cardsSelected.reduce(0, { $0 + $1.shading.index}),
                cardsSelected.reduce(0, { $0 + $1.color.index}),
            ]
            return concurences.reduce(true, { $0 && $1 % 3 == 0})
        }
        return false
    }
    
    mutating func chooseCard(card: SetCard?) {
        guard let card = card else {
            return
        }
        switch cardsSelected.count {
        case 3:
            isSet = calculateSet()
            cardsSelected.removeAll()
            fallthrough
        default:
            if cardsSelected.contains(card){
                cardsSelected.removeAll(where: { $0 == card })
            }
            cardsSelected.append(card)
        }
    }
}

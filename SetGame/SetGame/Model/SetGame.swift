//
//  SetGame.swift
//  SetGame
//
//  Created by Victor Rubenko on 17.01.2021.
//

import Foundation


enum SetGameErrors {
    case invalidCardPairsNumber
}

class SetGame {
    
    private(set) var cards = [Card]()
    
    init(numberOfTriplets: Int) {
        for cardID in 0..<numberOfTriplets {
            let card = Card(id: cardID)
            cards += [card, card, card]
        }
        cards.shuffle()
        print(cards)
    }
    
}

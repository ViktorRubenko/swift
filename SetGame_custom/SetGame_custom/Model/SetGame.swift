//
//  SetGame.swift
//  SetGame_custom
//
//  Created by Victor Rubenko on 21.01.2021.
//

import Foundation


struct SetGame {
    lazy private(set) var cards = SetCardDeck.handOver()
    private(set) var cardsSelected = [SetCard]()
    private(set) var cardsToVerify = [SetCard]()
    private(set) var cardsInGame = [SetCard]()
    var isSet: Bool {
        if cardsToVerify.count == 3 {
            let check_varians = [
                cardsToVerify.reduce(0, { $0 + $1.number.rawValue }),
                cardsToVerify.reduce(0, { $0 + $1.shape.rawValue }),
                cardsToVerify.reduce(0, { $0 + $1.color.rawValue }),
                cardsToVerify.reduce(0, { $0 + $1.fill.rawValue }),
            ]
            return check_varians.allSatisfy( { $0 % 3 == 0 } )
        }
        return false
    }
    
    mutating func chooseCard(_ card: SetCard) {
        switch cardsSelected.count {
        case 3:
            // temp array for delayed isSet check and drop from UI
            cardsToVerify += cardsSelected
            cardsSelected.removeAll()
            cardsSelected.append(card)
        default:
            guard let cardIndex = cardsSelected.firstIndex(of: card) else{
                cardsSelected.append(card)
                return
            }
            cardsSelected.remove(at: cardIndex)
        }
    }
    
    mutating func getCard() -> SetCard? {
        guard let card = cards.popLast() else {
            return nil
        }
        cardsInGame.append(card)
        return card
    }
}

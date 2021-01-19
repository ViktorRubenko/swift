//
//  SetGame.swift
//  SetGame
//
//  Created by Victor Rubenko on 18.01.2021.
//

import Foundation


struct SetGame {
    private(set) var cardsDeck = [SetCard]()
    private(set) var cardsSelected = [SetCard]()
    private(set) var cardsDropped = [SetCard]()
    private(set) var cardsInGame = [SetCard]()
    var isSet: Bool {
        if cardsSelected.count == 3 {
            let value_sums = [
                cardsSelected.reduce(0, { $0 + $1.number.rawValue }),
                cardsSelected.reduce(0, { $0 + $1.color.rawValue }),
                cardsSelected.reduce(0, { $0 + $1.shape.rawValue }),
                cardsSelected.reduce(0, { $0 + $1.fill.rawValue }),
            ]
            if value_sums.reduce(true, {$0 && $1 % 3 == 0}) {
                return true
            }
            return false
        }
        return false
    }
    
    init() {
        var index = 0
        for number in SetCard.VarValue.allCases {
            for color in SetCard.VarValue.allCases {
                for shape in SetCard.VarValue.allCases {
                    for fill in SetCard.VarValue.allCases {
                        cardsDeck.append(SetCard(id: index,number: number, color: color, shape: shape, fill: fill))
                        index += 1
                    }
                }
            }
        }
        cardsDeck.shuffle()
    }
    
    mutating func chooseCard(card: SetCard) {
        switch cardsSelected.count {
        case 3:
            cardsSelected.removeAll()
            fallthrough
        case 0:
            cardsSelected.append(card)
        case 1...2:
            if cardsSelected.contains(card) {
                cardsSelected.remove(at: cardsSelected.firstIndex(of: card)!)
            } else {
                cardsSelected.append(card)
            }
        default:
            cardsSelected.append(card)
        }
    }
    
    mutating func dropSelected() {
        if isSet {
            cardsDropped += cardsSelected
            for card in cardsSelected {
                cardsInGame.remove(at: cardsInGame.firstIndex(of: card)!)
            }
        }
        cardsSelected.removeAll()
    }
    
    mutating func getCard() -> SetCard? {
        if cardsDeck.count > 0 {
            let card = cardsDeck.removeFirst()
            print(cardsDeck.count)
            cardsInGame.append(card)
            return card
        } else {
            return nil
        }
    }
    
    mutating func newGame(){
        cardsDeck += cardsInGame
        cardsDeck += cardsDropped
        cardsDeck.shuffle()
        cardsInGame.removeAll()
        cardsDropped.removeAll()
    }
}

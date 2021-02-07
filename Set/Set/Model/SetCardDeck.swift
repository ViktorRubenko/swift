//
//  SetCardDeck.swift
//  Set
//
//  Created by Victor Rubenko on 28.01.2021.
//

import Foundation


struct SetCardDeck {
    private(set) var cards = [SetCard]()
    
    mutating func hangOut() {
        for number in SetCard.Values.allCases {
            for shape in SetCard.Values.allCases {
                for shading in SetCard.Values.allCases {
                    for color in SetCard.Values.allCases {
                        cards.append(SetCard(number: number, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    mutating func getCard() -> SetCard? {
        return cards.popLast()
    }
    
    init() {
        hangOut()
    }
}

extension SetCardDeck {
    init(addition: [SetCard]) {
        hangOut()
        cards = cards.filter({ !addition.contains($0) })
        cards = cards + addition.reversed()
    }
}

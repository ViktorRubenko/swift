//
//  SetCardDeck.swift
//  SetGame_custom
//
//  Created by Victor Rubenko on 21.01.2021.
//

import Foundation


struct SetCardDeck {
    static func handOver() -> [SetCard] {
        var cards = [SetCard]()
        var index = 0
        for number in SetCard.Variants.all {
            for shape in SetCard.Variants.all {
                for color in SetCard.Variants.all {
                    for fill in SetCard.Variants.all {
                        cards.append(SetCard(index: index, number: number, shape: shape, color: color, fill: fill))
                        index += 1
                    }
                }
            }
        }
        cards.shuffle()
        return cards
    }
}

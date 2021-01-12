//
//  FlipGame.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 12.01.2021.
//

import Foundation


class FlipGame {
    var cards = [Card]()
    
    var indexOfFaceUpCard: Int?
    
    func refresh() {
        for index in cards.indices {
            cards[index].isMatched = false
            cards[index].isFaceUp = false
        }
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfFaceUpCard, matchIndex != index {
                if cards[index].id == cards[matchIndex].id {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfFaceUpCard = nil
            } else {
                // if not cards faceUp or 2 are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfFaceUpCard = index
            }
        } else {
            // for last faceUp matched pair
            for flipDownIndex in cards.indices {
                cards[flipDownIndex].isFaceUp = false
            }
        }
    }
    
    init(numberOfPairsOfCard: Int) {
        for _ in 0..<numberOfPairsOfCard {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

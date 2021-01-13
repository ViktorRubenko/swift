//
//  FlipGame.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 12.01.2021.
//

import Foundation


struct FlipGame {
    
    private(set) var cards = [Card]()
    private(set) var flipCount = 0
    private(set) var score = 0
    private var startToScore = false
    private var seenCards = Set<Int>()
    
    private var indexOfFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for indexOfCard in cards.indices{
                if cards[indexOfCard].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = indexOfCard
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set(newValue) {
            for indexOfCard in cards.indices{
                cards[indexOfCard].isFaceUp = (indexOfCard == newValue)
            }
        }
    }
    
    mutating func refresh() {
        for index in cards.indices {
            cards[index].isMatched = false
            cards[index].isFaceUp = false
        }
        cards.shuffle()
        flipCount = 0
        seenCards.removeAll()
        score = 0
        startToScore = false
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "FlipGame.chooseCard(at: \(index): chosen index not in the cards")
        var points = 0
        if seenCards.contains(index) {
            points -= 1
        }
        if !cards[index].isMatched {
            if let matchIndex = indexOfFaceUpCard, matchIndex != index {
                if cards[index] == cards[matchIndex] {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    points = 2
                    startToScore = true
                }
                cards[index].isFaceUp = true
            } else {
                points = 0
                indexOfFaceUpCard = index
            }
        } else {
            // for last faceUp matched pair
            for flipDownIndex in cards.indices {
                cards[flipDownIndex].isFaceUp = false
            }
        }
        if startToScore {
            score += points
        }
        flipCount += 1
        seenCards.insert(index)
    }
    
    init(numberOfPairsOfCard: Int) {
        assert(numberOfPairsOfCard > 0, "FlipGame.init(\((numberOfPairsOfCard)): must have positive value")
        for _ in 0..<numberOfPairsOfCard {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

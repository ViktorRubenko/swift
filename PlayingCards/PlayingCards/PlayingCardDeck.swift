//
//  PlayingCardDeck.swift
//  PlayingCards
//
//  Created by Victor Rubenko on 25.01.2021.
//

import Foundation

struct PlayingCardDeck
{
    private(set) var cards = [PlayingCard]()
    
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
        cards.shuffle()
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.popLast()
        } else {
            return nil
        }
    }
}

//
//  SetGame.swift
//  Set
//
//  Created by Victor Rubenko on 28.01.2021.
//

import Foundation


struct SetGame {
    private(set) var deck = SetCardDeck()
    private(set) var cardsLastSet = [SetCard]()
    private(set) var cardsSelected = [SetCard]() {
        didSet {
            isSet = calculateSet(for: cardsSelected)
        }
    }
    private(set) var cardsInGame = [SetCard]()
    private(set) var isSet = false
    var setCount: Int {
        var count = 0
        for firstIndex in 0..<cardsInGame.count-2 {
            let firstCard = cardsInGame[firstIndex]
            for secondIndex in firstIndex+1..<cardsInGame.count-1 {
                let secondCard = cardsInGame[secondIndex]
                for thirdIndex in secondIndex+1..<cardsInGame.count {
                    let thirdCard = cardsInGame[thirdIndex]
                    if calculateSet(for: [firstCard, secondCard, thirdCard]) {
                        count += 1
                    }
                }
            }
        }
        return count
    }
    var startCardsCount = 12
    
    mutating func findSet() {
        for firstIndex in 0..<cardsInGame.count-2 {
            let firstCard = cardsInGame[firstIndex]
            for secondIndex in firstIndex+1..<cardsInGame.count-1 {
                let secondCard = cardsInGame[secondIndex]
                for thirdIndex in secondIndex+1..<cardsInGame.count {
                    let thirdCard = cardsInGame[thirdIndex]
                    if calculateSet(for: [firstCard, secondCard, thirdCard]) {
                        cardsSelected.removeAll()
                        for card in [firstCard, secondCard, thirdCard] {
                            chooseCard(card: card)
                        }
                        return
                    }
                }
            }
        }
    }
        
    private func calculateSet(for cards: [SetCard]) -> Bool {
        if cards.count == 3 {
            let concurences = [
                cards.reduce(0, { $0 + $1.number.index}),
                cards.reduce(0, { $0 + $1.shape.index}),
                cards.reduce(0, { $0 + $1.shading.index}),
                cards.reduce(0, { $0 + $1.color.index}),
            ]
            return concurences.reduce(true, { $0 && $1 % 3 == 0})
        }
        return false
    }
    
    init() {
        addStartCards()
    }
    
    mutating func clearSelected() {
        cardsSelected.removeAll()
    }
    
    mutating func newGame(reminder: Bool) {
        deck = reminder ? SetCardDeck(addition: cardsInGame) : SetCardDeck()
        cardsInGame.removeAll()
        cardsSelected.removeAll()
        cardsLastSet.removeAll()
        addStartCards()
    }
    
    mutating private func addStartCards() {
        for _ in 0..<startCardsCount {
            addCard()
        }
    }
    
    mutating func shuffleCards(){
        cardsInGame.shuffle()
    }
    
    mutating func addCard() {
        if let card = deck.getCard() {
            cardsInGame.append(card)
        }
    }
    
    mutating func drop(){
        for card in cardsSelected {
            cardsInGame.removeAll(where: { $0 == card } )
        }
    }
    
    mutating func chooseCard(card: SetCard?) {
        guard let card = card else {
            return
        }
        switch cardsSelected.count {
        case 3:
            if isSet {
                cardsLastSet.removeAll()
                cardsLastSet += cardsSelected
            } else {
                cardsLastSet.removeAll()
            }
            cardsSelected.removeAll()
            cardsSelected.append(card)
        default:
            if cardsLastSet.count != 0 {
                cardsLastSet.removeAll()
            }
            if cardsSelected.contains(card){
                cardsSelected.removeAll(where: { $0 == card })
            } else {
                cardsSelected.append(card)
            }
        }
    }
}

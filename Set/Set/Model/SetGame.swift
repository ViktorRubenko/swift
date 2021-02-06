//
//  SetGame.swift
//  Set
//
//  Created by Victor Rubenko on 28.01.2021.
//

import Foundation


struct SetGame {
    private var deck = SetCardDeck()
    private(set) var cardsLastSet = [SetCard]()
    private(set) var cardsSelected = [SetCard]() {
        didSet {
            isSet = calculateSet()
        }
    }
    private(set) var cardsInGame = [SetCard]()
    private(set) var isSet = false
    var startCardsCount = 12
        
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
    
    init() {
        for _ in 0..<startCardsCount {
            addCard()
        }
    }
    
    mutating func shuffleCards(){
        cardsInGame.shuffle()
    }
    
    mutating func addCard(){
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

//
//  ViewController.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 11.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = FlipGame(numberOfPairsOfCard: numberOfPairsOfCards)
    
    private(set) lazy var activeButtonsCount = cardButtons.count
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private var newGameButton: UIButton!
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game.refresh()
        refreshView()
        updateViewFromModel()
    }
    
    // MARK: Handle Card Ouch Behavoir
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card is not in cardButtons")
        }
        
    }
    
    private func refreshView() {
        newGameButton.isHidden = true
        activeButtonsCount = cardButtons.count
        flipCount = 0
        for button in cardButtons {
            button.isEnabled = true
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emojiForCard(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle(nil, for: .normal)
                if button.isEnabled {
                    button.backgroundColor = UIColor.systemOrange
                }
                if card.isMatched && button.isEnabled{
                    button.backgroundColor = .clear
                    button.isEnabled = false
                    activeButtonsCount -= 1
                }
                if activeButtonsCount == 0 {
                    newGameButton.isHidden = false
                }
            }
        }
    }
    
    private var emojiChoices = ["💩", "🐨", "🐷", "🦊", "🐶", "🐮", "🐼"]
    
    private var emojiDict = [Int:String]()
    
    private func emojiForCard(for card: Card) -> String {
        if emojiDict[card.id] == nil && emojiChoices.count > 0 {
            let random_index = emojiChoices.count.arc4random
            emojiDict[card.id] = emojiChoices.remove(at: random_index)
        }
        return emojiDict[card.id] ?? "?"
    }
    
}


extension Int {
    var arc4random: Int {
        if self > 0{
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

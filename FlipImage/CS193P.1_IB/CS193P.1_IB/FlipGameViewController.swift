//
//  ViewController.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 11.01.2021.
//

import UIKit


class FlipGameViewController: UIViewController {
    
    private lazy var game = FlipGame(numberOfPairsOfCard: numberOfPairsOfCards)
    
    private(set) lazy var activeButtonsCount = cardButtons.count
    
    private var cardBackColor = UIColor.systemOrange
    private var viewBackgroundColor = UIColor.systemGray
    private var emojiChoices = [String]()
    private var emojiDict = [Card:String]()
    
    var theme: Theme? = nil {
        didSet{
            (emojiChoices, cardBackColor, viewBackgroundColor) = theme!
            updateAppearance()
//            print(emojiChoices, cardBackColor, viewBackgroundColor)
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private var newGameButton: UIButton!
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        themeKey = themes.keys.randomElement()!
        updateViewFromModel()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        emojiDict = [Card:String]()
//        themeKey = themes.keys.randomElement()!
        activeButtonsCount = cardButtons.count
        game.refresh()
        refreshView()
        updateViewFromModel()
    }
    
    // MARK: Handle Card Touch Behavoir
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card is not in cardButtons")
        }
        
    }
    
    private func updateAppearance(){
        view.backgroundColor = viewBackgroundColor
        flipCountLabel.textColor = cardBackColor
        scoreLabel.textColor = cardBackColor
        newGameButton.backgroundColor = cardBackColor
        newGameButton.setTitleColor(viewBackgroundColor, for: .normal)
    }
    
    private func refreshView() {
        newGameButton.isHidden = true
        activeButtonsCount = cardButtons.count
        for button in cardButtons {
            button.isEnabled = true
        }
    }
    
    private func updateViewFromModel() {
        
        func hide_button(_ button: UIButton) {
            button.setTitle(nil, for: .normal)
            button.backgroundColor = .clear
            button.isEnabled = false
        }
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emojiForCard(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle(nil, for: .normal)
                if button.isEnabled {
                    button.backgroundColor = cardBackColor
                }
                if card.isMatched && button.isEnabled{
                    hide_button(button)
                }
            }
            if card.isMatched && button.isEnabled{
                activeButtonsCount -= 1
            }
            // Hide 2 last cards right after the last card tap
            if activeButtonsCount == 0 {
                for index in cardButtons.indices {
                    let button = cardButtons[index]
                    if button.isEnabled {
                        hide_button(button)
                    }
                }
                newGameButton.isHidden = false
            }
            flipCountLabel.text = "Flips: \(game.flipCount)"
            scoreLabel.text = "Score: \(game.score)"
        }
    }
    
    private func emojiForCard(for card: Card) -> String {
        if emojiDict[card] == nil && emojiChoices.count > 0 {
            let random_index = emojiChoices.count.arc4random
            emojiDict[card] = emojiChoices.remove(at: random_index)
        }
        print(emojiDict)
        return emojiDict[card] ?? "?"
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

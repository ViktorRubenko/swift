//
//  ViewController.swift
//  SetGame
//
//  Created by Victor Rubenko on 17.01.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: BorderLabel!
    @IBOutlet var cardButtons: [SetCardButton]!
    @IBAction func chooseCard(_ sender: SetCardButton) {
        let isSet = setGame.isSet
        if isSet {
            sender.borderColor = .red
            markSetCards()
            dealButton.isEnabled = true
        }
        if setGame.cardsSelected.count == 3 {
            score -= 1
        }
        setGame.chooseCard(card: sender.setCard!)
        if !isSet { updateViewFromModel() }
    }
    @IBOutlet weak var dealButton: BorderButton!
    @IBAction func DealNew(_ sender: BorderButton) {
        if setGame.isSet {
            dropTriplet()
            score += 1 + bonus
        } else if cardsAmount + 3 <= 24 {
            cardsAmount += 3
            bonus -= 1
        }
        setGame.dropSelected()
        updateViewFromModel()
    }
    @IBAction func newGame(_ sender: BorderButton) {
        cardsAmount = 12
        for button in cardButtons{
            button.setCard = nil
        }
        setGame.newGame()
        updateViewFromModel()
    }
    private var cardsAmount = 12
    private var score = 0
    private var bonus = 4
    lazy private var setGame = SetGame.init()
    private var cardsForButtons = [Int:SetCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in cardButtons {
            button.setCard = nil
        }
        updateViewFromModel()
    }
    
    private func dropTriplet(){
        for button in cardButtons {
            guard let card = button.setCard else {
                continue
            }
            if setGame.cardsSelected.contains(card) {
                button.setCard = nil
            }
        }
    }
    
    private func updateViewFromModel(){
        scoreLabel.text = "\(score)"
        dealButton.isEnabled = (cardsAmount != 24 || setGame.isSet)
        for buttonIndex in 0..<cardsAmount {
            let button = cardButtons[buttonIndex]
            if button.setCard == nil && setGame.cardsDeck.count > 0 {
                button.setCard = setGame.getCard()
            }
            if let card = button.setCard {
                if setGame.cardsSelected.contains(card) {
                    button.borderColor = .red
                } else {
                    button.borderColor = .clear
                }
            }
        }
    }
    
    private func markSetCards(){
        for button in cardButtons {
            if let card = button.setCard {
                if setGame.cardsSelected.contains(card) {
                    button.borderColor = .blue
                }
            }
        }
    }
}


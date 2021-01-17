//
//  ViewController.swift
//  SetGame
//
//  Created by Victor Rubenko on 17.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var game = SetGame(numberOfTriplets: numberOfTriplets)
    private var numberOfTriplets: Int {
        print(cardButtons.count)
        return cardButtons.count / 3
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Do any additional setup after loading the view.
    }
    
    func updateView(){
        for cardIndex in 0..<game.cards.count {
            let card = game.cards[cardIndex]
            let cardButton = cardButtons[cardIndex]
            cardButton.setTitle("\(card.id)", for: .normal)
            cardButton.titleLabel?.textColor = .black
        }
    }


}


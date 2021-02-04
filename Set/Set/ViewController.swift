//
//  ViewController.swift
//  Set
//
//  Created by Victor Rubenko on 28.01.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardBoard: SetCardBoardView!
    @IBOutlet weak var dealThreeButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    lazy private var setGame = SetGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // WTF??? cardBoard has 1 card 
        cardBoard.cardViews.removeAll()
        updateViewFromModel()
    }
    
    private func addTapGestureRecognizer(for cardView: SetCardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }
    
    @objc
    private func tapCard(_ sender: UITapGestureRecognizer?) {
        switch sender?.state {
        case .ended:
            if let cardView = sender?.view! as? SetCardView {
                let index = cardBoard.cardViews.firstIndex(of: cardView)!
                setGame.chooseCard(card: setGame.cardsInGame[index])
                updateViewFromModel()
            }
        default:
            break
        }
    }
    
    private func updateCardView(_ cardView: SetCardView, card: SetCard) {
        cardView.number = card.number.index
        cardView.shapeInt = card.shape.index
        cardView.shadingInt = card.shading.index
        cardView.colorInt = card.color.index
    }
    
    private func updateViewFromModel() {
        for index in cardBoard.cardViews.count..<setGame.cardsInGame.count {
            print(index)
            let card = setGame.cardsInGame[index]
            let cardView = SetCardView()
            updateCardView(cardView, card: card)
            addTapGestureRecognizer(for: cardView)
            cardBoard.cardViews.append(cardView)
        }
        for (index, cardView) in cardBoard.cardViews.enumerated() {
            let card = setGame.cardsInGame[index]
            // set/unset isSelected flag if model contains card in Selected
            // if need only
            if setGame.cardsSelected.contains(card){
                cardView.isSelected = true
            } else if setGame.cardsLastSet.contains(card) {
                cardView.isSet = true
            } else {
                cardView.isSet = false
                cardView.isSelected = false
            }
        }
    }
    
    private func dropCards() {
        for (index, cardView) in cardBoard.cardViews.enumerated() {
            let card = setGame.cardsInGame[index]
            if setGame.cardsSelected.contains(card) {
                cardBoard.cardViews.removeAll(where: { $0 == cardView })
            }
        }
        setGame.drop()
    }
    
    @IBAction func dealNewThree(_ sender: UIButton) {
        if setGame.isSet {
            dropCards()
        }
        for _ in 0...2{
            setGame.addCard()
        }
        updateViewFromModel()
    }
}


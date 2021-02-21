//
//  ViewController.swift
//  Set
//
//  Created by Victor Rubenko on 28.01.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardBoard: SetCardBoardView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var dealThreeButton: UIButton!
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var cardsDeckLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var labelStack: UIStackView!
    lazy private var setGame = SetGame()
    private var score = 0 {
        didSet {
            if score != oldValue && score != 0 {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.labelStack.bringSubviewToFront(self.scoreLabel)
                        self.scoreLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                        print(self.score)
                        self.scoreLabel.text = "Score: \(self.score)"
                    },
                    completion: { _ in
                        UIView.animate(withDuration: 0.3,
                                       animations: {
                                        self.scoreLabel.transform = CGAffineTransform.identity
                                       },
                                       completion: { _ in
                                        self.labelStack.sendSubviewToBack(self.scoreLabel)
                                       }
                        )
                    }
                )
            } else {
                switch traitCollection.horizontalSizeClass {
                case .compact:
                    scoreLabel.text = "Score:\n0"
                default:
                    scoreLabel.text = "Score: 0"
                }
            }
        }
    }
    
    @IBAction func newGameAction(_ sender: UIButton) {
        newGame(reminder: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // WTF??? cardBoard has 1 card
        addSwipeGestureRecognizer(for: cardBoard)
        addRotationGestureRecognizer(for: cardBoard)
        cardBoard.cardViews.removeAll()
        updateViewFromModel()
    }
    
    private func configureLayer(
        view: UIView,
        backgroundColor: CGColor = UIColor.white.cgColor
    ) {
        view.layer.cornerRadius = scoreLabel.layer.bounds.height * 0.1
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.backgroundColor = backgroundColor
    }
    
    private func configure() {
        score = 0
        configureLayer(view: scoreLabel)
        configureLayer(view: newGameButton)
        configureLayer(view: dealThreeButton)
        configureLayer(view: tipButton)
        configureLayer(view: setsLabel)
        configureLayer(view: cardsDeckLabel)
    }
    
    private func addRotationGestureRecognizer(for cardBoardView: SetCardBoardView) {
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shuffleBoard))
        cardBoardView.addGestureRecognizer(rotation)
    }
    
    @objc
    private func shuffleBoard(_ sender: UIRotationGestureRecognizer?) {
        switch sender?.state {
        case .ended:
            setGame.shuffleCards()
            cardBoard.cardViews.removeAll()
            updateViewFromModel()
        default:
            break
        }
    }
    
    private func addSwipeGestureRecognizer(for cardBoardView: SetCardBoardView) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBoard))
        swipe.direction = .down
        cardBoardView.addGestureRecognizer(swipe)
    }
    
    @objc
    private func swipeBoard(_ sender: UISwipeGestureRecognizer?) {
        switch sender?.state {
        case .ended:
            dealNewThree()
        default:
            break
        }
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
                if setGame.isSet {
                    score -= 1
                }
                let index = cardBoard.cardViews.firstIndex(of: cardView)!
                setGame.chooseCard(card: setGame.cardsInGame[index])
                updateViewFromModel()
            }
        default:
            break
        }
    }
    
    private func newGame(reminder: Bool = false) {
        score = 0
        setGame.newGame(reminder: reminder)
        cardBoard.cardViews.removeAll()
        updateViewFromModel()
    }
    
    private func updateCardView(_ cardView: SetCardView, card: SetCard) {
        cardView.number = card.number.index
        cardView.shapeInt = card.shape.index
        cardView.shadingInt = card.shading.index
        cardView.colorInt = card.color.index
    }
    
    private func updateViewFromModel() {
        for index in cardBoard.cardViews.count..<setGame.cardsInGame.count {
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
        setsLabel.text = "Sets: \(setGame.setCount)"
        cardsDeckLabel.text = "Deck: \(setGame.deck.cards.count)"
        if setGame.deck.cards.count == 0 && setGame.setCount == 0 {
            let alert = UIAlertController(title: "Congrants!", message: "No more sets left in the deck", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { _ in self.newGame(reminder: true)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    private func dropCards() {
        for (index, cardView) in cardBoard.cardViews.enumerated() {
            let card = setGame.cardsInGame[index]
            if setGame.cardsSelected.contains(card) {
                self.cardBoard.cardViews.removeAll(where: { $0 == cardView })
            }
        }
        setGame.drop()
    }
    
    private func dealNewThree() {
        if setGame.cardsSelected.count == 3 {
            if setGame.isSet {
                dropCards()
                score += 3
            } else {
                score -= 2
            }
        } else {
            if setGame.setCount != 0 {
                score -= 1
            }
            getNewThree()
        }
        while setGame.setCount == 0 {
            if setGame.deck.cards.count == 0 {
                break
            }
            getNewThree()
        }
        updateViewFromModel()
        setGame.clearSelected()
    }
    
    private func getNewThree() {
        for _ in 0...2 {
            setGame.addCard()
        }
    }
    
    @IBAction func dealNewThreeAction(_ sender: UIButton) {
        dealNewThree()
    }
    
    @IBAction func giveTip(_ sender: UIButton) {
        setGame.findSet()
        score -= 4
        updateViewFromModel()
    }
}


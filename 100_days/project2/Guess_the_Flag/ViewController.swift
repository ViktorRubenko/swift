//
//  ViewController.swift
//  Guess_the_Flag
//
//  Created by Victor Rubenko on 25.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var flagsButtons: [UIButton]!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var topScoreLabel: UILabel!
    
    private var attemps = 0
    private var score = 0 {
        didSet {
            UIView.transition(
                with: scoreLabel,
                duration: 0.4,
                options: .transitionCrossDissolve,
                animations: { [weak self] in
                    self!.scoreLabel.text = "Score: \(self!.score)"
                    if oldValue < self!.score {
                        self!.scoreLabel.textColor = UIColor.green
                    } else {
                        self!.scoreLabel.textColor = UIColor.red
                    }
                },
                completion: nil
                )
        }
    }
    private var correntAnswer = 0
    private var topScore = 0 {
        didSet {
            topScoreLabel.text = "Top Score: \(topScore)"
        }
    }
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let topScoreValue = defaults.value(forKey: "topScoreValue") as? Int {
            topScore = topScoreValue
        }
        configure()
        askQuestion()
    }
    
    func configure() {
        for button in flagsButtons {
            button.layer.borderWidth = 1
            button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            button.layer.cornerRadius = CGFloat(10)
            button.clipsToBounds = true
        }
    }
    @IBAction func pushFlag(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 10.0,
            initialSpringVelocity: 1,
            animations: {
                sender.alpha = 0
                },
            completion: {_ in
                sender.alpha = 1
            }
        )
        let button_index = flagsButtons.firstIndex(of: sender)
        if button_index == correntAnswer {
            score += 1
        } else {
            score -= 1
        }
        attemps += 1
        if attemps == 10 {
            var message = ""
            if score > topScore {
                topScore = score
                message = "Congratulations!\nYou set new TopScore to \(score)!"
                defaults.setValue(topScore, forKey: "topScoreValue")
            } else {
                message = "Your score is \(score)"
            }
            let alert = UIAlertController(title: "The game is ended", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { action in self.newGame()} ))
            alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { _ in
                let vc = UIActivityViewController(activityItems: ["My score in FlagGuesser is \(self.score)"], applicationActivities: [])
                self.present(vc, animated: true, completion: nil)
                vc.completionWithItemsHandler = { (activity, sucess, items, error) in
                    self.newGame() }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        askQuestion()
    }
    
    func newGame() {
        score = 0
        scoreLabel.textColor = .black
        attemps = 0
    }
    
    func askQuestion() {
        let countries = Countries.allCases.shuffled()[0...2]
        for (button_index, button) in flagsButtons.enumerated() {
            let image = countries[button_index].image()
            button.setBackgroundImage(image, for: .normal)
        }
        correntAnswer = Int.random(in: 0...2)
        let correntCountry = countries[correntAnswer].rawValue
        
        UIView.transition(
            with: countryLabel,
            duration: 0.25,
            options: .transitionFlipFromLeft,
            animations: { [weak self] in
                print(correntCountry)
                self!.countryLabel.text = correntCountry
            },
            completion: nil
        )
    }
}

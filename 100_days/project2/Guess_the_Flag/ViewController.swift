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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        let button_index = flagsButtons.firstIndex(of: sender)
        if button_index == correntAnswer {
            score += 1
        } else {
            score -= 1
        }
        askQuestion()
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
            completion: nil)
    }
}

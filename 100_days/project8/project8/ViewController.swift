//
//  ViewController.swift
//  project8
//
//  Created by Victor Rubenko on 01.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var currentAnswer: UITextField!
    var submitButton: UIButton!
    var clearButton: UIButton!
    var cluesButtons = [UIButton]()
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.font = UIFont.systemFont(ofSize: 20)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 20)
        answersLabel.numberOfLines = 0
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.layoutMarginsGuide.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.2),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.layoutMarginsGuide.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.3),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.layoutMarginsGuide.heightAnchor)
            
        ])
    }

}


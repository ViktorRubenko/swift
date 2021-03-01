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
        cluesLabel.font = UIFont.systemFont(ofSize: 16)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 16)
        answersLabel.numberOfLines = 0
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 20)
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        view.addSubview(submitButton)
        
        clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("CLEAR", for: .normal)
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.2),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.3),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 50),
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 10),
            submitButton.leadingAnchor.constraint(equalTo: currentAnswer.leadingAnchor, constant: 10),
            submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            clearButton.topAnchor.constraint(equalTo: submitButton.topAnchor),
            clearButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor),
            clearButton.trailingAnchor.constraint(equalTo: currentAnswer.trailingAnchor, constant: -10),
        ])
        answersLabel.backgroundColor = .red
        cluesLabel.backgroundColor = .green
    }

}


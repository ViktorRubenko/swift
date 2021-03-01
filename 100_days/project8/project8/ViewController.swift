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
    var lettersButtons = [UIButton]()
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var scoreLabel: UILabel!
    var buttonsView: UIView!
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var answered = 0
    
    var gameLevel: Level? = nil
    
    var score: Double = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1 {
        didSet {
            score = 0
            answered = 0
            solutions.removeAll()
            loadLevel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadLevel() {
        gameLevel = Level(level: level)
        solutions = gameLevel!.solutions
        
        cluesLabel.text = gameLevel!.clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = gameLevel!.solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if gameLevel!.lettersBits.count == lettersButtons.count {
            for (index, letterButton) in lettersButtons.enumerated() {
                letterButton.setTitle(gameLevel!.lettersBits[index], for: .normal)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadLevel()
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
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.3),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 50),
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: currentAnswer.leadingAnchor, constant: 10),
            submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            clearButton.topAnchor.constraint(equalTo: submitButton.topAnchor),
            clearButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor),
            clearButton.trailingAnchor.constraint(equalTo: currentAnswer.trailingAnchor, constant: -10),
            buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 50),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 10),
        ])
        
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        // 1 - >stretch verticaly
        
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        let width = 85
        let height = 45
        
        for row in 0...4 {
            for col in 0...3 {
                let letterButton = UIButton(type: .system)
                letterButton.addTarget(self, action: #selector(lettersTApped), for: .touchUpInside)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                letterButton.setTitle("WWW", for: .normal)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.gray.cgColor
                
                buttonsView.addSubview(letterButton)
                
                lettersButtons.append(letterButton)
            }
        }

        
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answeredText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answeredText) {
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answeredText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            activatedButtons.removeAll()
            currentAnswer.text = ""
            score += 1
            answered += 1
            
            if answered % 7 == 0 {
                let ac = UIAlertController(title: "Well Done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp ))
                present(ac, animated: true, completion: nil)
                level += 1
            }
        } else {
            let ac = UIAlertController(title: "Wrong answer", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            
            score -= 0.2
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        for button in lettersButtons {
            button.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    @objc func lettersTApped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

}


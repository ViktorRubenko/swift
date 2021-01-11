//
//  ViewController.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 11.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var touchCard: UIButton!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCard(withEmoji: "Cow", on: touchCard)
    }
    
    func flipCard(withEmoji emoji: String, on button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: .normal)
            button.backgroundColor =  #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            button.setTitle(emoji, for: .normal)
            button.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

//
//  ViewController.swift
//  SetGame
//
//  Created by Victor Rubenko on 17.01.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardButtons: [BorderButton]!
    
    @IBAction func chooseCard(_ sender: BorderButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        for buttonIndex in cardButtons.indices {
            let button = cardButtons[buttonIndex]
            button.setTitle(String(buttonIndex), for: .normal)
        }
    }


}


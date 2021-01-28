//
//  FlipGameThemeChooserViewController.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 27.01.2021.
//

import UIKit

typealias Theme = (emoji: [String], cardBackColor: UIColor, backgroundColor: UIColor)

fileprivate let themes: [String: Theme] = [
    "Animals": (emoji: "🐮 🐶 🦊 🐷 🐨 🐻 🐸 🐯".components(separatedBy: " "), cardBackColor: .yellow, backgroundColor: .green),
    "Sports": (emoji: "⛸ ⚽️ 🏈 🥎 ⚾️ 🏉 🥏 🏓".components(separatedBy: " "), cardBackColor: .red, backgroundColor: .blue),
    "Faces": (emoji: "😀 😂 😍 😎 🤩 🤢 🤐 🙄".components(separatedBy: " "), cardBackColor: .cyan, backgroundColor: .orange),
]

class FlipGameThemeChooserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let vc = segue.destination as? FlipGameViewController {
                    vc.theme = theme
                    print(theme)
                }
            }
        }
    }

}

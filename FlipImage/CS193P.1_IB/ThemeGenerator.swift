//
//  ThemeGenerator.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 13.01.2021.
//

import Foundation


enum ThemeGenerator: CaseIterable {
    case animals
    case sports
    case faces
    
    static func getTheme() -> [String] {
        let theme = ThemeGenerator.allCases.randomElement()!
        var emoji = ""
        switch theme {
        case .animals:
            emoji = "🐮 🐶 🦊 🐷 🐨 🐻 🐸 🐯"
        case .sports:
            emoji = "⛸ ⚽️ 🏈 🥎 ⚾️ 🏉 🥏 🏓"
        case .faces:
            emoji = "😀 😂 😍 😎 🤩 🤢 🤐 🙄"
        }
        return emoji.components(separatedBy: " ").shuffled()
    }
}

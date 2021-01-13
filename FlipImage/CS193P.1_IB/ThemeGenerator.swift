//
//  ThemeGenerator.swift
//  CS193P.1_IB
//
//  Created by Victor Rubenko on 13.01.2021.
//

import Foundation


struct ThemeGenerator {
    
    private(set) var emojiDict = [String:String]()
    
    init() {
        emojiDict["animals"] = "🐮 🐶 🦊 🐷 🐨 🐻 🐸 🐯"
        emojiDict["sports"] = "⛸ ⚽️ 🏈 🥎 ⚾️ 🏉 🥏 🏓"
        emojiDict["faces"] = "😀 😂 😍 😎 🤩 🤢 🤐 🙄"
    }
    
    func getTheme() -> [String] {
        return emojiDict.values.randomElement()!.components(separatedBy: " ")
    }
}

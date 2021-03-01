//
//  SwiftyWords.swift
//  project8
//
//  Created by Victor Rubenko on 01.03.2021.
//

import Foundation


var levels = [Level]()


struct Level {
    var clueString = ""
    var solutionString = ""
    var lettersBits = [String]()
    var solutions = [String]()
    
    init(level: Int) {
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    lettersBits += bits
                }
            }
        }
        if !lettersBits.isEmpty {
            lettersBits.shuffle()
        }
    }
}

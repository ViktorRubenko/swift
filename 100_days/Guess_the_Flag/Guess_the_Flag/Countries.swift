//
//  GuessGame.swift
//  Guess_the_Flag
//
//  Created by Victor Rubenko on 25.02.2021.
//

import UIKit


enum Countries: String, CaseIterable {
    case estonia = "Estonia"
    case france = "France"
    case germany = "Germany"
    case ireland = "Ireland"
    case italy = "Italy"
    case monaco = "Monaco"
    case nigeria = "Nigeria"
    case poland = "Poland"
    case russia = "Russia"
    case uk = "UK"
    case us = "US"
    
    func image() -> UIImage? {
        return UIImage(named: self.rawValue.lowercased())
    }
}

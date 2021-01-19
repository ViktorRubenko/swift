//
//  SetCardButton.swift
//  SetGame
//
//  Created by Victor Rubenko on 19.01.2021.
//

import UIKit

@IBDesignable class SetCardButton: BorderButton {
    var colors: [UIColor] = [.red, .orange, .blue]
    var shapes = "▲ ● ■".components(separatedBy: " ")
    var alphas: [CGFloat] = [0.0, 0.35, 1.0]
    var strokeWidths: [CGFloat] = [-10, -10, -10]
    
    var setCard: SetCard? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if setCard == nil {
            self.borderColor = .clear
            self.backgroundColor = .clear
            self.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            self.isEnabled = false
            return
        }
        let shape = shapes[setCard!.shape.rawValue - 1]
        var shapesArr = [String]()
        for _ in 0..<setCard!.number.rawValue {
            shapesArr.append(shape)
        }
        var separator = ""
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            separator = "\n"
        case .landscapeLeft, .landscapeRight:
            separator = " "
        default:
            separator = " "
        }
        let title_string = shapesArr.joined(separator: separator)
        let attributedTitle = NSAttributedString(
            string: title_string,
            attributes: [
                NSAttributedString.Key.foregroundColor: colors[setCard!.color.rawValue - 1].withAlphaComponent(alphas[setCard!.fill.rawValue - 1]),
                NSAttributedString.Key.strokeWidth: strokeWidths[setCard!.fill.rawValue - 1],
                NSAttributedString.Key.strokeColor: colors[setCard!.color.rawValue - 1]]
        )
        self.borderColor = .clear
        self.backgroundColor = .white
        self.setAttributedTitle(attributedTitle, for: .normal)
        self.titleLabel?.font = titleLabel?.font.withSize(30.0)
        self.isEnabled = true
    }
}

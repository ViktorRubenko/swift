//
//  PlayingCardView.swift
//  PlayingCards
//
//  Created by Victor Rubenko on 17.01.2021.
//

import UIKit

class PlayingCardView: UIView {
    
    var rank: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    var suit: String = "❤️"
    var isFaceUp: Bool = true

    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle:paragraphStyle, NSAttributedString.Key.font:font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rank+"\n"+suit, fontSize: 0.0)
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 20.0)
        roundedRect.addClip()
        UIColor.purple.setFill()
        roundedRect.fill()
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width / 3, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//        path.lineWidth = 5.0
//        UIColor.green.setFill()
//        UIColor.red.setStroke()
//        path.stroke()
//        path.fill()
    }

}

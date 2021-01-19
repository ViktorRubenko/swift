//
//  SetCard.swift
//  SetGame
//
//  Created by Victor Rubenko on 17.01.2021.
//

import UIKit


@IBDesignable class BorderButton: UIButton {
    @IBInspectable var borderColor: UIColor = DefaultValues.borderColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = DefaultValues.borderWidth {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = DefaultValues.cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        init_config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        init_config()
    }
    
    private func init_config() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    private struct DefaultValues {
        static let borderColor: UIColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        static let borderWidth: CGFloat = 3.0
        static let cornerRadius: CGFloat = 7.0
    }
}

//
//  SetCard.swift
//  SetGame
//
//  Created by Victor Rubenko on 17.01.2021.
//

import UIKit


@IBDesignable class BorderButton: UIButton {
    @IBInspectable var borderColor: CGColor = DefaultValues.borderColor {
        didSet {
            layer.borderColor = borderColor
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
        layer.borderColor = borderColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    private struct DefaultValues {
        static let borderColor: CGColor = UIColor.green.cgColor
        static let borderWidth: CGFloat = 3.0
        static let cornerRadius: CGFloat = 7.0
    }
}

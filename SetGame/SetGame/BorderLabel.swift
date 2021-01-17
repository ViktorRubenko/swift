//
//  BorderLabel.swift
//  SetGame
//
//  Created by Victor Rubenko on 18.01.2021.
//

import UIKit

@IBDesignable class BorderLabel: UILabel {
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
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
    }

    private struct DefaultValues {
        static let borderColor: UIColor = UIColor.green
        static let borderWidth: CGFloat = 3.0
        static let cornerRadius: CGFloat = 7.0
    }

}

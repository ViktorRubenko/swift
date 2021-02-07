//
//  SetCardView.swift
//  Set
//
//  Created by Victor Rubenko on 31.01.2021.
//

import UIKit

@IBDesignable
class SetCardView: UIView {

    @IBInspectable
    var number: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() }}
    
    private var shape: Shape = .wave { didSet { setNeedsDisplay(); setNeedsLayout() }}
    private var shading: Shading = .solid { didSet { setNeedsDisplay(); setNeedsLayout() }}
    private var color: Color = .blue { didSet { setNeedsDisplay(); setNeedsLayout() }}
    
    @IBInspectable
    var shapeInt: Int = 1 {
        didSet {
            switch shapeInt {
            case 1: shape = .line
            case 2: shape = .rhombus
            case 3: shape = .wave
            default: break
            }
        }
    }
    @IBInspectable
    var shadingInt: Int = 1 {
        didSet {
            switch shadingInt {
            case 1: shading = .empty
            case 2: shading = .solid
            case 3: shading = .stripes
            default: break
            }
        }
    }
    @IBInspectable
    var colorInt: Int = 1 {
        didSet {
            switch colorInt {
            case 1: color = .blue
            case 2: color = .green
            case 3: color = .red
            default: break
            }
        }
    }
    
    @IBInspectable
    var isFaceUp: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var isSelected: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var isSet: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var faceBackgroundColor: UIColor = UIColor.white { didSet { setNeedsDisplay() }}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        isOpaque = false
        contentMode = .redraw
        layer.cornerRadius = bounds.height * Constants.cornerRadius
    }
    
    enum Shape: Int {
        case rhombus
        case wave
        case line
    }
    
    enum Shading: Int {
        case empty
        case stripes
        case solid
    }
    
    enum Color: Int {
        case green
        case red
        case blue
        
        var color: UIColor {
            switch self {
            case .green:
                return UIColor.green
            case .red:
                return UIColor.red
            case .blue:
                return UIColor.blue
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height * Constants.cornerRadius)
        faceBackgroundColor.setFill()
        roundedRect.fill()
        roundedRect.addClip()
        
        drawShapes()
        
        layer.borderWidth = 5
        layer.borderColor = isSet ? UIColor.red.cgColor : isSelected ? UIColor.blue.cgColor : UIColor.clear.cgColor
    }
    
    private func calcShapeRects() -> [CGRect] {
        var rects = [CGRect]()
        
        let rectWidth = bounds.width * 0.8
        let rectHeight = bounds.height / 6
        let xMin = bounds.minX + rectWidth * 0.1
        
        // create N rects for shapes
        switch number {
        case 1:
            rects.append(CGRect(x: xMin, y: bounds.midY - rectHeight/2, width: rectWidth, height: rectHeight))
        case 2:
            rects.append(CGRect(x: xMin, y: bounds.midY - rectHeight*1.50, width: rectWidth, height: rectHeight))
            rects.append(rects[0].offsetBy(dx: 0, dy: rectHeight*1.50))
        case 3:
            rects.append(CGRect(x: xMin, y: bounds.midY - rectHeight/2, width: rectWidth, height: rectHeight))
            rects.append(rects[0].offsetBy(dx: 0, dy: rectHeight*1.50))
            rects.append(rects[0].offsetBy(dx: 0, dy: -rectHeight*1.50))
        default:
            break
        }
        
        return rects
    }
    private func drawShapes() {
        let rects = calcShapeRects()
        // draw shape in each rect
        for rect in rects {
            var shapePath = UIBezierPath()
            switch shape {
            case .line:
                shapePath = drawLine(rect)
            case .rhombus:
                shapePath = drawRhombus(rect)
            case .wave:
                shapePath = drawWave(rect)
            }
            
            shapePath.lineWidth = bounds.width * Constants.borderWidth
            color.color.setStroke()
            shapePath.stroke()
            
            switch shading {
            case .empty:
                break
            case .solid:
                color.color.setFill()
                shapePath.fill()
            case .stripes:
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                shapePath.addClip()
                let stripe = UIBezierPath()
                stripe.lineWidth = bounds.width * Constants.stripeWidth
                stripe.move(to: CGPoint(x: rect.minX, y: rect.minY))
                stripe.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                let stripeInnerSpace = bounds.width * Constants.stripeInnerSpace
                for _ in 1...Int(rect.width/stripeInnerSpace) {
                    let translateion = CGAffineTransform(translationX: stripeInnerSpace, y: 0)
                    stripe.apply(translateion)
                    stripe.stroke()
                }
                context?.restoreGState()
            }  
        }
    }
    
    private func drawLine(_ rect: CGRect) -> UIBezierPath {
        let line = UIBezierPath()
        let radius = rect.height/2
        let width = (rect.width - radius*2)
        line.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.midY), radius: radius, startAngle: CGFloat.pi/2, endAngle: -CGFloat.pi/2, clockwise: true)
        line.addLine(to: CGPoint(x: rect.minX+width+radius, y: rect.midY-radius))
        line.addArc(withCenter: CGPoint(x: rect.minX+width+radius, y: rect.midY), radius: radius, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: true)
        line.close()
        return line
    }
    
    private func drawRhombus(_ rect: CGRect) -> UIBezierPath {
        let line = UIBezierPath()
        line.move(to: CGPoint(x: rect.minX, y: rect.midY))
        line.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        line.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        line.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        line.close()
        return line
    }
    
    private func drawWave(_ rect: CGRect) -> UIBezierPath {
        let radius = rect.height/4
        let width = (rect.width - radius*2)
        let height = rect.height/4
        func drawSine(_ line: UIBezierPath, origin: CGPoint, width: CGFloat, height: CGFloat) {
            for angle in stride(from: 5.0, to: 360.0, by: 5.0) {
                let x = origin.x + CGFloat(angle/360.0) * width * 0.8
                let y = origin.y + CGFloat(sin(angle/180.0 * Double.pi)) * height * 0.6
                line.addLine(to: CGPoint(x: x, y: y))
            }
        }
        let line = UIBezierPath()
        line.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.midY), radius: radius, startAngle: CGFloat.pi/2, endAngle: -CGFloat.pi/2, clockwise: true)
        drawSine(line, origin: line.currentPoint, width: CGFloat(width), height: CGFloat(height))
        line.addArc(withCenter: CGPoint(x: rect.minX+radius+width, y: rect.midY), radius: radius, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: true)
        drawSine(line, origin: line.currentPoint, width: CGFloat(-width), height: CGFloat(-height))
        line.close()
        return line
    }
    
    struct Constants {
        static let cornerRadius: CGFloat =  0.07
        static let stripeInnerSpace: CGFloat = 0.1
        static let stripeWidth: CGFloat = 0.05
        static let borderWidth: CGFloat = 0.04
    }
}

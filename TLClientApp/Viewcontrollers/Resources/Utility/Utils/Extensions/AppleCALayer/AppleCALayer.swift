//
//  AppleCALayer.swift
//  MyApp
//
//  Created by Shiv Kumar on 15/01/19.
//  Copyright © 2019 Spice. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

//MARK: Custom Layer to the Any Object
extension CALayer {
    public enum GradientDirection {
        case top, left, right, bottom,
        topLeftToRightBottom, topRightToLeftBottom, leftBottomToTopRight//, leftToRight
    }
    
    public func shadow(color: UIColor = UIColor.black,
                       opacity: Float = 1.0,
                       radius: CGFloat = 1.0,
                       offset: CGSize = .zero) {
        self.shadowColor = color.cgColor
        self.shadowOpacity = opacity
        self.shadowRadius = radius
        self.shadowOffset = offset
        self.masksToBounds = false
    }
    
    public func roundedCorner(radius: CGFloat? = nil) {
        var cornerRadius = CGFloat(roundf(Float(self.frame.size.height / 2.0)))
        if let r = radius {
            cornerRadius = r
        }
        self.masksToBounds = true
        self.cornerRadius = cornerRadius
    }
    
    public func border(color: UIColor, width: CGFloat) {
        self.borderColor = color.cgColor
        self.borderWidth = width
    }
    
    public func verticalDottedLayer(between points: [CGPoint], at index: Int)  {
        _ = sublayers?.filter { $0.name == "dottedlayer" }.compactMap{ $0.removeFromSuperlayer() }
        let lineLayer = CAShapeLayer()
        lineLayer.name = "dottedlayer"
        lineLayer.strokeColor = UIColor.gray.cgColor
        lineLayer.lineWidth = 1.4
        lineLayer.lineDashPattern = [3,3]
        let path = CGMutablePath()
        path.addLines(between: points)
        lineLayer.path = path
        // Create the animation for the shape view
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 2
        animation.duration = 2
        animation.repeatCount = 0
        lineLayer.cornerRadius = lineLayer.frame.size.width / 2
        // And finally add the linear animation to the shape!
        lineLayer.add(animation, forKey: "line")
        insertSublayer(lineLayer, at: UInt32(index))
    }
    
    public func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat = 1.0) {
        ///- Note: remove exist sublayer
        _ = sublayers?.filter { $0.name == "masklayer" }.compactMap{ $0.removeFromSuperlayer() }
        
        let borderLayer = CALayer()
        borderLayer.name = "masklayer"
        switch edge {
        case .top:
            borderLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            
        case .bottom:
            borderLayer.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            
        case .left:
            borderLayer.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            
        case .right:
            borderLayer.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            
        default:
            break
        }
        borderLayer.backgroundColor = color.cgColor
        addSublayer(borderLayer)
    }
    
    //MARK: Add the Gradient
    public func addGradient(colors: [CGColor] , direction: GradientDirection = .topLeftToRightBottom) {
        ///- Note: remove exist sublayer
        _ = sublayers?.filter { $0.name == "gradientLayer" }.compactMap { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.name = "gradientLayer"
        gradientLayer.colors = colors
        switch direction {
        case .right:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .left:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            
        case .bottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .top:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .topLeftToRightBottom:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            
        case .topRightToLeftBottom:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            
        case .leftBottomToTopRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        addSublayer(gradientLayer)
        insertSublayer(gradientLayer, at: 0)
    }
}

//MARK: ====: Draw Circle :====
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        self.lineCap = CAShapeLayerLineCap(rawValue: "round")
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

//
//  SKLabel.swift
//
//  Created by Shiv Kumar on 22/04/18.
//  Copyright © 2018 Shiv Kumar. All rights reserved.
//

import UIKit

@IBDesignable
class SKLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0
    
    // MARK: Padding FromAll Side.
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    @IBInspectable public var cornerRadius: CGFloat = 2.0 {
        didSet {
            clipsToBounds = true
            layer.cornerRadius = self.cornerRadius
        }
    }
    @IBInspectable var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    @IBInspectable
    var textShadowColor: UIColor = UIColor.black {
        didSet {
            layer.shadowOpacity = 0.8
            layer.shadowColor = textShadowColor.cgColor
            layer.shadowOffset = CGSize(width: 4, height: 4)
            // render and cache the layer
            layer.shouldRasterize = true
            // make sure the cache is retina (the default is 1.0)
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
}

//MARK: =====: UILabel :=====
/**
 * Here some operation with UILabel
 */
extension UILabel {
    public enum Attachment {
        case left, right
    }
    func setFont(name: String ,fontSize: CGFloat) {
        self.font =  UIFont(name: name, size: CGFloat(fontSize))!
        self.sizeToFit()
    }
    
    //MARK: ====: Attach Image With text :====
    func attachImage(_ image: UIImage, side attachment: Attachment, withString string: String){
        
        let attachmentText = NSTextAttachment()
        attachmentText.image = image
        
        let attachmentString = NSAttributedString(attachment: attachmentText)
        let addressString = NSAttributedString(string: string)
        let attributeString = NSMutableAttributedString(string:"")
        let spaceString = NSAttributedString(string:" ")
        
        attributeString.append(attachment == .left ? attachmentString : addressString)
        attributeString.append(spaceString)
        attributeString.append(attachment == .left ? addressString : attachmentString)
        
        self.attributedText = attributeString
    }
    
    /***** Blink UILabel ******/
    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.allowUserInteraction,
                                .curveEaseInOut,
                                .autoreverse,
                                .repeat],
                       animations: {
                        self.alpha = 0.2
                        
        },completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
    ///- remarks: Add the gradient on the text
    public func textGradientColor(colors: [CGColor]) {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }
        
        let size = self.frame.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return }
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return }
        let color = UIColor(patternImage: image)
        self.textColor = color
    }
}


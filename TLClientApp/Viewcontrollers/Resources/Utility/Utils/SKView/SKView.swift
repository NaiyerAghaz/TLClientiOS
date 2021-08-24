//
//  SKView.swift
//  SwiftDemo
//
//  Created by Shiv Kumar on 22/11/17.
//  Copyright © 2017 Shiv Kumar. All rights reserved.
//

import UIKit
import QuartzCore

private let UIViewAnimationDuration: TimeInterval = 0.3

public enum ShakeDirection {
    case horizontal
    case vertical
}
public enum ShakeAnimationType {
    case linear
    case easeIn
    case easeOut
    case easeInOut
}
// Default values here
private let deleyTime: TimeInterval = 0
private let springDamping: CGFloat = 0.25
private let springVelocity: CGFloat = 8.00
private let lowSpringDamping: CGFloat = 0.50
private let animationDuration: TimeInterval = 1.0

@IBDesignable class SKView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    @IBInspectable var circular: Bool = false {
        didSet { layer.cornerRadius = circular ? frame.size.height / 2 : 0 }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet { layer.borderColor = borderColor?.cgColor }
    }
    @IBInspectable var shadowColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5) {
        didSet { layer.shadowColor = shadowColor?.cgColor }
    }
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get { return Double(self.layer.shadowRadius) }
        set { self.layer.shadowRadius = CGFloat(newValue) }
    }
    @IBInspectable var dropShadow: Bool = false {
        didSet {
            layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            layer.masksToBounds = false
            layer.shadowRadius = 2.0
            layer.shadowOpacity = 0.5
        }
    }
    @IBInspectable var alphaBg: CGFloat = 1 {
        didSet { backgroundColor = self.backgroundColor?.withAlphaComponent(alphaBg) }
    }
    @IBInspectable var allSideShadow: Bool = false {
        didSet {
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 10.0
            layer.shadowOffset = .zero
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shouldRasterize = false
        }
    }
}

extension UIView {
    
    func corner(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    var xPos: CGFloat {
        let xAxis = self.frame.origin.x
        return xAxis
    }
    var yPos: CGFloat {
        let yAxis = self.frame.origin.y
        return yAxis
    }
    var width: CGFloat {
        let vWidth = self.frame.size.width
        return vWidth
    }
    var height: CGFloat {
        let vHight = self.frame.size.height
        return vHight
    }
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    func transform(at angle: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
    func renderToImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    private func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    func shadow(radius: CGFloat){
        let layer = self.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = radius
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func flipLeft() {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    func flipRight() {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    func flipBottom() {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromBottom, animations: nil, completion: nil)
    }
    func flipTop() {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
    }
    func crossDissolve() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    func flipCurlUp() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCurlUp, animations: nil, completion: nil)
    }
    func flipCurlDown() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCurlDown, animations: nil, completion: nil)
    }
    public func addBlurEffect() {
        let views = self
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.frame = (views.bounds)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        views.addSubview(blurEffectView)
    }
    /**
     Shaking view animation
     */
    public func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: ShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) {
        
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
    public func addSubViewOnWindow(withTag: Int = 1234567890) {
        let window = UIApplication.shared.keyWindow!
        //        frame = CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height)
        tag = withTag
        window.addSubview(self)
    }
    public func removeFromWindow(withTag: Int = 1234567890) {
        let window = UIApplication.shared.keyWindow!
        window.viewWithTag(withTag)?.removeFromSuperview()
    }
    public func addTapGesture(selector: Selector, tapRequired: Int = 1) {
        let tapG = UITapGestureRecognizer(target: self, action: selector)
        tapG.numberOfTapsRequired = tapRequired
        addGestureRecognizer(tapG)
    }
    public func dottedBorder(with color: UIColor) {
        let dottedBorderLayer = CAShapeLayer()
        dottedBorderLayer.strokeColor = color.cgColor
        dottedBorderLayer.lineDashPattern = [2, 2]
        dottedBorderLayer.frame = self.bounds
        dottedBorderLayer.fillColor = nil
        dottedBorderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        layer.addSublayer(dottedBorderLayer)
    }
    public func makeDashLine() {
        let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
        let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 0.8
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    //MARK:- Default Animation here
    public func animateView(){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Custom Animation here
    public func animateViewWithSpringDuration(_ name:UIView, animationDuration:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: springDamping, springVelocity: springVelocity)
    }
    
    //MARK:- Low Damping Custom Animation here
    public func animateViewWithSpringDurationWithLowDamping(_ name:UIView, animationDuration:TimeInterval, springVelocity:CGFloat){
        provideAnimation(animationDuration: animationDuration, deleyTime: deleyTime, springDamping: lowSpringDamping, springVelocity: springVelocity)
    }
    
    private func provideAnimation(animationDuration:TimeInterval, deleyTime:TimeInterval, springDamping:CGFloat, springVelocity:CGFloat){
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: animationDuration,
                       delay: deleyTime,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: springVelocity,
                       options: .allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
                       })
    }
}

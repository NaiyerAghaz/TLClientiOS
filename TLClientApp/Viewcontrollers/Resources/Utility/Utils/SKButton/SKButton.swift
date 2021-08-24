
//
//  SKButton.swift
//  SwiftDemo
//
//  Created by Shiv Kumar on 19/11/17.
//  Copyright © 2017 Shiv Kumar. All rights reserved.
//

import UIKit
private let UIViewAnimationDuration: TimeInterval = 0.3

@IBDesignable
class SKButton: UIButton {
    
    @IBInspectable open var rippleOverBounds: Bool = false
    @IBInspectable open var shadowRippleRadius: Float = 1
    @IBInspectable open var shadowRippleEnable: Bool = true
    @IBInspectable open var trackTouchLocation: Bool = false
    @IBInspectable open var touchUpAnimationTime: Double = 0.6
    
    let rippleView = UIView()
    let rippleBackgroundView = UIView()
    let gradientLayer = CAGradientLayer()
    
    fileprivate var tempShadowRadius: CGFloat = 0
    fileprivate var tempShadowOpacity: Float = 0
    fileprivate var touchCenterLocation: CGPoint?
    //@IBInspectable from here...
    // MARK: Set Ripple of UIButton
    @IBInspectable open var ripplePercent: Float = 0.8 {
        didSet {
            setupRippleView()
        }
    }
    // MARK: Set Ripple color of UIButton
    @IBInspectable open var rippleColor: UIColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }
    // MARK: Set Ripple BackgroundColor of UIButton
    @IBInspectable open var rippleBackgroundColor: UIColor = UIColor(white: 0.95, alpha: 1) {
        didSet {
            rippleBackgroundView.backgroundColor = rippleBackgroundColor
        }
    }
    // MARK: Set Corner Radius of UIButton
    @IBInspectable open var cornerRadiusBtn: Float = 0 {
        didSet{
            layer.cornerRadius = CGFloat(cornerRadiusBtn)
        }
    }
    // MARK: Set Corner Radius of UIButton
    @IBInspectable open var makeCircular: Bool = false {
        didSet{
            if makeCircular {
                layer.cornerRadius = self.frame.size.height / 2
            } else {
                layer.cornerRadius = 0
            }
        }
    }
    // MARK: Set Border Width of UIButton
    @IBInspectable open var borderWidth: Float = 0 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    // MARK: Set Border Color of UIButton
    @IBInspectable open var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    // MARK: Set Top Gradient Color of UIButton
    @IBInspectable var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    // MARK: Set Bottom Gradient Color of UIButton
    @IBInspectable var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    // MARK: Private function to create Gradient according to color
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    fileprivate var rippleMask: CAShapeLayer? {
        get {
            if !rippleOverBounds {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds,
                                              cornerRadius: layer.cornerRadius).cgPath
                return maskLayer
            }
            return nil
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup() {
        setupRippleView()
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.addSubview(rippleView)
        rippleBackgroundView.alpha = 0
        addSubview(rippleBackgroundView)
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
    }
    
    fileprivate func setupRippleView() {
        let size: CGFloat = bounds.width * CGFloat(ripplePercent)
        let x: CGFloat = (bounds.width/2) - (size/2)
        let y: CGFloat = (bounds.height/2) - (size/2)
        let corner: CGFloat = size/2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRect(x: x, y: y, width: size, height: size)
        rippleView.layer.cornerRadius = corner
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if trackTouchLocation {
            touchCenterLocation = touch.location(in: self)
        } else {
            touchCenterLocation = nil
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.rippleBackgroundView.alpha = 1
                       }, completion: nil)
        
        rippleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.allowUserInteraction],
                       animations: {
                        self.rippleView.transform = CGAffineTransform.identity
                       }, completion: nil)
        
        if shadowRippleEnable {
            tempShadowRadius = layer.shadowRadius
            tempShadowOpacity = layer.shadowOpacity
            
            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnim.toValue = shadowRippleRadius
            
            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnim.toValue = 1
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = CAMediaTimingFillMode.forwards
            groupAnim.isRemovedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            layer.add(groupAnim, forKey:"shadow")
        }
        return super.beginTracking(touch, with: event)
    }
    
    override open func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        animateToNormal()
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        animateToNormal()
    }
    
    fileprivate func animateToNormal() {
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
        }, completion: {(success: Bool) -> () in
            UIView.animate(withDuration: self.touchUpAnimationTime,
                           delay: 0,
                           options: .allowUserInteraction,
                           animations: {
                            self.rippleBackgroundView.alpha = 0
                           }, completion: nil)
        })
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        self.rippleView.transform = CGAffineTransform.identity
                        
                        let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
                        shadowAnim.toValue = self.tempShadowRadius
                        
                        let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
                        opacityAnim.toValue = self.tempShadowOpacity
                        
                        let groupAnim = CAAnimationGroup()
                        groupAnim.duration = 0.7
                        groupAnim.fillMode = CAMediaTimingFillMode.forwards
                        groupAnim.isRemovedOnCompletion = false
                        groupAnim.animations = [shadowAnim, opacityAnim]
                        self.layer.add(groupAnim, forKey:"shadowBack")
                       }, completion: nil)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupRippleView()
        if let knownTouchCenterLocation = touchCenterLocation {
            rippleView.center = knownTouchCenterLocation
        }
        rippleBackgroundView.layer.frame = bounds
        rippleBackgroundView.layer.mask = rippleMask
    }
}

//MARK: 👇🏿***** Add Button Target Action as Closure *****👇🏿
typealias UIButtonTargetClosures = (UIButton) -> ()

class ClosureWrappers: NSObject {
    let closure: UIButtonTargetClosures
    init(_ closure: @escaping UIButtonTargetClosures) {
        self.closure = closure
    }
}

extension UIButton {
    
    private static var _buttonTitle = String()
    private var buttonTitle: String {
        get {return ""}
        set { UIButton._buttonTitle = newValue }
    }
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosures? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrappers else {
                return nil
            }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else {
                return
            }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrappers(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargets(_ closure: @escaping UIButtonTargetClosures) {
        targetClosure = closure
        addTarget(self, action: #selector(self.closureActions), for: .touchUpInside)
    }
    
    @objc func closureActions() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    //End of Button target
    
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, target: AnyObject, action: Selector) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }
    public func cornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    /// SwifterSwift: Center align title text and image on UIButton
    ///
    /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
    public func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    public func image(_ image: UIImage, title name: String, forState: UIControl.State = .normal) {
        self.setImage(image, for: forState)
        self.setTitle(!(name.isEmpty) ? name : "", for: forState)
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }
    /** - Remarks: Send Button is Enable & Disable according to text length
     */
    func isEnabled(_ isEnabled: Bool = true){
        MainQueue.async {
            self.isEnabled = isEnabled
            self.alpha = isEnabled ? 1 : 0.7
        }
    }
    /**
     * Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = UIViewAnimationDuration) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = UIViewAnimationDuration) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    func setRenderImage(_ image: UIImage, withColor color: UIColor){
        let stencil = image.withRenderingMode(.alwaysTemplate) // use your UIImage here
        self.setImage(stencil, for: .normal) // assign it to your UIButton
        self.tintColor = color // set a color
    }
    
    public func showLoader(color: UIColor = .black, alpha: CGFloat = 1) {
        let tag = -808404
        UIButton._buttonTitle = self.titleLabel?.text ?? ""
        self.isEnabled = false
        self.alpha = alpha
        let indicator = UIActivityIndicatorView()
        indicator.style = .white
        indicator.color = color
        let buttonHeight = self.bounds.size.height
        let buttonWidth = self.bounds.size.width
        indicator.center = CGPoint(x: (buttonWidth/2) - indicator.frame.width, y: (buttonHeight/2) - indicator.frame.height)
        indicator.tag = tag
        subviews.forEach {
            if $0.tag == tag {
                $0.removeFromSuperview()
            }
        }
        indicator.hidesWhenStopped = true
        self.addSubview(indicator)
        self.insertSubview(indicator, at: 0)
        DispatchQueue.main.async {
            indicator.startAnimating()
        }
        self.setTitle(nil, for: .normal)
    }
    func hideLoader() {
        let tag = -808404
        DispatchQueue.main.async {
            self.isEnabled = true
        }
        self.isUserInteractionEnabled = true
        self.alpha = 1
        if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
            DispatchQueue.main.async {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                self.setTitle( UIButton._buttonTitle, for: .normal)
            }
        }
    }
    //MARK: Make the rounded of button
    func roundedCorners(_ corners: UIRectCorner){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    //MARK: IS Button is visible
    public func isVisible(_ visible: Bool) {
        if !visible {
            UIView.transition(with: self,
                              duration: .O3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.isHidden = visible
                                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                              })
        }else {
            UIView.animate(withDuration: .O3,
                           delay: 0,
                           options: .curveLinear,
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                           }, completion: { _ in
                            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                            self.isHidden = visible
                           })
        }
    }
}



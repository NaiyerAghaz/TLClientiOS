//
//  UIImage+Extension.swift
//  CampusOnNet
//
//  Created by Spice-Africa on 28/11/18.
//  Copyright © 2018 Spice-Africa. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit

private var activityIndicatorAssociationKey: UInt8 = 0
private let animationDelay: TimeInterval = 0.3
fileprivate var orginImageView: UIImageView!

//MARK: Image Extension
extension UIImageView: UIScrollViewDelegate {
    
    @IBInspectable
    var blurEffect: Bool {
        get { return false }
        set {
            if newValue {
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.alpha = 1
                blurEffectView.frame = (self.bounds)
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                addSubview(blurEffectView)
            }
        }
    }
    @IBInspectable
    var makeRounded: CGFloat {
        get { return 0.0 }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var makeCircular: Bool {
        get { return false }
        set {
            if (newValue) {
                self.layer.cornerRadius = self.frame.size.height / 2
            }
        }
    }
    public func circular(borderColor: UIColor, width: CGFloat = 1.5){
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    public func shadowImage(_ radius: CGFloat){
        let layer = self.layer
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 100.0).cgPath
    }
    //Scales this ImageView size to fit the given width
    func scaleImage(_ width: CGFloat) {
        guard let image = image else {
            return
        }
        let widthRatio = image.size.width / width
        let newWidth = image.size.width / widthRatio
        let newHeigth = image.size.height / widthRatio
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newWidth, height: newHeigth)
    }
    /**
     * This func show full screen preview of image with animation.
     * It Show the image animation from there point respect to window.
     */
    func showFullImage() {
        if let img = self.image {
            let image: UIImage? = img
            orginImageView = self
            orginImageView.alpha = 0
            let window: UIWindow? = UIApplication.shared.keyWindow
            let backgroundView = UIView(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            let oldframe: CGRect = self.convert(self.bounds, to: window)
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            backgroundView.alpha = 1
            //            let scrollView = UIScrollView(frame: backgroundView.bounds)
            //            scrollView.minimumZoomScale = 1.0
            //            scrollView.maximumZoomScale = 5.0
            let imageView = UIImageView(frame: oldframe)
            imageView.image = image
            imageView.tag = 1
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            //            scrollView.addSubview(imageView)
            //            scrollView.delegate = self
            backgroundView.addSubview(imageView)
            window?.addSubview(backgroundView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideImage(_:)))
            backgroundView.addGestureRecognizer(tap)
            UIView.animate(withDuration: animationDelay,
                           animations: {() -> Void in
                            imageView.frame = CGRect(x: CGFloat(0), y: CGFloat((UIScreen.main.bounds.size.height - (image?.size.height)! * UIScreen.main.bounds.size.width / (image?.size.width)!) / 2), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat((image?.size.height)! * UIScreen.main.bounds.size.width / (image?.size.width)!))
                            backgroundView.alpha = 1
                           }, completion: {(_ finished: Bool) -> Void in
                           })
        }
        //        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //            for view in scrollView.subviews where view is UIImageView {
        //                return view as! UIImageView
        //            }
        //            return nil
        //        }
    }
    /**
     * Hide preview image with animation.
     */
    @objc func hideImage(_ tap: UITapGestureRecognizer) {
        let backgroundView: UIView? = tap.view
        let imageView: UIImageView? = (tap.view?.viewWithTag(1) as? UIImageView)
        UIView.animate(withDuration: animationDelay,
                       animations: {() -> Void in
                        imageView?.frame = orginImageView.convert(orginImageView.bounds, to: UIApplication.shared.keyWindow)
                        imageView?.layer.cornerRadius = (imageView?.frame.size.height)!/2
                       }, completion: {(_ finished: Bool) -> Void in
                        backgroundView?.removeFromSuperview()
                        orginImageView.alpha = 1
                        backgroundView?.alpha = 0
                       })
    }
    /**
     * Color image here & Set tint color of the object on whict U set image.
     */
    func renderingMode(_ color: UIColor){
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    private var activityIndicator: UIActivityIndicatorView! {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func showImageLoader(color: UIColor = UIColor.black) {
        if (self.activityIndicator == nil) {
            self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            self.activityIndicator.style = .gray
            self.activityIndicator.color = color
            self.activityIndicator.center = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
            self.activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin,.flexibleBottomMargin]
            self.activityIndicator.isUserInteractionEnabled = false
            
            OperationQueue.main.addOperation({ () -> Void in
                self.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
                self.activityIndicator.hidesWhenStopped = true
            })
        }
    }
    func hideImageLoader() {
        OperationQueue.main.addOperation({ () -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        })
    }
    public func drawDottedImage(width: CGFloat, height: CGFloat, color: UIColor) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5,y: 5))
        path.addLine(to: CGPoint(x:290,y: 5))
        path.lineWidth = 8
        
        let dashes: [CGFloat] = [0.001, path.lineWidth * 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = .butt
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width:300, height:10), false, 2)
        
        UIColor.white.setFill()
        UIGraphicsGetCurrentContext()!.fill(.infinite)
        
        UIColor.lightGray.setStroke()
        path.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let view = UIImageView(image: image)
        
        UIGraphicsEndImageContext()
        
        self.image = view.image
    }
    public func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.35 : 0.0
        UIView.transition(with: self, duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {
            self.image = image
        }, completion: nil)
    }
}

//MARK: =====: UIImage Extensions:=====
/**
 * Here some operation with UIImage
 */
extension UIImage{
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    /**
     *  This func is using to scale image from new height and width
     */
    func scaleSize(w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    /**
     *  This func is using to resize image according to new width
     */
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    /** - returns:
     *  This func is using to conver the image into string by using base64 format
     */
    var imageToBase64String: String? {
        let imageData = self.jpegData(compressionQuality: 0.5)
        let dataString = imageData?.base64EncodedData(options: .lineLength64Characters)
        let base64String = String(data: dataString!, encoding: .utf8)
        return base64String ?? ""
    }
    /**- returns: This func is using to masking the image from core graphic.
     To create rounded image.
     */
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /**- returns:
     *  This func is using to change the UIImage color.
     * Set any color of the UIImage.
     */
    func tintColor(_ color: UIColor) -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        /// - Returns:
        return newImage
    }
    /**
     *  This func is using to load the gif on imageView from Data.
     *  Data should not be nil.
     */
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    /**
     *  This func is using to load the gif on imageView from URL.
     *  Url should be valid otherwise app may be crash.
     */
    public class func gif(url: String) -> UIImage? {
        // URL should be Validate URL
        guard let bundleURL = URL(string: url) else {
            return nil
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        return gif(data: imageData)
    }
    /**
     *  This func is using to load the gif on imageView from assets.
     */
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            return nil
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        return gif(data: imageData)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        return animation
    }
    /*************** Load GIF Image End ***************/
    //Reduse the size of the image
    func compressImage() -> UIImage? {
        // Reducing file size to a 10th
        var actualHeight: CGFloat = self.size.height
        var actualWidth: CGFloat = self.size.width
        let maxHeight: CGFloat = 1136.0
        let maxWidth: CGFloat = 640.0
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        var compressionQuality: CGFloat = 0.5
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                // if image is low quality it will remain actual size
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = img.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

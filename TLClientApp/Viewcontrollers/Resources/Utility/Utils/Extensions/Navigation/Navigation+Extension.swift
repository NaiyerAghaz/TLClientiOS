//
//  Navigation+Extension.swift
//  EssayWriter
//
//  Created by Shiv Kumar on 24/05/18.
//  Copyright © 2018 Shiv Kumar. All rights reserved.
//

import Foundation
import UIKit

/**
 * This extension is used to setup UINavigation controller
 */
extension UINavigationController {
    
    public func navigationSetup(color: UIColor) {
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 18) as Any]
    }
    public func addSubView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    public func removeFromSuperView(tag: Int) {
        for item in self.view.subviews {
            if item.tag == tag {
                item.removeFromSuperview()
            }
        }
    }
    public func isHidden(_ bool:Bool){
        setNavigationBarHidden(bool, animated: true)
    }
    public func setColor(_ color: UIColor){
        navigationBar.barTintColor = color
        navigationBar.barStyle = UIBarStyle.default
        navigationBar.isTranslucent = false
    }
    public func setAttributeTitle(_ color: UIColor){
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: (UIFont(name: "Helvetica-Bold", size: 18))!, NSAttributedString.Key.foregroundColor: color]
    }
    public func setBackground(image img: UIImage){
        navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }
    public func navigationBarClear() {
        setNavigationBarHidden(false, animated:false)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = nil
        navigationBar.isTranslucent = true
    }
    public func navigationBarDefault() {
        navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationBar.shadowImage = nil
        navigationBar.tintColor = nil
        navigationBar.isTranslucent = false
    }
    public func showDropShadow() {
        navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationBar.layer.shadowRadius = 4.0
        navigationBar.layer.shadowOpacity = 1.0
        navigationBar.layer.masksToBounds = false
    }
    /**
     * Here Some function which are using to design navigation bar.
     */
    public func navigationBar(title: String, font name: String = "Helvetica Bold", withColor color: UIColor){
        navigationItem.title = title
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: (UIFont(name: name, size: 18))!, NSAttributedString.Key.foregroundColor: color]
    }
    public func navigationBar(isHidden: Bool){
        setNavigationBarHidden(isHidden, animated: true)
    }
    public func navigationBackButton(isHidden: Bool) {
        navigationItem.setHidesBackButton(isHidden, animated:true);
    }
    public func navigationBarColor(_ color: UIColor){
        navigationBar.barTintColor = color
        navigationBar.barStyle = UIBarStyle.default
        navigationBar.isTranslucent = false
    }
    public func navigationBackground(image img: UIImage){
        navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }
    public var topBarHeight: CGFloat {
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (navigationBar.frame.height)
        return topBarHeight
    }
    public func hide_1pxBottomLine() {
        self.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.layoutIfNeeded()
    }
    public func show_1pxBottomLine() {
        self.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.layoutIfNeeded()
    }
    /**
     * This func is use to show large Title in iOS 11 or greater then.
     * Don't use this func into iOS 11 lower version.
     */
    public func navigationLarge(title: String, withColor color: UIColor) {
        if #available(iOS 11.0, *) {
            self.navigationItem.title = title
            navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
            navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold) ]
        }
    }
    public func popToViewController(ofClass: AnyClass, animated: Bool = true) {
      if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
        popToViewController(vc, animated: animated)
      }
    }
}

//MARK: Navigation Bar
extension UINavigationBar {
    public var setTransparent: Void {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        backgroundColor = .clear
    }
    public func toggle() {
        if self.layer.zPosition == -1 {
            self.layer.zPosition = 0
            self.isUserInteractionEnabled = true
        } else {
            self.layer.zPosition = -1
            self.isUserInteractionEnabled = false
        }
    }
}


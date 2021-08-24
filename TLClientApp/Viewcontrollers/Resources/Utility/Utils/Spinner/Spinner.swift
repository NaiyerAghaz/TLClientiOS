//
//  Spinner.swift
//
//  Created by JMD on 11/09/19.
//  Copyright © 2019 JMD All rights reserved.
//

import Foundation
import UIKit

open class Spinner {
    
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .gray
    public static var baseBackColor = UIColor.black.withAlphaComponent(0.3)
    public static var baseColor = UIColor.white
    
    public static func start(style: UIActivityIndicatorView.Style = style,
                             backColor: UIColor = baseBackColor,
                             baseColor: UIColor = baseColor, intraction: Bool = false) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            if intraction { 
                spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                spinner?.center = window.center
                spinner?.backgroundColor = .clear
            } else {
                spinner = UIActivityIndicatorView(frame: frame)
                spinner?.backgroundColor = backColor
            }
            spinner?.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner?.startAnimating()
        }
    }
    public static func stop() {
        if spinner != nil {
            MainQueue.async {
                self.spinner?.stopAnimating()
                self.spinner?.removeFromSuperview()
                self.spinner = nil
            }
        }
    }
    @objc public static func update() {
        if spinner != nil {
            MainQueue.async {
                stop()
                start()
            }
        }
    }
}

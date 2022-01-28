//
//  PlayBackHealthAlertBar.swift
//  PlayBackHealth
//
//  Created by Developer on 04/10/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import SwiftMessages
import UIKit
public class PHAlertBar {
    /// This method will used to display a Message Bar on the screen.
    ///
    ///     MessageBar.show(.info, title: "OPTIONAL TITLE", message: "YOUR MESSAGE HERE")
    ///     MessageBar.show(.success, title: "OPTIONAL TITLE", message: "YOUR MESSAGE HERE")
    ///     MessageBar.show(.warning, title: "OPTIONAL TITLE", message: "YOUR MESSAGE HERE")
    ///     MessageBar.show(.error, title: "OPTIONAL TITLE", message: "YOUR MESSAGE HERE")
    ///
    /// - Parameters:
    ///   - theme: Type of Message Bar you wanted to display. There are 4 types available. - error | success | warning | info
    ///   - title: String Title you wanted to display on message. Pass nil here if you wanted to display default title based on the theme. If value if this param is passed then it will override the default title.
    ///   - message: String Message you wanted to display on message.
    public class func show(_ theme: Theme, title: String? = nil, message: String) {
        // -- View setup
        let view: MessageView = MessageView.viewFromNib(layout: .cardView)
        
        //        DispatchQueue.main.async {
        //            SwiftMessages.show(config: config, view: view)
        //        }
        
        //  view.backgroundView.cornerRadius = 12.0
        
        view.configureContent(title: "Info", body: message.localized, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        // Icon Style
        
        
        // Theme
        switch theme {
        case .info:
            view.configureTheme(backgroundColor:UIColor(red: 0.745, green: 0.745, blue: 0.745, alpha: 0.9) , foregroundColor: UIColor(red: 0.09, green: 0.094, blue: 0.176, alpha: 1), iconImage: UIImage(named: "ic_Info"), iconText: nil)
            
            //  view.configureTheme(backgroundColor: UIColor.hexString("CFD8DC"), foregroundColor: .white, iconImage: iconStyle.image(theme: .info), iconText: nil)
            view.titleLabel?.text = "Error"
        case .success:
            view.configureTheme(backgroundColor: UIColor(red: 0.745, green: 0.745, blue: 0.745, alpha: 0.9), foregroundColor: UIColor(red: 0.09, green: 0.094, blue: 0.176, alpha: 1), iconImage: UIImage(named: "success_ic"), iconText: nil)
            
            //  view.configureTheme(backgroundColor: UIColor.hexString("00C853"), foregroundColor: .white, iconImage: iconStyle.image(theme: .success), iconText: nil)
            view.titleLabel?.text = "Success"
        case .warning:
            view.configureTheme(backgroundColor: UIColor(red: 0.745, green: 0.745, blue: 0.745, alpha: 0.9) , foregroundColor: UIColor(red: 0.09, green: 0.094, blue: 0.176, alpha: 1), iconImage: UIImage(named: "ic_warning") , iconText: nil)
            //  view.configureTheme(backgroundColor: UIColor.hexString("FFAB00"), foregroundColor: .white, iconImage: iconStyle.image(theme: .warning), iconText: nil)
            view.titleLabel?.text = "Warning"
        case .error:
            view.configureTheme(backgroundColor: UIColor(red: 0.745, green: 0.745, blue: 0.745, alpha: 0.9), foregroundColor: UIColor(red: 0.09, green: 0.094, blue: 0.176, alpha: 1), iconImage: UIImage(named:"ic_error"), iconText: nil)
            //   view.configureTheme(backgroundColor: UIColor.hexString("FC2125"), foregroundColor: .white, iconImage: iconStyle.image(theme: .error), iconText: nil)
            view.titleLabel?.text = "Error"
        }
        
        view.titleLabel?.text = ""
        
        if title != nil {
            view.titleLabel?.text = title!
        }
        
        // Set Font
        view.titleLabel?.font = UIFont(name: "Arial", size: 16)//UIFont.init(name: .poppinsBold, size: 20) //  view.titleLabel?.font = UIFont.appFont(14.0, .medium)
        
        // Set Shadow
        view.configureDropShadow()
        
        // Set Button
        view.button?.isHidden = true
        
        // Show Icon
        view.iconImageView?.isHidden = false
        
        view.iconLabel?.isHidden = false
        
        // Show Title
        view.titleLabel?.isHidden = false
        
        // Show Body
        view.bodyLabel?.isHidden = false
        
        // -- Config setup
        
        var config = SwiftMessages.defaultConfig
        
        // Presentation
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        
        // Duration
        config.duration = .seconds(seconds: 3)
        
        // Rotation
        config.shouldAutorotate = true
        
        // Hide on Interaction
        config.interactiveHide = true
        
        // Show Message Bar
        DispatchQueue.main.async {
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    //This method will used to display a Message Bar on the screen.
    ///
    ///     MessageBar.show(.info, title: "OPTIONAL TITLE", message: "YOUR MESSAGE HERE")
    ///     MessageBar.show(.success, title: "OPTIONAL TITLE", message: "YOUR MESSAGE HERE")
    ///     MessageBar.show(.warning, title: "OPTIONAL TITLE", message: "YOUR MESSAGE HERE")
    ///     MessageBar.show(.error, title: "OPTIONAL TITLE", message: "YOUR MESSAGE HERE")
    ///
    /// - Parameters:
    ///   - theme: Type of Message Bar you wanted to display. There are 4 types available. - error | success | warning | info
    ///   - title: String Title you wanted to display on message. Pass nil here if you wanted to display default title based on the theme. If value if this param is passed then it will override the default title.
    ///   - message: String Message you wanted to display on message.
    public class func showInternetError() {
        // -- View setup
        let view: MessageView = MessageView.viewFromNib(layout: .statusLine)
        
        //        DispatchQueue.main.async {
        //            SwiftMessages.show(config: config, view: view)
        //        }
        
        //  view.backgroundView.cornerRadius = 12.0
        
        view.configureContent(title: "Info", body: "NoInternet".localized, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        // Icon Style
        let iconStyle: IconStyle = .default
        
        view.configureTheme(backgroundColor: UIColor(red: 177 / 255, green: 69 / 255, blue: 59 / 255, alpha: 1.01), foregroundColor: .white, iconImage: iconStyle.image(theme: .error), iconText: nil)
        //   view.configureTheme(backgroundColor: UIColor.hexString("FC2125"), foregroundColor: .white, iconImage: iconStyle.image(theme: .error), iconText: nil)
        view.titleLabel?.text = "Error"
        
        view.titleLabel?.text = ""
        
        // Set Font
        view.titleLabel?.font = UIFont(name: "Arial", size: 16)//UIFont.init(type: .poppinsMedium, size: 21) //  view.titleLabel?.font = UIFont.appFont(14.0, .medium)
        
        // Set Shadow
        view.configureDropShadow()
        
        // Set Button
        view.button?.isHidden = true
        
        // Show Icon
        view.iconImageView?.isHidden = false
        view.iconLabel?.isHidden = false
        
        // Show Title
        view.titleLabel?.isHidden = false
        
        // Show Body
        view.bodyLabel?.isHidden = false
        
        // -- Config setup
        
        var config = SwiftMessages.defaultConfig
        
        // Presentation
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        
        // Duration
        config.duration = .automatic
        
        // Rotation
        config.shouldAutorotate = true
        
        // Hide on Interaction
        config.interactiveHide = true
        
        // Show Message Bar
        DispatchQueue.main.async {
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    /// This method will hide all the Messages which are displayed and also clear the queue.
    public class func hide() {
        SwiftMessages.hideAll()
    }
}

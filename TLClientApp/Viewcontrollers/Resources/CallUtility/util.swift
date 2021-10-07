//
//  util.swift
//  TLClientApp
//
//  Created by Naiyer on 8/28/21.
//

import Foundation
import UIKit
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

struct TokenUtils {
    static func fetchToken(url : String) throws -> String {
        var token: String = "TWILIO_ACCESS_TOKEN"
        let requestURL: URL = URL(string: url)!
        do {
            let data = try Data(contentsOf: requestURL)
            if let tokenReponse = String(data: data, encoding: String.Encoding.utf8) {
                token = tokenReponse
            }
        } catch let error as NSError {
            print ("Invalid token url, error = \(error)")
            throw error
        }
        return token
    }
}
enum TypeNotification: String {
    
    case notavailable = "notavailable"
}
extension UIView {
    func addBorder(edge: UIRectEdge,
                   color: UIColor,
                   thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0,
                                  y: 0,
                                  width: frame.width,
                                  height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0,
                                  y: frame.height - thickness,
                                  width: frame.width,
                                  height: thickness)
        case .left:
            border.frame = CGRect(x: 0,
                                  y: 0,
                                  width: thickness,
                                  height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness,
                                  y: 0,
                                  width: thickness,
                                  height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        
        layer.addSublayer(border)
    }
    
    var safeAreaHeight: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame.size.height
        }
        return bounds.height
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.masksToBounds = true
    }
    
    class func loadFromNibNamed(_ nibNamed: String,
                                bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed,
                     bundle: bundle).instantiate(withOwner: nil,
                                                 options: nil)[0] as? UIView
    }
    
    class func loadFromNibNamedWithViewIndex(_ nibNamed: String,
                                             bundle: Bundle? = nil,
                                             index: Int) -> UIView? {
        return UINib(nibName: nibNamed,
                     bundle: bundle).instantiate(withOwner: nil,
                                                 options: nil)[index] as? UIView
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        animation.autoreverses = false
        layer.add(animation, forKey: "shake")
    }
}

extension String {
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
        /// This will get the Localization String from the string file based on the current language
        ///
        ///        "Your String".localized -> "Localized string from the file" // second week in the current year.
        ///
        public var localized: String {
            // Set your Application Langugage here. You can set your custom logic here to get the language code string.
            
            var strLang: String? = "en"
            
            // Check for the default Language
            if strLang == nil {
                strLang = "en"
            }
           // LanguageManager.sharedInstance.setCurrentLanguage(strLang!)
            
            // Get the Path for the String file based on language selction
            guard let path = Bundle.main.path(forResource: strLang, ofType: "lproj") else {
                return self
            }
            
            // Get the Bundle Path
            let langBundle = Bundle(path: path)
            
            // Get the Local String for Key and return it
            return langBundle?.localizedString(forKey: self, value: "", table: nil) ?? self
        }
    
}

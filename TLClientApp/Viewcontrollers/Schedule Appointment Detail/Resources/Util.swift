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
            guard let newpath = Bundle.main.path(forResource: strLang, ofType: "lproj") else {
                return self
            }
            
            // Get the Bundle Path
            let langBundle = Bundle(path: newpath)
            
            // Get the Local String for Key and return it
            return langBundle?.localizedString(forKey: self, value: "", table: nil) ?? self
        }
    
}
class cEnum: NSObject {
    static let instance = cEnum()
    func getCurrentDateAndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        let cDate = dateFormatter.string(from: Date())
        return cDate
    }
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
}
extension UIViewController {
    func dismissViewControllers() {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
         //  self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
   //        guard let vc = self.presentingViewController else { return }
   //
   //        while (vc.presentingViewController != nil) {
   //            vc.dismiss(animated: true, completion: nil)
   //        }
       }
}


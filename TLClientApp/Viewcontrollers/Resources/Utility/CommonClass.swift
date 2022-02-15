//
//  CommonClass.swift
//  TLClientApp
//
//  Created by Naiyer on 8/9/21.
//

import Foundation
import UIKit
import AVFoundation
import SystemConfiguration
var myAudio: AVAudioPlayer!
class CEnumClass: NSObject {
    static let share = CEnumClass()
    func convertToJSON(resulTDict:NSDictionary) -> NSDictionary {
        let theJSONData = try? JSONSerialization.data(withJSONObject: resulTDict ,options: JSONSerialization.WritingOptions(rawValue: 0))
        let jsonString = NSString(data: theJSONData!,encoding: String.Encoding.utf8.rawValue)
        let returnDict = self.convertToDictionary(text:jsonString! as String)
        let userData = returnDict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        return userData as NSDictionary
    }
    
    func convertToJSONFromData(resulTDict:NSData) -> NSDictionary {
        let theJSONData = try? JSONSerialization.data(withJSONObject: resulTDict ,options: JSONSerialization.WritingOptions(rawValue: 0))
        let jsonString = NSString(data: theJSONData!,encoding: String.Encoding.utf8.rawValue)
        let returnDict = self.convertToDictionary(text:jsonString! as String)
        let userData = returnDict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        return userData as NSDictionary
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let jsonDict =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
                return jsonDict as? [String : Any]
            } catch {
                //print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func parseValueFromkey(anyObj:Any) -> NSString {
        
        if let a = anyObj as? NSNumber {
            return a.stringValue as NSString
        }else if ((anyObj as? NSNull) != nil) {
            return ""
        } else {
            return anyObj as! NSString
        }
    }
    func loadKeydata(keyname: String) -> String{
        if let uName = keychainServices.getKeychaindata(key: keyname) {
            return String(decoding: uName, as: UTF8.self)
          }
        else{
            return ""
        }
        
    }
    func transParentNav(nav: UINavigationController?) {
        nav?.setNavigationBarHidden(false, animated: false)
        nav?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        nav?.navigationBar.shadowImage = UIImage()
        nav?.navigationBar.isTranslucent = true
        nav?.view.backgroundColor = .clear
    }
    func playSounds(audioName: String) {
       
       let path = Bundle.main.path(forResource: audioName, ofType: "mp3")!
       let url = URL(fileURLWithPath: path)
       do {
           let sound = try AVAudioPlayer(contentsOf: url)
           myAudio = sound
           sound.play()
       } catch {
           //
       }
       func changeThemeMethod(){
           
       }
   }
    
    func playSoundsWave(audioName: String) {
       
       let path = Bundle.main.path(forResource: audioName, ofType: "wav")!
       let url = URL(fileURLWithPath: path)
       do {
           let sound = try AVAudioPlayer(contentsOf: url)
           myAudio = sound
           sound.play()
       } catch {
           //
       }
   
}
    
    
    
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
extension UITextField {

enum Direction {
    case Left
    case Right
}

// add image to textfield
func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    mainView.layer.cornerRadius = 5

    let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    view.backgroundColor = .white
    view.clipsToBounds = true
   // view.layer.cornerRadius = 5
    //view.layer.borderWidth = CGFloat(0.5)
   // view.layer.borderColor = colorBorder.cgColor
    mainView.addSubview(view)

    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 2.0, y: 4.0, width: 16, height: 16)
    view.addSubview(imageView)

    let seperatorView = UIView()
    seperatorView.backgroundColor = colorSeparator
    mainView.addSubview(seperatorView)

    if(Direction.Left == direction){ // image left
        seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
        self.leftViewMode = .always
        self.leftView = mainView
    } else { // image right
        seperatorView.frame = CGRect(x: 0, y: 0, width: 1, height: 22)
        self.rightViewMode = .always
        self.rightView = mainView
    }

    self.layer.borderColor = colorBorder.cgColor
    self.layer.borderWidth = CGFloat(0.5)
    self.layer.cornerRadius = 5
}
    // add image to textfield
    func withImageBusiness(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        mainView.layer.cornerRadius = 5

        let view = UIView(frame: CGRect(x: 0, y: 6, width: 20, height: 20))
       // view.backgroundColor = .white
     // view.clipsToBounds = true
      //view.layer.cornerRadius = 5
      // view.layer.borderWidth = CGFloat(0.5)
      // view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 1.0, y: 1.0, width: 16.0, height: 16.0)
        view.addSubview(imageView)

        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        mainView.addSubview(seperatorView)

        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 2, y: 0, width: 5, height: 20)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 10, width: 0, height: 16)
            self.rightViewMode = .always
            self.rightView = mainView
        }

       // self.layer.borderColor = colorBorder.cgColor
       // self.layer.borderWidth = CGFloat(0.5)
       // self.layer.cornerRadius = 1
    }

}
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

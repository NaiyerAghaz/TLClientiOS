//
//  MyUtility.swift
//  MyUtility
//
//  Created by Shiv Kumar on 16/11/16.
//  Copyright © 2016 Shiv Kumar. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

//Use this pod for Reachability download => pod 'ReachabilitySwift'

// MARK: INSTALL CocoaPods
/**
     1) create a xcode project
     2) Open terminal
     3) sudo gem install -n /usr/local/bin cocoapods
     4) pod setup
     5) cd "path to your project root directory"
     6) pod init
     7) open -a Xcode Podfile
     8) pod 'Alamofire'  (It’s finally time to add your first dependency using CocoaPods! Copy and paste the following into your pod file, right after target "Alamofire" do:)
     9) pod install
 */

//MARK: CREATE .pem file for push notification
/**
     1) Open KeyChain
     2) Select Your push certificate
     3) Right Click on Certificate & choose export option
     4) Save .p12 file on desktop & run this commands
     5) cd ~/Desktop
     6) openssl pkcs12 -in xyz.p12 -out xyz.pem -nodes -clcerts
 */
/**
     1) Apple  Logo  option + Shift + k
 */
/** Delete provisional profile from mac
     1) ~/Library/MobileDevice/Provisioning/
     2) ~/Library/Developer/Xcode/Archives/
 */



private let UIViewAnimationDuration: TimeInterval = 0.3
private var handle: UInt64 = 0

//MARK: =====: 👉🏾 SCREEN SIZE 👈🏾 :=====
var KeyWindow: UIWindow { return UIApplication.shared.keyWindow!}
var SCREEN_WIDTH:CGFloat { return UIScreen.main.bounds.size.width}
var SCREEN_HEIGHT:CGFloat { return UIScreen.main.bounds.size.height}

//:: Detect Device
public let VENDOR_ID = UIDevice.current.identifierForVendor!.uuidString
private let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
private let IPAD = UIDevice.current.userInterfaceIdiom == .pad

//MARK: =====: 👉🏾 SCREEN RESOLUTION 👈🏾 :=====

let IS_IPHONE_5     = IS_IPHONE && SCREEN_HEIGHT == 568.0
let IS_IPHONE_6_8   = IS_IPHONE && SCREEN_HEIGHT == 667.0
let IS_IPHONE_6P    = IS_IPHONE && SCREEN_HEIGHT == 736.0
let IS_IPHONE_X     = IS_IPHONE && SCREEN_HEIGHT >= 812.0
let IS_IPHONE_X_MAX = IS_IPHONE && SCREEN_HEIGHT == 896.0

let IS_IPAD         = IPAD && SCREEN_HEIGHT >= 1024.0
let IS_IPAD_PRO     = IPAD && SCREEN_HEIGHT == 1366.0

var MainQueue: DispatchQueue {
    return DispatchQueue.main
}
var BackgroudQueue: DispatchQueue {
    return DispatchQueue.global(qos: .default)
}

public var hasSafeArea: Bool {
    guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
        return false
    }
    return true
}
public extension UIDevice {
    static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    static func OS() -> String {
        return UIDevice.current.systemName
    }
    static func osVersion () -> String {
        return UIDevice.current.systemVersion
    }
}
//MARK: =====: 👉🏾 EXTENSIONS 👈🏾 :=====
/**
 1) -This extension is used to get the application BundleVersion, Bundle Name etc
 */
public extension UIApplication {
    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier!
    }
    static var buildVersion: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    static var appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    static var appName: String {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        }
        return ""
    }
    static var bundleName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    static func networkIndicator(_ isShow: Bool = true){
        shared.isNetworkActivityIndicatorVisible = isShow
    }
    static func openSetting() {
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        Log.print("Settings opened: \(success)")
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl as URL)
                }
            }
        }
    }
}
//MARK: Delay
extension TimeInterval {
    static let O3: TimeInterval = 0.3
    static let O4: TimeInterval = 0.4
    static let O5: TimeInterval = 0.5
    static let O6: TimeInterval = 0.6
    static let O7: TimeInterval = 0.7
    static let O8: TimeInterval = 0.8
    static let O9: TimeInterval = 0.9
}

public extension Bundle {
    /**
     - returns: It return a valid json form resource file.
     - parameters: forResource: Resource file name, ofType : FileExtension
     */
    static func json(forResource: String, ofType: String = "json") -> [String: Any] {
        if let path = main.path(forResource: forResource, ofType: ofType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String : AnyObject], jsonResult.count != 0 {
                    return jsonResult
                }
            } catch {
                // handle error
                print("Error to read json from resource")
            }
        }
        return [:]
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

//MARK: GetRange
/**
 Here some operation with Range
 */
extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}

//MARK: =====: UIColor :=====
/**
 * Here some static function for color
 */
extension UIColor{
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor{
        return UIColor(red: r/255.0, green: g/255.0 ,blue: b/255.0 , alpha: alpha)
    }
    open class var randomColor: UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    static func color(_ color: UIColor, withAlpha: CGFloat) -> UIColor{
        return color.withAlphaComponent(withAlpha)
    }
    static func color(hexString: String, _ alpha: CGFloat = 1.0) -> UIColor {
        
        var cString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        let  color = UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                             green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                             blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                             alpha: CGFloat(1.0))
        return color.withAlphaComponent(alpha)
    }
    //MARK - This function Get Color from any string character
    static func color(hash name: String?) -> UIColor {
        
        guard let n = name else{
            return UIColor.darkGray
        }
        var nameValue = 0
        for c in n {
            let characterString = String(c)
            let scalars = characterString.unicodeScalars
            nameValue += Int(scalars[scalars.startIndex].value)
        }
        var r = Float((nameValue * 123) % 51) / 51.0
        var g = Float((nameValue * 321) % 73) / 73.0
        var b = Float((nameValue * 213) % 91) / 91.0
        r = min(max(r, 0.1), 0.84)
        g = min(max(g, 0.1), 0.84)
        b = min(max(b, 0.1), 0.84)
        
        return UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
}

//MARK: ====: Extension Array :====
extension Array where Element: Any {
    mutating func remove<O: Equatable>(object: O) {
        var index: Int?
        for (idx, objectToCompare) in enumerated(){
            if let to = objectToCompare as? O {
                if object == to {
                    index = idx
                }
            }
        }
        if(index != nil) {
            self.remove(at: index!)
        }
    }
    mutating func contains<T: Equatable>(_ element: T) -> Bool {
        return self.contains {
            guard let value = $0 as? T else {
                return false
            }
            return value == element
        }
    }
    mutating func remove(at indexs: [Int]) {
        guard !isEmpty else { return }
        let newIndexs = Set(indexs).sorted(by: >)
        newIndexs.forEach {
            guard $0 < count, $0 >= 0 else { return }
            remove(at: $0)
        }
    }
}

//MARK: ==> Custom Extension for search bar text color <==
extension UISearchBar {
    
    public var searchBar: UISearchBar {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.darkGray
        searchBar.setSearchTextColor(.darkGray, fontSize: 14)
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        cornerRounded(searchBar)
        return searchBar
    }
    private var searchBarTextField: UITextField {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let searchTxtFld = (clrChange.filter { $0 is UITextField }).first as? UITextField else {
            return UITextField()
        }
        return searchTxtFld
    }
    public func setSearchTextColor(_ color: UIColor, fontSize: Int) {
        //searchBarTextField.font = UIFont.regular(size: fontSize)
        searchBarTextField.textColor = color
    }
    public func setSearchPlaceholderColor(_ color: UIColor, fontSize: Int) {
        //searchBarTextField.font = UIFont.regular(size: fontSize)
        searchBarTextField.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    private func cornerRounded(_ searchBar: UISearchBar) {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                // Background color
                backgroundview.backgroundColor = UIColor.lightGray
                // Rounded corner
                backgroundview.layer.cornerRadius = 19
                backgroundview.clipsToBounds = true
            }
        }
    }
}
//MARK: =====: 👉🏾 CLASS METHOD 👈🏾 :=====
open class MyUtility: NSObject {
    

    //MARK: =====: 2 : Current TimeStemp :=====
    static func currentTimeStemp() -> String? {
        let timestampStr = String(format: "%.f", NSDate().timeIntervalSince1970 * 1000)
        return timestampStr
    }
    
    //MARK: =====: 3 : View Shadow :=====
    class func showShadowView<V: UIView>(_ view: V, radius: CGFloat) {
        
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: CGFloat(8), height: CGFloat(15))
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 20.0
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 100.0).cgPath
    }

    //MARK: =====: 4 : TextField Left Padding :=====
    class func setLeftPaddingOn(textFields: [UITextField]) {
        for txtField in textFields{
            txtField.leftView = paddingView(height: txtField.frame.height)
            txtField.leftViewMode = .always
        }
    }
    //MARK: =====: 5 : TextField Right Padding :=====
    class func setRightPaddingOn(textFields: [UITextField]){
        for txtField in textFields{
            txtField.rightView = paddingView(height: txtField.frame.height)
            txtField.rightViewMode = .always
        }
    }
    private static func paddingView(height: CGFloat) -> UIView {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 8, height: height))
        view.backgroundColor = UIColor.clear
        return view
    }
    //MARK: =====: 6 : Phone Call Default :=====
    class func makePhoneCall(_ phoneNumber:String) {
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    //MARK: =====: 8 : Json String -> Json Obj :=====
    class func jsonFrom(_ jsonString: String) -> [String: Any] {
        let data = jsonString.data(using: .utf8)
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
            return jsonData
            
        } catch _ as NSError {
            return [:]
        }
    }
    //MARK: =====: 9 : Dictinory -> Json String :=====
    class func jsonString(from dictionary: [String: Any]) -> String? {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonString
        }
        catch let error as NSError{
            return error.localizedDescription
        }
    }
    //MARK: ====: 10 Create random Number :====
    static func randomString(_ length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    //MARK: =====: 11 : Current Date Time :=====
    class func currentDate(_ format: String) -> String {
        return getDateFromInput(format: format)
    }
    
    //MARK: =====: 12 : Current Year :=====
    static var currentYear: String {
        return getDateFromInput(format: "yyyy")
    }
    
    //MARK: =====: 13 : Current Month :=====
    static var currentMonth: String {
        return getDateFromInput(format: "MMMM")
    }
    
    //MARK: =====: 14 : Current Day :=====
    static var currentDay: String {
        return getDateFromInput(format: "dd")
    }
    
    //MARK: =====: 15 : Current Date Time :=====
    class func getCurrentTime(format: String = "hh:mm") -> String {
        return getDateFromInput(format: format)
    }
    class func formattedDateString(_ dateString: String, inputFormat: String, outFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = inputFormat//"MM/dd/yyyy"
        let showDate = inputFormatter.date(from: dateString)
        inputFormatter.dateFormat = outFormat
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    //MARK: =====: 16: Date Over 18 years :===== returns if a date is over 18 years ago
    class func dateIsOver18Years(_ date: Date)->Bool {
        var comp = (Calendar.current as NSCalendar).components(NSCalendar.Unit.month.union(.day).union(.year), from: Date())
        guard comp.year != nil && comp.day != nil else { return false }
        
        comp.year! -= 18
        comp.day! += 1
        if let date = Calendar.current.date(from: comp) {
            if date.compare(date) != ComparisonResult.orderedAscending {
                return false
            }
        }
        return true
    }
    //MARK: =====: 17 : Line Under TextField :=====
    class func setUnderLine(on TxtFields: [UITextField], color: UIColor, width: CGFloat = 1.5) {
        guard TxtFields.count > 0 else {
            return
        }
        for i in 0..<TxtFields.count {
            
            let txtField = TxtFields[i]
            let border = CALayer()
            let borderWidth: CGFloat = width
            border.borderColor = color.cgColor
            border.frame = CGRect(x: CGFloat(0), y: CGFloat((txtField.frame.size.height) - borderWidth), width: CGFloat(txtField.frame.size.width), height: CGFloat(txtField.frame.size.height))
            border.borderWidth = borderWidth
            txtField.layer.addSublayer(border)
            txtField.layer.masksToBounds = true
        }
    }
    //MARK: =====: 18 : TableView Background Label :=====
    class func setNoDataLabel(_ message: String) -> UILabel {
        let label = UILabel()
        label.text = message
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Palatino-Italic", size: CGFloat(20))
        label.sizeToFit()
        return label
    }
    
    //MARK: =====: 19 : Remove NSNull from Dictionary :=====
    static func removeNSNull(from params: [String: Any]) -> [String: Any] {
        guard params.count > 0 else{
            return [:]
        }
        var mutableParams = params
        let keysWithEmptStringValue = params.filter { $0.1 is NSNull }.map { $0.0 }
        for key in keysWithEmptStringValue {
            mutableParams[key] = ""
        }
        return mutableParams
    }
    
    // MARK: ❉===❉=== 20 SEARCH Object From ARRAY ===❉===❉
    class func searchObject(from array: [Any], searchKey: String) -> [Any] {
        let predicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchKey)
        let filteredArray: [Any] = array.filter { predicate.evaluate(with: $0) }
        return filteredArray
    }
    // MARK: ❉===❉=== 21 Generate Random Number ===❉===❉
    class func randomNumber(length: Int = 100) -> String {
        let randomNum = Int(arc4random_uniform(UInt32(length)))
        return String(randomNum)
    }
    
    // MARK: ❉===❉=== 22 Get Common Element From Array ===❉===❉
    class func commonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> [T.Iterator.Element]
        where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
            var commonElementArray: [T.Iterator.Element] = []
            
            for lhsItem in lhs {
                for rhsItem in rhs {
                    if lhsItem == rhsItem {
                        commonElementArray.append(lhsItem)
                    }
                }
            }
            return commonElementArray
    }
    
    // MARK: ❉===❉=== 23 Get Array From MutableArray ===❉===❉
    class func arrayFrom(mutableArray items: NSMutableArray) -> [Any] {
        let list: [[String:Any]] = items.compactMap { $0 as? [String:Any] }
        return list
    }
    
    static func getTime(from timeInterval: Int) -> String {
        let hours = timeInterval / 3600
        let minutes = timeInterval / 60 % 60
        let seconds = timeInterval % 60
        if hours == 0 {
            return String(format:"%02i:%02i", minutes, seconds)
        }
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    private static func getDateFromInput(format: String) -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let outputString = dateFormatter.string(from: date)
        return outputString
    }
    
    class func makeRoundedCorner(side: UIRectCorner, of view: UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: side, cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        view.layer.backgroundColor = UIColor.green.cgColor
        //Here I'm masking the textView's layer with rectShape layer
        view.layer.mask = rectShape
    }
}

// MARK: ====: Some Important Commands :====
/* Mac OS:
 1) Open a Terminal (via Spotlight: press CMD + SPACE, type terminal and press Enter) and do this command: defaults write com.apple.finder AppleShowAllFiles 1 && killall Finder.
 
 2) Or you could also type cd (the space is important), drag and drop your git repo folder from Finder to the terminal window, press return, then type rm -fr .git, then return again.
 */

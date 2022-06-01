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
import Malert
var myAudio: AVAudioPlayer?
class CEnumClass: NSObject {
    static let share = CEnumClass()
    func convertToJSON(resulTDict:NSDictionary) -> NSDictionary {
        let theJSONData = try? JSONSerialization.data(withJSONObject: resulTDict ,options: JSONSerialization.WritingOptions(rawValue: 0))
        let jsonString = NSString(data: theJSONData!,encoding: String.Encoding.utf8.rawValue)
        let returnDict = self.convertToDictionary(text:jsonString! as String)
        let userData = returnDict as NSDictionary? as? [AnyHashable: Any] ?? [:]
        return userData as NSDictionary
    }
    public func activeLinkCall(activeURL : URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(activeURL, options: [:], completionHandler:nil)
        } else {
            UIApplication.shared.openURL(activeURL)
        }
    }
    public func replaceSpecialCharacters(str: String) -> String {
        let s1 = str.replacingOccurrences(of: "&", with: "&amp")
        return s1
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
    func findTimeDiff(time1Str: String, time2Str: String, isInHours: Bool) -> Int {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm a"
        
        guard let time1 = timeformatter.date(from: time1Str),
              let time2 = timeformatter.date(from: time2Str) else { return 0 }
        
        //You can directly use from here if you have two dates
        
        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        if isInHours {
            return Int(hour)
        }
        else {
            return Int(minute)
        }
        //return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
    }
    func getcurrentdateAndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let startDate =  dateFormatter.string(from: Date())
        return startDate
    }
    func getCurrentDates2() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let startDate =  dateFormatter.string(from: Date())
        return startDate
    }
    
    func getCompleteDateAndTime(dateAndTime: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let startDate =  dateFormatter.date(from: dateAndTime)
        return startDate!
    }
    func getCompleteTimeToDate(time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let startDate =  dateFormatter.date(from: time)
        return startDate!
    }
    func getCompleteNextTimeToString(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let startTime =  dateFormatter.string(from: time)
        return startTime
    }
    func transParentNav(nav: UINavigationController?) {
        nav?.setNavigationBarHidden(false, animated: false)
        nav?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        nav?.navigationBar.shadowImage = UIImage()
        nav?.navigationBar.isTranslucent = true
        nav?.view.backgroundColor = .clear
    }
    func getRoundCTime() -> String{
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:00 a"
        let currentDateTime = Date()
        let cTime = dateFormatterTime.string(from: currentDateTime)
        return cTime
    }
    func getCurrentTimeToDate(time: String) -> Date{
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:mm a"
        //  let currentDateTime = dateFormatterTime.date(from: time)
        return dateFormatterTime.date(from: time)!
    }
    func getCurrentTimeToDatePicker(time: String) -> Date?{
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:mm a"
        //  let currentDateTime = dateFormatterTime.date(from: time)
        return dateFormatterTime.date(from: time)!
    }
    func getDateAndTimeFromString(dateStr: String) -> Date {
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat =  "MM/dd/yyyy"
        //  let currentDateTime = dateFormatterTime.date(from: time)
        return dateFormatterTime.date(from: dateStr)!
    }
    func getTwoHoursDiffer(companyid: String) -> String{
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:00 a"
        let currentDateTime = Date()
        if companyid == "62" {
            return dateFormatterTime.string(from:  currentDateTime.adding(minutes: 60))
        }
        else {
            return dateFormatterTime.string(from:  currentDateTime.adding(minutes: 120))
        }
        
        
    }
    func getAppointmentaddingStatus(msz: String) -> Bool {
        if msz.contains("already exist"){
            return true
        }
        else {
            return false
        }
    }
    func getWeekDaysName(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzzz yyyy"
        return dateFormatter.string(from: date).lowercased()
    }
    func getCurrentDate() -> String{
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        //        let dateFormatterTime = DateFormatter()
        //        dateFormatterTime.dateFormat = "h:00 a"
        //  let currentDateTime = Date()
        let cDate = dateFormatterDate.string(from: Date())
        return cDate
    }
    func getActualDateAndTime() -> String {
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "MM/dd/yyyy h:mm a"
        return dateFormatterr.string(from: Date())
    }
    func getMinuteDiffers(startTime: String, differ:String, companyId: String) -> String{
        //        let dateFormatterDate = DateFormatter()
        //        dateFormatterDate.dateFormat = "MM/dd/yyyy"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "h:mm a"
        let currentDateTime = dateFormatterTime.date(from: startTime)
        switch differ{
        case "10":
            return dateFormatterTime.string(from: (currentDateTime?.adding(minutes: 10))!)
        case "120":
            if companyId == "62"{
                return dateFormatterTime.string(from: (currentDateTime?.adding(minutes: 60))!)
            }
            else {
                return dateFormatterTime.string(from: (currentDateTime?.adding(minutes: 120))!)
            }
        case "60":
            return dateFormatterTime.string(from: (currentDateTime?.adding(minutes: 60))!)
        default:
            return dateFormatterTime.string(from: (currentDateTime?.adding(minutes: 120))!)
        }
        let time = dateFormatterTime.string(from: (currentDateTime?.adding(minutes: 10))!)
        return time
    }
    func playSounds(audioName: String) {
        
        let pathB = Bundle.main.path(forResource: audioName, ofType: "mp3")!
        let url = URL(fileURLWithPath: pathB)
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            myAudio = sound
            sound.play()
        } catch {
            //
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
    
    public func trimHTMLTags() -> String? {
        guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        return attributedString?.string
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
        view.backgroundColor = .black
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
        
    }
    
}
extension UIView
{
    func removeAllSubViews()
    {
       for subView :AnyObject in self.subviews
       {
            subView.removeFromSuperview()
       }
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

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
}
extension String {
    mutating func add(prefix: String) {
        self = prefix + self
    }
}
extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y:self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black//black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        //titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor ).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: self.bounds.size.height - 120).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
public func print(_ object: Any) {
#if DEBUG
    Swift.print(object)
#endif
}

//MARK: PROTOCOL

protocol delegateScanner {
    func scannerMethod()
}
func getHexaString(status: String) -> String? {
    switch status {
    case "booked":
        return "#31FF98"
    case "notbooked":
        return "#f04a65"
    case "cancelled":
        return "#827c7c"
    case "botched":
        return "#827c7c"
    case "latecancelled":
        return "#827c7c"
    case "invoiceprocessing":
        return "#2AFFFF"
    case "assigned":
        return "#099c2f"
    case "inprocess":
        return "#ffa500"
    case "invoiced":
        return "#099c2f"
    case "notbooked1":
        return "#FF2525"
    case "confirmed":
        return "#32ad52"
    case "pending":
        return "#B3E9F1"
    case "finished":
        return "#41a9c2"
    case "inpocessclr":
        return "#ffa500"
    case "latecusomerreq":
        return "#acea31"
    case "couldn`t book":
        return "#827c7c"
    default:
        return "#827c7c"
    }
}


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
func getAppointmentStatus(appointmentType: String, handler:@escaping(String?,String?,String?) -> ()) {
    switch appointmentType {
    case "Booked":
        
        handler("Booked Appointment","Booked","#31FF98")
    case "Not Booked":
        
        handler("Not Booked Appointment","Not Booked","#f04a65")
    case "InProcess":
        
        handler("Appointment In-Process","InProcess","#ffa500")
    case "Pending":
        
        handler("Appointment","Authorization Pending","#B3E9F1")
    case "Couldn`t Book":
        
        handler("Appointment Cancelled","Cancelled","#827c7c")
    case "Cancelled":
        
        handler("Appointment Cancelled","Cancelled","#827c7c")
    case "Botched":
        
        handler("Appointment Cancelled","Cancelled","#827c7c")
    case "Late Cancelled":
        
        handler("Appointment Late Cancelled","Late Cancelled","#827c7c")
    case "Invoice Processing":
        
        handler("Appointment","Invoice Processing","#2AFFFF")
    case "Invoiced":
        
        handler("Appointment","Invoiced", "#099c2f")
    case "confirmed":
        
        handler("Request Confirmed","Confirmed","#32ad52")
        
    default:
        
        handler(appointmentType,appointmentType,"#f04a65")
    }
}


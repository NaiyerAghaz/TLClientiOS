//
//  Strin+Ext.swift
//  VOD
//
//  Created by JMD on 13/04/2018.
//

import Foundation
import UIKit

/**
 * Here is multiple operation with String
 */
extension String {
    
//    var isValidEmail: Bool{
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        print(emailTest.evaluate(with: self))
//        return emailTest.evaluate(with: self)
//    }
    var isPasswordValid: Bool{
        /**
         - parameters:
         1 - Password length is 6.
         2 - One Alphabet in Password.
         3 - One Special Character in Password.
         4 - One Number in Password.
         eg. abc@123
         */
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: self)
    }
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
        //USE: print("testing string"[9])
    }
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
        //USE: print("testing string"[1..<"testing string".length-1])
    }
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start...end])
        //USE: print("testing string"[0...9])
    }
    /// Swift: Check if string contains one or more numbers.
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    var length: Int{
        return (self.utf16.count)
    }
    var floatValue: Float {
        return Float(self) ?? 0
    }
    func replace(aString: String, with: String) -> String {
        guard self.length > 0 else {
            return ""
        }
        return self.replacingOccurrences(of: aString, with: with)
    }
    
    func contains(aString string: String) -> Bool{
        guard self.lowercased().range(of: string.lowercased()) != nil else {
            return false
        }
        return true
    }
    
    var lastChar: Character {
        let lastChar = self[self.index(before: self.endIndex)]
        return lastChar
    }
    
    var isValidMobileNo: Bool {
        let phoneRegEx = "^[0-9-+]{9,15}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    // Returns if a string is composed just of numbers or '-' symbol
    var isNumberString: Bool {
        let charSet = NSMutableCharacterSet(charactersIn: "-")
        charSet.formUnion(with: CharacterSet.decimalDigits)
        return  rangeOfCharacter(from: charSet.inverted) == nil
    }
    
    var isInputNumber: Bool {
        //Here change this characters based on your requirement
        let allowedCharacters = CharacterSet(charactersIn:"0123456789")
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func trimWhiteSpace() -> String {
        return self.replace(aString: " ", with: "")
    }
    
    func strikeText(color: UIColor = UIColor.gray) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
    func createAttributed(_ targetString: String, font: UIFont, fontSize: CGFloat = 14,  withColor: UIColor) -> NSMutableAttributedString{
        let longestWordRange = (self as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font : font])
        attributedString.setAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : withColor], range: longestWordRange)
        
        return attributedString
    }
    
    func attributedStringColor(_ color: UIColor) -> NSMutableAttributedString {
        let attribute = [NSAttributedString.Key.foregroundColor: color]
        let attrString = NSMutableAttributedString(string: self, attributes:attribute)
        return attrString
    }
    
    public func backgroundColor(_ color: UIColor) -> NSMutableAttributedString {
        let attribute = [NSAttributedString.Key.backgroundColor: color]
        let attrString = NSMutableAttributedString(string: self, attributes:attribute)
        return attrString
    }
    
    public func underLine(_ color: UIColor) -> NSMutableAttributedString {
        guard self.length != 0 else {
            return NSMutableAttributedString()
        }
        let attribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attrString = NSMutableAttributedString(string: self, attributes:attribute)
        return attrString
    }
    
    public func shadowColor(_ color: UIColor) -> NSMutableAttributedString{
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowColor = color
        
        let attribute = [NSAttributedString.Key.shadow: shadow]
        let attrString = NSMutableAttributedString(string: self, attributes:attribute)
        return attrString
    }
    
    public var base64Encoded: String {
        guard let data = self.data(using: .utf8) else { return "" }
        return data.base64EncodedString()
    }
    
    public var base64Decoded: String {
        guard let data = Data(base64Encoded: self) else { return "" }
        return String(data: data, encoding: .utf8)!
    }
    public var url: URL? {
        guard !self.isEmpty else { return nil }
        return URL(string: self)
    }
    
    func superscriptStyle(location: Int, length: Int, fontName: String)-> NSAttributedString{
        let fontSize: CGFloat = 15
        let font:UIFont? = UIFont(name: fontName, size:fontSize)//Helvetica
        let fontSuper:UIFont? = UIFont(name: fontName, size:fontSize * 0.75)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font:font!])
        attString.setAttributes([NSAttributedString.Key.font:fontSuper!,NSAttributedString.Key.baselineOffset:10], range: NSRange(location: location,length: length))
        return attString
    }
    
    //MARK: ====: Search String Highlight here :====
    func highlight(from string: String, withColor color: UIColor) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string)
        var avoidTranslationList = [Any]()
        var searchRange = NSRange(location: 0, length: (string.count))
        var foundRange: NSRange
        while searchRange.location < (string.count) {
            searchRange.length = (string.count) - searchRange.location
            foundRange = (string as NSString).range(of: self, options: .caseInsensitive, range: searchRange)
            if foundRange.location == NSNotFound {
                break
            }
            searchRange.location = foundRange.location + foundRange.length
            avoidTranslationList.append(NSStringFromRange(foundRange))
        }
        
        let arrayStr: [Any] = avoidTranslationList
        for i in 0..<arrayStr.count {
            let range: NSRange = NSRangeFromString(arrayStr[i] as! String)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica Bold", size: CGFloat(15.0))!, range: range)
        }
        return attributedString
    }
    
    //MARK: Convert String to bool
    var isTrue: Bool {
        /// - parameters: 1 for true
        /// - parameters: 0 for false
        guard self == "True" || self == "true" || self == "TRUE" || self == "1.0" || self == "1" || self == "yes" || self == "Yes" || self == "YES" else {
            return false
        }
        return true
    }
    /**
     * Get Hight from string according to uiview width
     */
    func heightWithView(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    /**
     * Check String contains number and Alphabets only
     */
    var isContainAlphaNumerics: Bool {
        let characterSet = CharacterSet.alphanumerics
        if self.rangeOfCharacter(from: characterSet.inverted) != nil { return false }
        return true
    }
    /**
     sCheck name text field text is contains alphabets & space only.
     */
    var isContainsAlphabet: Bool {
        if self == " " {
            return true
        }
        else{
            let characterSet = CharacterSet.letters
            if self.rangeOfCharacter(from: characterSet.inverted) != nil { return false }
        }
        return true
    }
    /**
     *  Convert number into Price format. eg. 1000000 -> 1,000,000
     */
    func convertNumberToPriceFormat() -> String {
        guard self.length != 0 else {
            return ""
        }
        let number = Float(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let stringFormat = numberFormatter.string(from: NSNumber(value: number!))
        //output: 1,000,000
        return stringFormat!
    }
    public static var randomNumber: String {
        return String(format: "%@", (Int(arc4random_uniform(UInt32(100)))))
    }
    // MARK: - ❉===❉=== CHNAGE CURRENT DATE FORMAT ===❉===❉
    func convertDateInput(format dFormat: String, output dFormat2: String) -> String? {
        guard self.length > 0 else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormat
        let date: Date? = dateFormatter.date(from: self)
        dateFormatter.dateFormat = dFormat2
        let outputTimeString: String = dateFormatter.string(from: date!)
        return outputTimeString
    }
    public static func loremIpsum(ofLength length: Int = 120) -> String {
        guard length > 0 else { return "" }
        
        // https://www.lipsum.com/
        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex..<loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    var asDict: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
//11111111 to 1111-1111-111
// let str = customStringFormatting(of: 4)
//func customStringFormatting(of str: String) -> String {
//    return str.chunk(n: 4)
//        .map{ String($0) }.joined(separator: "-")
//}
//extension String {
//    func chunkFormatted(withChunkSize chunkSize: Int = 4,
//        withSeparator separator: Character = "-") -> String {
//        return characters.filter { $0 != separator }.chunk(n: chunkSize)
//            .map{ String($0) }.joined(separator: String(separator))
//    }
//}
extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = " ") -> String {
        return self.filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
}

extension Collection {
    public func chunk(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

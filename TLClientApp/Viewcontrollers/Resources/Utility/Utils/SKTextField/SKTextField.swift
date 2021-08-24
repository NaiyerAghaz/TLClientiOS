//
//  SKTextField.swift
//  Zuber
//
//  Created by JMD on 29/04/19.
//  Copyright © 2019 Shiva Kr Group. All rights reserved.
//

import UIKit

enum ValueType: Int {
    case none
    case onlyLetters
    case onlyNumbers
    case phoneNumber   // Allowed "+0123456789"
    case alphaNumeric
    case fullName       // Allowed letters and space
}

class SKTextField: UITextField {
    
    @IBInspectable var maxLength: Int = 0 // Max character length
    var valueType: ValueType = ValueType.none // Allowed characters
    private var activityIndicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        } else {
            // Fallback on earlier versions
            activityIndicator = UIActivityIndicatorView(style: .white)
        }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        self.insertSubview(activityIndicator, at: 0)
        activityIndicator.frame = self.bounds
    }
    
    func startAnimating () {
        MainQueue.async {
            self.activityIndicator.startAnimating()
        }
    }
    func stopAnimating () {
        MainQueue.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func verifyFields(shouldChangeCharactersIn range: NSRange, replacementString string: String, vType: ValueType = .none) -> Bool {
        
        switch vType {
        case .none:
            break // Do nothing
            
        case .onlyLetters:
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
            
        case .onlyNumbers:
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
            
        case .phoneNumber:
            let phoneNumberSet = CharacterSet(charactersIn: "+0123456789")
            if string.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }
            
        case .alphaNumeric:
            let alphaNumericSet = CharacterSet.alphanumerics
            if string.rangeOfCharacter(from: alphaNumericSet.inverted) != nil {
                return false
            }
            
        case .fullName:
            var characterSet = CharacterSet.letters
            print(characterSet)
            characterSet = characterSet.union(CharacterSet(charactersIn: " "))
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }
        if let text = self.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if maxLength > 0, maxLength < finalText.utf8.count {
                return false
            }
        }
        return true
    }
}
//MARK: =====: UITextField :=====
/**
 * Here some operation with UITextField
 */
extension UITextField {
    
    enum PaddingSide: Int {
        case left = 0
        case right
    }
    
    @IBInspectable
    var placeHolder: UIColor {
        get { return UIColor.white.withAlphaComponent(0.5) }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: newValue])
        }
    }
    @IBInspectable
    fileprivate var leftPadding: CGFloat {
        get { return 0 }
        set {
            let padView = UIView()
            padView.frame = CGRect(x: 0, y: 0, width: newValue, height: frame.height)
            padView.backgroundColor = UIColor.clear
            leftView = padView
            leftViewMode = UITextField.ViewMode.always
        }
    }
    @IBInspectable
    fileprivate var rightPadding: CGFloat {
        get { return 0 }
        set {
            let padView = UIView()
            padView.frame = CGRect(x: 0, y: 0, width: newValue, height: frame.height)
            padView.backgroundColor = UIColor.clear
            rightView = padView
            rightViewMode = UITextField.ViewMode.always
        }
    }
    func blankPadding(edge: PaddingSide, width: CGFloat) {
        let padView = UIView()
        padView.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        padView.backgroundColor = UIColor.clear
        if edge == .left {
            leftView = padView
            leftViewMode = UITextField.ViewMode.always
        }
        else{
            rightView = padView
            rightViewMode = .always
        }
    }
    
    func leftPadding(_ image: UIImage, width: CGFloat) {
        leftView = paddingViewWithImage(image, width: width)
        leftViewMode = .always
    }
    
    func rightPadding(_ image: UIImage, width: CGFloat) {
        rightView = paddingViewWithImage(image, width: width)
        rightViewMode = .always
    }
    private func paddingViewWithImage(_ image: UIImage, width: CGFloat) -> UIView {
        let h: CGFloat = self.frame.size.height
        let w: CGFloat = width
        let pdView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        let imageView = UIImageView(frame: CGRect(x: 2, y: 0, width: (pdView.width - 4), height: pdView.height))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.clipsToBounds = true
        pdView.addSubview(imageView)
        return pdView
    }
    
    // MARK: - ❉===❉=== CATransition Animation ===❉===❉
    func transitions(delay: CGFloat) {
        let transition = CATransition()
        transition.duration = CFTimeInterval(delay)
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.layer.add(transition, forKey: "")
    }
    
    var shakeAnimation: Void {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isAdditive = true
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 64, y: 64, width: 160, height: 160)
        layer.colors = [UIColor.red.cgColor, UIColor.red.cgColor]
        self.layer.addSublayer(layer)
        self.layer.add(animation, forKey: "shake")
    }
    /**
     * Set Toolbar on keyboard.
     * On Select "doneAccessory" You can set "On" for show toolbar on keyboard into storyboard / xib.
     */
    @IBInspectable var doneAccessory: Bool{
        get { return self.doneAccessory }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.barTintColor = UIColor.white
        doneToolbar.tintColor = .black
        doneToolbar.isTranslucent = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    func setInputViewDatePicker(target: Any, selector: Selector, pickerMode: UIDatePicker.Mode = .date) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = pickerMode //2
        if pickerMode == .time {
            datePicker.minuteInterval = 5
        } else {
//            datePicker.minimumDate = Date()
            datePicker.minimumDate = Date()
        }
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels //UIDatePicker.Style.wheels
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        toolBar.tintColor = .black
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}

//HOW TO USE ToolBar
/*override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.myTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
}

//2
@objc func tapDone() {
    if let datePicker = self.myTextField.inputView as? UIDatePicker { // 2-1
        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateStyle = .medium // 2-3
        self.myTextField.text = dateformatter.string(from: datePicker.date) //2-4
    }
    self.myTextField.resignFirstResponder() // 2-5
}
*/
/* Delegate Used
 self.txtField.valueType = .phoneNumber

 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 
 // Verify the conditions of UITextField
 return self.txtField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
 }
 */

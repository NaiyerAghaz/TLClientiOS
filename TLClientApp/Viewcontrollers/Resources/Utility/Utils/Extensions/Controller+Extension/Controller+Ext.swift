//
//  Controller+Ext.swift
//  VOD
//
//  Created by Shiva Kr. on 23/08/21.
//

import Foundation
import UIKit
public enum Storyboard: String {
    case Home = "Home"
}
/// - Returns: A view controller from storyboard
/// - requires: The view controller storyboard identifire should be same as class name.
protocol StoryboardDesignable: AnyObject {}
extension StoryboardDesignable where Self: UIViewController {
    static func instantiate(from storyboard: Storyboard = .Home) -> Self {
        let dynamicMetatype = Self.self
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "\(dynamicMetatype)") as? Self else {
            fatalError("Couldn’t instantiate view controller with identifier \(dynamicMetatype)")
        }
        return viewController
    }
}
/**
  - requires: -> You should remember that class name and storyboard identifire should be same.
  - UseCase: let vc = YourVC.intantiate()
 */
/**
 * This extension is used to get the viewcontroller from main stroyboard.
 * Push and Pop view controller.
 */
extension UIViewController: StoryboardDesignable {
    enum ActionType {
        case cancel, ok
    }
    public func PUSH(_ viewController: UIViewController, _ animated: Bool = true) {
        MainQueue.async {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    public func POP(_ animated: Bool = true) {
        MainQueue.async {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    public func PRESENT(_ viewController: UIViewController, _ animated: Bool = true) {
        //MARK: Call this into main thread
        MainQueue.async {
            self.present(viewController, animated: animated, completion: nil)
        }
    }
    public func DISMISS(_ animated: Bool = true) {
        MainQueue.async {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    public func POP_ANIMATION(){
        MainQueue.async {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            transition.type = CATransitionType.fade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            _ = self.navigationController?.popToRootViewController(animated: false)
        }
    }
    public func DISMISS_ROOT(_ animated: Bool = true){
        view.window!.rootViewController?.dismiss(animated: animated, completion: nil)
    }
    public func Notification_Recieved(name: NSNotification.Name, selector: Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    public func Notification_Post(name: Notification.Name, userInfo: [String : Any]? = nil){
        NotificationCenter.default.post(name: name, object: self, userInfo: userInfo)
    }
    public func Notification_Remove(name: Notification.Name){
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    public func centerComponent(_ component: AnyObject) {
        let customView = component as! UIView
        customView.center.x = view.frame.midX
        customView.center.y = view.frame.midY
    }
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: ❉===❉=== Alert view with Single Button ===❉===❉
    func showPopup(withTitle: String = "", message: String, okClicked: @escaping () -> ()){
        let alert  = UIAlertController.init(title: withTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default) { (action) in
            okClicked()
        }
        alert.addAction(action)
        MainQueue.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Alert with two Buttons
    func showPopup(withTitle: String = "", message: String, actions: @escaping(ActionType) -> ()){
        let alert  = UIAlertController.init(title: withTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Yes", style: .default) { (action) in
            actions(.ok)
        }
        let cancelAction = UIAlertAction.init(title: "No", style: .cancel) { (action) in
            actions(.cancel)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        MainQueue.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Alert with two Buttons
    func showAlert(message: String, actions: @escaping(ActionType) -> ()){
        let alert  = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            actions(.ok)
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            actions(.cancel)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        MainQueue.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

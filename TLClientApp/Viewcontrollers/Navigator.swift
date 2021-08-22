//
//  Navigator.swift
//  TLClientApp
//
//  Created by Naiyer on 8/7/21.
//

import Foundation
import UIKit


class Navigator {
    lazy public var loginStoryBoard = UIStoryboard(name: Storyboard_name.login, bundle: nil)
    lazy public var homeStoryBoard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
    enum Segue {
        case login
        case forgetPassword
        case home(data:DetailsModal?)
//        case onDemandVRI
//        case onDemandOPI
//        case sceduledVRI
//        case scheduledOPI
//        case vRIOPI
    }
    
    func show(segue : Segue,sender: UIViewController) {
        switch segue {
        case .login:
        let vc = LoginVC.createWith(navigator: self, storyboard: loginStoryBoard)
        show(target: vc, sender: sender)
        case .forgetPassword:
            let vc = ForgotPasswordVC.createWith(navigator: self, storyboard: loginStoryBoard)
            show(target: vc, sender: sender)
        case .home(let userVM):
            
            let vc = HomeViewController.createWith(navigator: self, storyboard: homeStoryBoard,userModel: userVM!)
            show(target: vc, sender: sender)
//        case .onDemandVRI:
//        let vc = OnDemandVRIViewController.createWith(navigator: self, storyboard: homeStoryBoard)
//        show(target: vc, sender: sender)
//        case .onDemandOPI:
//        let vc = OnDemandOPIViewController.createWith(navigator: self, storyboard: homeStoryBoard)
//        show(target: vc, sender: sender)
//        case .sceduledVRI:
//        let vc = ScheduledVRIVIewController.createWith(navigator: self, storyboard: homeStoryBoard)
//        show(target: vc, sender: sender)
//        case .vRIOPI:
//        let vc = VRIOPIViewController.createWith(navigator: self, storyboard: homeStoryBoard)
//        show(target: vc, sender: sender)
        default:
            print("nothing")
        }
    }
    // Controller call
    
    private func show(target: UIViewController, sender: UIViewController, modal: Bool = false, animated: Bool = true, presentFullScreen: Bool = false, overCurrentContext: Bool = false) {
        
        DispatchQueue.main.async {
            
            if (modal) {
                
                if presentFullScreen {
                    let navigationController = UINavigationController(rootViewController: target)
                    navigationController.modalPresentationStyle = .fullScreen
                    sender.present(navigationController, animated: animated, completion: nil)
                    return
                }
                
                if overCurrentContext {
                    let navigationController = UINavigationController(rootViewController: target)
                    navigationController.modalPresentationStyle = .overCurrentContext
                    sender.present(navigationController, animated: animated, completion: nil)
                    return
                }
                
                sender.present(target, animated: animated, completion: nil)
                return
            }
            
            if let nav = sender as? UINavigationController {
                //push root controller on navigation stack
                let existingControllers = nav.viewControllers.filter{
                    
                    let firstClass = String(describing: type(of: $0))
                    let secondClass = String(describing: type(of: target))
                    
                    return firstClass == secondClass
                }
                
                if let same = existingControllers.first {
                    nav.popToViewController(same, animated: animated)
                } else {
                    // Enable/Disable swipe to left view controller
                    nav.navigationController?.enableSwipeLeftToPopGesture(enable: true)
                    nav.pushViewController(target, animated: animated)
                }
                
                return
            }
            
            if let nav = sender.navigationController {
                let existingControllers = nav.viewControllers.filter{
                    
                    let firstClass = String(describing: type(of: $0))
                    let secondClass = String(describing: type(of: target))
                    
                    return firstClass == secondClass
                }
                
                if let same = existingControllers.first {
                    nav.popToViewController(same, animated: animated)
                } else {
                    nav.navigationController?.enableSwipeLeftToPopGesture(enable: true)
                    nav.pushViewController(target, animated: animated)
                }
            } else {
                //present modally
                if presentFullScreen {
                    let navigationController = UINavigationController(rootViewController: target)
                    navigationController.modalPresentationStyle = .fullScreen
                    sender.present(navigationController, animated: animated, completion: nil)
                    return
                }
                sender.present(target, animated: animated, completion: nil)
            }
        }
    }
}

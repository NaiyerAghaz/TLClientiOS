//
//  TabViewController.swift
//  TLClientApp
//
//  Created by Mac on 13/10/21.
//

import UIKit

class TabViewController: UIViewController {
    
    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    let arrIconsBlack = ["calendar" ,"handshake" , "google-docs", "worldwide"] // place non selected image name in array
    let arrIconsGold = ["calendar" ,"handshake" , "google-docs", "worldwide"] // place selected image name in array
    var viewControllers = [UIViewController]()
    @IBOutlet var buttons:[UIButton]!
    @IBOutlet var images:[UIImageView]!
    @IBOutlet var tabView:UIView!
   // @IBOutlet var labels:[UILabel]!
    var footerHeight: CGFloat = 50
    
    static let firstVC = UIStoryboard(name: Storyboard_name.home, bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
    static let secondVC = UIStoryboard(name: Storyboard_name.home, bundle: nil).instantiateViewController(withIdentifier: "OnsiteInterpretationHistoryVC")
    static let thirdVC = UIStoryboard(name: Storyboard_name.home, bundle: nil).instantiateViewController(withIdentifier: "DocumentTransaltionHistoryVC")
    static let fourthVC = UIStoryboard(name: Storyboard_name.home, bundle: nil).instantiateViewController(withIdentifier: "TelephoneConferenceServiceHistoryVC")
    //static let fifthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tab view Controller ")
        self.tabView.layer.shadowColor = UIColor.gray.cgColor
        tabView.layer.masksToBounds=true
        self.tabView.layer.shadowOpacity = 0.5
        self.tabView.layer.cornerRadius = self.tabView.frame.height/2
//        self.tabView.layer.masksToBounds = true
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
       // blurEffectView.layer.shadowColor = UIColor.lightGray.cgColor
      //  blurEffectView.layer.shadowOpacity = 0.5
       // blurEffectView.layer.masksToBounds = true
        
//       blurEffectView.layer.cornerRadius = blurEffectView.frame.height/2
//        self.tabView.bounds = blurEffectView.frame
        self.tabView.backgroundColor = .white
//        self.tabView.addSubview(blurEffectView)
//        self.tabView.sendSubviewToBack(blurEffectView)
        tabView.layer.borderWidth = 0.0
        tabView.layer.shadowRadius = 4.0
        tabView.clipsToBounds=false
        
        tabView.layer.borderColor = UIColor.white.cgColor
        tabView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
       
        
        
        
        
        viewControllers.append(TabViewController.firstVC)
        viewControllers.append(TabViewController.secondVC)
        viewControllers.append(TabViewController.thirdVC)
        viewControllers.append(TabViewController.fourthVC)
        //viewControllers.append(TabViewController.fifthVC)
    //    labels[selectedIndex].textColor = UIColor(hexString: "#5F1180")
        buttons[selectedIndex].isSelected = true
        images[selectedIndex].image = UIImage(named: self.arrIconsGold[selectedIndex])
        tabChanged(sender: buttons[selectedIndex])
        
    }
     
}

extension TabViewController {
    
    @IBAction func tabChanged(sender:UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
       // labels[previousIndex].textColor = UIColor(hexString: "#B1B1B1")
        print("tab changed previousIndex " , previousIndex)
        print("tab changed selectedIndex " , selectedIndex)
        buttons[previousIndex].isSelected = false
        images[previousIndex].image = UIImage(named: self.arrIconsBlack[previousIndex])
        let previousVC = viewControllers[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
       // labels[selectedIndex].textColor = UIColor(hexString: "#5F1180")
        print("selectedIndex " , selectedIndex)
        print("previousIndex " , previousIndex)
        images[selectedIndex].image = UIImage(named: self.arrIconsGold[selectedIndex])
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        self.view.bringSubviewToFront(tabView)
    }
    
    func hideHeader() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.tabView.frame = CGRect(x: self.tabView.frame.origin.x, y: (self.view.frame.height + self.view.safeAreaInsets.bottom + 16), width: self.tabView.frame.width, height: self.footerHeight)
        })
    }
    
    func showHeader() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.tabView.frame = CGRect(x: self.tabView.frame.origin.x, y: self.view.frame.height - (self.footerHeight + self.view.safeAreaInsets.bottom + 16), width: self.tabView.frame.width, height: self.footerHeight)
        })
    }
}

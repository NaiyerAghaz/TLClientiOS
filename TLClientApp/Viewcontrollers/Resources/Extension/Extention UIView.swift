//
//  Extention UIView.swift
//  TLClientApp
//
//  Created by Mac on 13/10/21.
//

import Foundation
import UIKit

extension UIView {
    func addShadowGrey(){
        self.layer.borderWidth = 0.0
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.4
        self.layer.cornerRadius = 10
    }
    // MARK: visibility methods
       public enum Visibility : Int {
           case visible = 0
           case invisible = 1
           case gone = 2
           case goneY = 3
           case goneX = 4
       }

       public var visibility: Visibility {
           set {
               switch newValue {
                   case .visible:
                       isHidden = false
                       getConstraintY(false)?.isActive = false
                       getConstraintX(false)?.isActive = false
                   case .invisible:
                       isHidden = true
                       getConstraintY(false)?.isActive = false
                       getConstraintX(false)?.isActive = false
                   case .gone:
                       isHidden = true
                       getConstraintY(true)?.isActive = true
                       getConstraintX(true)?.isActive = true
                   case .goneY:
                       isHidden = true
                       getConstraintY(true)?.isActive = true
                       getConstraintX(false)?.isActive = false
                   case .goneX:
                       isHidden = true
                       getConstraintY(false)?.isActive = false
                       getConstraintX(true)?.isActive = true
               }
           }
           get {
               if isHidden == false {
                   return .visible
               }
               if getConstraintY(false)?.isActive == true && getConstraintX(false)?.isActive == true {
                   return .gone
               }
               if getConstraintY(false)?.isActive == true {
                   return .goneY
               }
               if getConstraintX(false)?.isActive == true {
                   return .goneX
               }
               return .invisible
           }
       }

       fileprivate func getConstraintY(_ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
           return getConstraint(.height, createIfNotExists)
       }

       fileprivate func getConstraintX(_ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
           return getConstraint(.width, createIfNotExists)
       }

       fileprivate func getConstraint(_ attribute: NSLayoutConstraint.Attribute, _ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
           var result: NSLayoutConstraint? = nil
           for constraint in constraints {
               if constraint.firstAttribute == attribute && constraint.constant == 0 && constraint.relation == .equal {
                   result = constraint
                   break
               }
           }
           if result == nil && createIfNotExists {
               // create and add the constraint
               result = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
               addConstraint(result!)
           }
           return result
       }
       
}

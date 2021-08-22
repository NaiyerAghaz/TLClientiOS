//
//  Storyboard+.swift
//  TLClientApp
//
//  Created by Naiyer on 8/7/21.
//

import Foundation
#if os(iOS)
    import UIKit
    
    extension UIStoryboard {
        func instantiateViewController<T>(ofType type: T.Type) -> T {
            return instantiateViewController(withIdentifier: String(describing: type)) as! T
        }
    }
#elseif os(OSX)
    import Cocoa
    
    extension NSStoryboard {
        func instantiateViewController<T>(ofType type: T.Type) -> T {
            return instantiateController(withIdentifier: String(describing: type)) as! T
        }
    }
#endif
extension UINavigationController {
    
    /// Use this method to allow swipe left to pop back on any UINavigationController.
       ///
       /// - Parameters:
       ///   - enable: flag to enable or disable swipe gesture
       ///
       public func enableSwipeLeftToPopGesture(enable : Bool? = true) -> Void {
           
           self.interactivePopGestureRecognizer?.delegate = nil
           self.interactivePopGestureRecognizer?.isEnabled = enable!
       }
}

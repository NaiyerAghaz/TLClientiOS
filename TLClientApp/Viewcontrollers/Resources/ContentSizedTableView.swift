//
//  ContentSizedTableView.swift
//  TLClientApp
//
//  Created by SMIT 005 on 02/12/21.
//

import Foundation
import UIKit
class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

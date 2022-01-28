//
//  AutosizedCollectionView.swift
//  TLClientApp
//
//  Created by SMIT 005 on 02/12/21.
//

import Foundation
import UIKit
class AutosizedCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerObserver()
    }
    
    deinit {
        unregisterObserver()
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    private func registerObserver() {
        addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [], context: nil)
    }
    
    private func unregisterObserver() {
        removeObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize))
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        if keyPath == #keyPath(UICollectionView.contentSize) {
            invalidateIntrinsicContentSize()
        }
    }
}

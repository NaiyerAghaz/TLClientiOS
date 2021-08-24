//
//  CollectioView+Extension.swift
//  Mobitel Karaoke
//
//  Created by Shiv Kumar on 01/10/18.
//  Copyright © 2018 Shiv Kumar. All rights reserved.
//

import UIKit
import Foundation
import UIKit

///- Remarks: This is the collectionview Common function
extension UICollectionView {
    
    public func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    public func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
    //MARK: ==> Refresh CollectionView Perticular cell data <==
    public func refreshCell(at row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        DispatchQueue.main.async {
            self.reloadItems(at: [indexPath])
        }
    }
    public func reloadData(_ completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    public func bottomEdgeInset(_ edgeInset: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: edgeInset, right: 0)
        }
    }
    public func scrollToPosition(at: UICollectionView.ScrollPosition, index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        scrollToItem(at: indexPath, at: .left, animated: true)
    }
    public func reloadSection(index: Int = 0) {
        DispatchQueue.main.async {
            let indexSet = IndexSet(integer: index)
            self.reloadSections(indexSet)
        }
    }
}
///- Remarks: 
//MARK: ====: Extension UITableView :====
extension UITableViewController {
    public func adjustContentInset() {
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
extension UITableView {
    
    public func addBackgroundImage(_ image: UIImage, frame: CGRect){
        let imgBgView = UIView(frame: self.bounds)
        imgBgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        let imgBg = UIImageView(frame: frame)
        imgBg.image = image
        imgBg.contentMode = .scaleAspectFill
        imgBg.clipsToBounds = true
        imgBgView.addSubview(imgBg)
        imgBg.center = self.center
        imgBg.center.y = imgBg.center.y - 50
        self.backgroundView = imgBgView
    }
    public func addNoDataFound(message msg: String){
        let lbl = MyUtility.setNoDataLabel(msg)
        lbl.frame = self.frame
        self.backgroundView = lbl
    }
    public func addBackgroundView(_ view : UIView){
        view.frame = self.bounds
        self.backgroundView = view
    }
    public func clearBackground(){
        self.backgroundView = nil
    }
    public func reloadData(_ completion: (@escaping () -> Void)) {
        MainQueue.async {
            self.reloadData()
        }
    }
    public func removeFooterView() {
        tableFooterView = UIView(frame: CGRect.zero)
    }
    public func removeHeaderView() {
        tableHeaderView = nil
    }
    /// - Parameter animated: set true to animate scroll (default is true).
    public func scrollToBottom(animated: Bool = false) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// Swift: Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    public func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    //MARK: ==> Section is static but indexpath is dynamic then reload section cell data ==>
    public func reloadRow(at index: Int, section: Int = 0) {
        MainQueue.async {
            let indexPath = IndexPath(item: index, section: section)
            self.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    func isCellVisible(indexPath: IndexPath) -> Bool {
       guard let indexes = self.indexPathsForVisibleRows else {
           return false
       }
       return indexes.contains(indexPath)
    }
    ///Swift: Dequeue reusable UITableViewCell using class name for indexPath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            return UITableViewCell() as? T
            //            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        return cell
    }
    ///Swift: Register UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    public func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    ///Swift: Register UITableViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    public func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
    /// - Parameters:
    ///   - indexPath: Target IndexPath to scroll to
    ///   - scrollPosition: Scroll position
    ///   - animated: Whether to animate or not
    public func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    public func scrollToSection(_ section: Int) {
        let indexPath = IndexPath(row: 0, section: section)
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

//MARK: UITableViewCell
extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

//MARK: ==> Refreshing Controller <==
extension UIRefreshControl {
    static func addRefreshing(message: String = "Loading...", tintColor: UIColor = .black) -> UIRefreshControl {
        let refershCtrl = UIRefreshControl()
        refershCtrl.backgroundColor = UIColor.clear
        let attributes = [NSAttributedString.Key.foregroundColor: tintColor]
        refershCtrl.attributedTitle = NSAttributedString(string: message, attributes: attributes)
        refershCtrl.tintColor = tintColor
        return refershCtrl
    }
    public func startRefreshing() {
        MainQueue.async {
            self.beginRefreshing()
        }
    }
    public func stopRefreshing() {
        MainQueue.async {
            guard self.isRefreshing else { return }
            self.endRefreshing()
        }
    }
}

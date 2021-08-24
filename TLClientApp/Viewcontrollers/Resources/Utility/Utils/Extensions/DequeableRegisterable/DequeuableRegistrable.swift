//
//  DequeuableRegistrable.swift
//  MyApp
//
//  Created by Shiva on 28/08/2019.
//
import UIKit
import UIKit
import Foundation
/*
 DequeuableRegistrable consists in three simple protocols:
 
 Identifiable: It allows to identify any kind of object by providing a key string. In case of cells, that string is the reusable identifier.
 Dequeuable: Inherits from Identifiable. It allows to dequeue cells from UICollectionView or UITableView using the reusable identifier provided by Identifiable protocol.
 Registrable: Inherits from Identifiable. It allows to register cells in UICollectionView or UITableView using the reusable identifier provided by Identifiable protocol, and a nib object that Registrable protocol requires.
 All of these protocols have extensions that returns defaults values that match the class name. So, for example, if you have a ABCCell class, then its default reusable identifier would be "ABCCell", and its UINib would be UINib(nibName: "ABCCell")
 */


////############## Protocol ###############////
public protocol DequeuableRegistrable: Dequeuable, Registrable {}


////############## Identifire ###############////
public protocol Identifiable {
    static var identifier: String { get }
}

// MARK: - Defaults -
public extension Identifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
/// - Note: ////############## Registrable Nib ###############/
public protocol Registrable: Identifiable {
    static var nib: UINib { get }
}

// MARK: - Defaults -
public extension Registrable {
    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

// MARK: -############### UITableViewCell ###################
public extension Registrable where Self:UITableViewCell {
    static func register(in tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
}

// MARK: - ############## UICollectionViewCell ###############
public extension Registrable where Self:UICollectionViewCell {
    static func register(in collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

// MARK: - ########### UICollectionReusableView ##############
public extension Registrable where Self:UICollectionReusableView {
    static func register(in collectionView: UICollectionView, as type: CollectionViewReusableViewType) {
        collectionView.register(nib,
                                forSupplementaryViewOfKind  : type.value,
                                withReuseIdentifier         : identifier
        )
    }
}

////############## Collection View ###############/////
public enum CollectionViewReusableViewType {
    case header, footer
    
    internal var value: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

/////##########///##########///###########/////
///- Note: Dequeable Collection and Tableview
public protocol Dequeuable: Identifiable {}

// MARK: - UITableViewCell -
public extension Dequeuable where Self: UITableViewCell {
    
    static func dequeue(from tableView: UITableView) -> Self? {
        return tableView.dequeueReusableCell(withIdentifier: identifier) as? Self
    }
}

// MARK: - UICollectionViewCell -
public extension Dequeuable where Self:UICollectionViewCell {
    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Self
    }
}

// MARK: - UICollectionReusableView -
public extension Dequeuable where Self:UICollectionReusableView {
    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath, as type: CollectionViewReusableViewType) -> Self? {
        return collectionView.dequeueReusableSupplementaryView(ofKind: type.value, withReuseIdentifier: identifier, for: indexPath) as? Self
    }
}


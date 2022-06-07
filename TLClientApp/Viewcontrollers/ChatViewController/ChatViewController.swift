//
//  ChatViewController.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 06/06/22.
//

import UIKit
import TwilioChatClient

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrChatSection = [RowData]()

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        updateData()
        addKeyBoardListener()
      }
    public func updateData(){
        tblView.tableFooterView = UIView(frame: .zero)
        tblView.separatorStyle = .none
        var data = RowData.init()
        data.rowType = .txt
        data.sender = 0
        data.txt = "Hello"
        data.time = "12:10 PM"
        data.name = "Aghaz"
        arrChatSection.append(data)
        tblView.reloadData()
    
    }
    func addKeyBoardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
//        let info = notification.userInfo!
//        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
//
//        // bottomChatConstant.constant = keyboardSize - bottomLayoutGuide.length
//     //   bottomChatConstant.constant = keyboardSize - bottomLayoutGuide.length
//        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//
//        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
//
//       tblView.contentInset.bottom = keyboardSize
//        self.view.layoutIfNeeded()
//       // self.tblView.scrollToBottomRow()
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
//        let info = notification.userInfo!
//        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//      //  bottomChatConstant.constant = 0
//
//        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded()
//        }
//        tblView.contentInset.bottom = 0
//        print("keyboard hide")
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
    }
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = arrChatSection[indexPath.row]
        
     
        
        let cellId : String = rowData.cellIdentifier.rawValue
        var cell : ChatTVCell! = tableView.dequeueReusableCell(withIdentifier:cellId) as? ChatTVCell
        
        if (cell == nil) {
            let arr : NSArray = Bundle.main.loadNibNamed(NibNames.chat, owner: self, options: nil)! as NSArray //(Bundle.main.loadNibNamed(NibName.ChatTVCell, owner: self, options: nil))! as NSArray
            cell = arr[rowData.cellTypeIdx.rawValue] as? ChatTVCell
            switch rowData.rowType {
            case .txt:
                if rowData.sender == 0 {
               
                    cell.vendorView.isHidden = true
                    cell.lblCustomerChar.text = "A"
                    cell.lblCustomerChat.text = rowData.txt
                    cell.lblCustomerTime.text = rowData.time
                    cell.lblCustomerName.text = rowData.name
                    cell.imgCustomer.isHidden = true
                }
                else {
                    
                }
                break
            case .img:
               print("img")
                break
                
            case .audioP:
                print("audioP")
                break
              
            case .vdo:
                print("vdo")
            }
            
           
        }
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChatSection.count
    }
}


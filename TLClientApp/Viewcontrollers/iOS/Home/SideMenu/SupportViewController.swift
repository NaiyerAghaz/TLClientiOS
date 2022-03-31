//
//  SupportViewController.swift
//  TLClientApp
//
//  Created by Mac on 18/10/21.
//

import UIKit
import DropDown
import Alamofire
class SupportReceiverTableViewCell:UITableViewCell{
    
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var profileImg: UIImageView!
}
class SupportSenderTableViewCell:UITableViewCell{
    
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var profileImg: UIImageView!
}
class SupportViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var messageTF: UITextField!
    @IBOutlet var supportTV: UITableView!
    var apiGetSupportMessageModel:ApiGetSupportMessageModel?
    var apiGetGroupDataModel:ApiGetGroupDataModel?
    var groupID = 0
    var categoryID = 0
    var apiGetCategoryResponseData : ApiGetCategoryResponseData?
    var selectedGroup = ""
    var gropuArr:[String] = []
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageTF.layer.cornerRadius = self.messageTF.bounds.height / 2 
        // Do any additional setup after loading the view.
        self.supportTV.delegate = self
        self.supportTV.dataSource = self
        hitApiGetGroupData()
        
    }
    
    @IBAction func actionGroupTapped(_ sender: UIButton) {
        dropDown.anchorView = sender //5
                dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
                //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
                dropDown.backgroundColor = UIColor.white
                dropDown.layer.cornerRadius = 20
                dropDown.clipsToBounds = true
                dropDown.show() //7
                dropDown.dataSource = gropuArr
                //["Finance","Human Resource", "Scheduling", "Translation"]
              dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
                  sender.setTitle(item, for: .normal)
                sender.setTitleColor(UIColor.black, for: .normal)
                self?.selectedGroup = item
                self?.apiGetGroupDataModel?.staffData?.forEach({ groupData in
                    if groupData.groupName == item{
                        print("groupID is \(groupData.groupID ?? 0)")
                        self?.groupID = groupData.groupID ?? 0
                        self?.hitApiGetCategoryData(groupID: self?.groupID ?? 0)
                    }
                    
                })
                
              }
    }
    @IBAction func actionCategoryTapped(_ sender: Any) {
    }
    @IBAction func actionBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionSendBtn(_ sender: UIButton) {
    }
    func hitApiSendMessage(){
        
    }
    func hitApiGetGroupData(){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let urlString = "https://lsp.totallanguage.com/Controls/Notification/GetData?methodType=StaffData&CompanyID=\(companyId)&flag=1&UserID=\(userId)"
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata72 = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetGroupDataModel = try jsonDecoder.decode(ApiGetGroupDataModel.self, from: daata72)
                               print("Success")
                                
                                self.apiGetGroupDataModel?.staffData?.forEach({ groupData in
                                       let group =  groupData.groupName ?? ""
                                      self.gropuArr.append(group)
                                })
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                    })}
        else{
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
    func hitApiGetCategoryData(groupID:Int){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let urlString = "https://lsp.totallanguage.com/Controls/Notification/GetData?methodType=ADDUDATECATEGORY&groupId=\(groupID)&flag=1&userid=\(userId)&Utype=Vendor&usertypeid=4&CompanyID=\(companyId)"
        print("url for get category is \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata73 = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetCategoryResponseData = try jsonDecoder.decode(ApiGetCategoryResponseData.self, from: daata73)
                              
                                print("response model is \(self.apiGetCategoryResponseData)")
                                self.categoryID = self.apiGetCategoryResponseData?.aDDUDATECATEGORY?.first?.categoryid ?? 0
                                print("Success category id is \(self.categoryID )")
                                self.hitApiGetAllMessage(catID: self.categoryID, userID: Int(userId) ?? 0, groupID: groupID)
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                    })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
    func hitApiGetAllMessage(catID:Int , userID:Int,groupID:Int){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
              
        self.apiGetSupportMessageModel = nil
        let urlString = "https://lsp.totallanguage.com/Controls/Notification/GetData?methodType=NOTIFICATIONCONVARTION&VendorID=0&UserID=\(userID)&Type=Customer&GrupID=\(groupID)&SupportType=CustomerSupport&catId=\(catID)"
        print("url to get all message : \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata74 = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetSupportMessageModel = try jsonDecoder.decode(ApiGetSupportMessageModel.self, from: daata74)
                               print("Success")
                                DispatchQueue.main.async {
                                    self.supportTV.reloadData()
                                }
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                })
        }
    else {
        self.view.makeToast(ConstantStr.noItnernet.val)
    }
    }
    
}

extension SupportViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let countt = self.apiGetSupportMessageModel?.nOTIFICATIONCONVARTION?.count ?? 0
        print("print message are \(countt)")
        return countt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportSenderTableViewCell") as! SupportSenderTableViewCell
        return cell
        
    }
    
    
}

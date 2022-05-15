//
//  UpdateDepartmentAndContactVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 24/03/22.
//

import UIKit
import Alamofire
import CloudKit
class UpdateDepartmentAndContactVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nameTFView: UIView!
    @IBOutlet weak var deleteTitleLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var AddActionBtn: UIButton!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var departmentTF: UITextField!
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    var contactActiontype: Int?
    var depatmrntActionType: Int?
    var oneTimeDepartmentArr = [DepartmentData]()
    var oneTimeContactArr = [ProviderData]()
    var elementID = 0
    var elementName = ""
    var DeptID = 0
    var actionType = ""
    var isdepartSelect = false
    var isAddOneTime = 0
    var ischangeparam = false
    var tableDelegate : ReloadBlockedTable?
    var venueID = ""
    
   //  contactActiontype: Int?    0 - Add , 1 - Edit , 2- Delete , 5 - One time
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
            .withAlphaComponent(0.6)
        print("selected id and name is \(elementID), \(elementName), \(DeptID)")
        if isdepartSelect {
            if isAddOneTime == 1{
                self.titleLbl.text = "  One Time Department  "
                self.headingLbl.text = "  One Time Department  "
            }else {
                self.titleLbl.text = "  Department  "
                self.headingLbl.text = "  Department  "
            }
            
            self.deleteTitleLbl.text = "Are you sure you want to delete this Department ?"
        }else {
            if isAddOneTime == 1 {
                self.titleLbl.text = "  One Time Contact  "
                self.headingLbl.text = "  One Time Contact  "
            }else {
                self.titleLbl.text = "  Contact  "
                self.headingLbl.text = "  Contact  "
            }
           
            self.deleteTitleLbl.text = "Are you sure you want to delete this Contact ?"
        }
        if actionType == "Add" {
            self.deleteTitleLbl.isHidden = true
            self.nameTFView.isHidden = false
            self.cancelBtn.isHidden = true
            self.departmentTF.text = ""
            ischangeparam = false
            self.AddActionBtn.setTitle("Add", for: .normal)
        }else if actionType == "Delete" {
            self.deleteTitleLbl.isHidden = false
            self.nameTFView.isHidden = true
            self.cancelBtn.isHidden = false
            self.departmentTF.text = self.elementName
            ischangeparam = true
            self.AddActionBtn.setTitle("Delete", for: .normal)
        }else if actionType == "Update" {
            self.deleteTitleLbl.isHidden = true
            self.nameTFView.isHidden = false
            self.cancelBtn.isHidden = true
            self.departmentTF.text = self.elementName
            self.AddActionBtn.setTitle("Update", for: .normal)
            ischangeparam = false
        }else {
            self.deleteTitleLbl.isHidden = true
            self.nameTFView.isHidden = false
            self.cancelBtn.isHidden = true
            self.departmentTF.text = ""
            ischangeparam = false
        }
        self.parentView.layer.cornerRadius = 30
        self.topView.layer.cornerRadius = 30
        self.parentView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        self.topView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        
    }
    
    @IBAction func actionCancelDeleteOption(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func actionCancelPerform(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionAddPerform(_ sender: UIButton) {
        if self.departmentTF.text!.isEmpty {
            self.view.makeToast("Please fill department name.",duration: 1, position: .center)
            return
        }else {
            if isdepartSelect {
                
                hitApiAddDepartment(id: self.elementID, departmentName: self.departmentTF.text ?? "", flag: self.actionType, isOneTime: self.isAddOneTime, deptID: self.DeptID, type: "Department", venueID: self.venueID, isChangeParameter: self.ischangeparam)
            }else {
                hitApiAddDepartment(id: self.elementID, departmentName: self.departmentTF.text ?? "", flag: self.actionType, isOneTime: self.isAddOneTime, deptID: self.DeptID, type: "Contact", venueID: self.venueID, isChangeParameter: self.ischangeparam)
            }
            
        }
    }
    func hitApiAddDepartment(id : Int, departmentName : String, flag: String, isOneTime:Int, deptID :Int , type :String,venueID:String, isChangeParameter : Bool){
        SwiftLoader.show(animated: true)
        let urlString = APi.AddUpdateDeptAndContactData.url
        let companyID = GetPublicData.sharedInstance.companyID
        let userID = GetPublicData.sharedInstance.userID
       // let userTypeId = GetPublicData.sharedInstance.userTypeID
        var searchString = ""
        if isChangeParameter {
            searchString = "<INFO><ID>\(id)</ID><Flag>\(flag)</Flag><Type>\(type)</Type></INFO>"
        }else {
            
            searchString = "<INFO><COMPANYID>\(companyID)</COMPANYID><ID>\(id)</ID><Name>\(departmentName)</Name><VenueID>\(venueID)</VenueID><Flag>\(flag)</Flag><Type>\(type)</Type><CustomerID>\(GetPublicData.sharedInstance.TempCustomerID)</CustomerID><OneTime>\(isOneTime)</OneTime><Deptid>\(deptID)</Deptid><LOGINUSERID>\(userID)</LOGINUSERID></INFO>"
        }
         
        let parameter = [
            "strSearchString" : searchString
        ] as [String : String]
        print("url and parameter are hitApiAddDepartment:", urlString, parameter)
        AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success getCustomerDetail ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                        print("Success getCustomerDetail Model ",self.apiGetCustomerDetailResponseModel.first?.result ?? "")
                        let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                        let data = str.data(using: .utf8)!
                        do {
//
                            print("DATAAA ISSS \(data)")
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {

                                let newjson = jsonArray.first
                                let userInfo = newjson?["DepConatctData"] as? [[String:Any]]
                                //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                let userIfo = userInfo?.first
                                let success = userIfo?["success"] as? Int
                                let message = userIfo?["Message"] as? String
                                
                               let status = userIfo?["Status"] as? Int
                                //self.showDepartMentView.visibility = .gone
                               
                                if CEnumClass.share.getAppointmentaddingStatus(msz: message!) == true {
                                    self.view.makeToast(message, duration: 2, position: .center)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                       
                                    }
                                    else {
                                        self.view.makeToast(message, duration: 1, position: .center)
                                        if contactActiontype != nil {
                                            
                                            if contactActiontype == 0 {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    self.tableDelegate?.didReloadTable(performTableReload: false,elemntID: id, isConatctUpdate: true)
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                                
                                            }else if contactActiontype == 5 {
                                              
                                                let itemA = ProviderData(ProviderID: status, ProviderName: departmentName)
                                                oneTimeContactArr.append(itemA)
                                                
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    self.tableDelegate?.updateOneTimeConatct(ConatctData: itemA, isDelete: false )
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                               
                                            }else if contactActiontype == 2 {
                                                
                                                let itemA = ProviderData(ProviderID: status, ProviderName: departmentName)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    self.tableDelegate?.updateOneTimeConatct(ConatctData: itemA, isDelete: true)
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                               
                                            }else if contactActiontype == 1 {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.tableDelegate?.didReloadTable(performTableReload: false,elemntID: id, isConatctUpdate: true)
                                                    self.dismiss(animated: true, completion: nil)}
                                            }else {
                                                
                                            }
                                        }else if self.depatmrntActionType != nil  {
                                            if depatmrntActionType == 0 {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.tableDelegate?.didReloadTable(performTableReload: false,elemntID: id, isConatctUpdate: false)
                                                    self.dismiss(animated: true, completion: nil)}
                                            }else  if depatmrntActionType == 5 {
                                                
                                                let itemA = DepartmentData(DeActive: 0, DepartmentID: status, DepartmentName: departmentName)
                                                
                                                oneTimeDepartmentArr.append(itemA)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.tableDelegate?.updateOneTimeDepartment(departmentData: itemA, isDelete: false)
                                                    self.dismiss(animated: true, completion: nil)}
                                            }else if depatmrntActionType == 2 {
                                                let itemA = DepartmentData(DeActive: 0, DepartmentID: status, DepartmentName: departmentName)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    self.tableDelegate?.updateOneTimeDepartment(departmentData: itemA, isDelete: true)
                                                    self.dismiss(animated: true, completion: nil)}
                                            }else if depatmrntActionType == 1 {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    self.tableDelegate?.didReloadTable(performTableReload: false, elemntID: id, isConatctUpdate: false)
                                                    self.dismiss(animated: true, completion: nil)}
                                            }else {
                                                self.dismiss(animated: true, completion: nil)
                                            }
                                        }
                                    }
                                    } else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    } catch{
                        
                        print("error block getCustomerDetail " ,error)
                    }
                   
                case .failure(_):
                    print("Respose getCustomerDetail ")
                    
                }
            })
    }
   

}

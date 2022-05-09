//
//  AddNewVenueViewController.swift
//  TLClientApp
//
//  Created by Mac on 19/10/21.
//

import UIKit
import Alamofire
import DropDown
import iOSDropDown
protocol UpdateOneTimeVenue {
    func updateOneTimeVenue(VenueName : String,cityName : String,Address : String , State:String , zipCode : String, venueID : Int, stateID : Int , address2 : String )
}
class AddNewVenueViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet var venuetitleLbl: UILabel!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var zipCodeTF: UITextField!
    @IBOutlet var notesTF: UITextField!
    @IBOutlet var stateTF: iOSDropDown!
    @IBOutlet var cityTF: UITextField!
    @IBOutlet var address2TF: UITextField!
    @IBOutlet var address1TF: UITextField!
    @IBOutlet var venueNameTF: UITextField!
    @IBOutlet var contactTF: UITextField!
    var userCustomerId = ""
    var isFrom = ""
    var ifFromSideMenue = false
    var venueId = 0
    var stateId = 0
    var delegate:UpdateOneTimeVenue?
    var isOneTime = false
    var dropDown = DropDown()
    var stateDataSouerce = [String]()
    var venueDetail:VenueData?
    var apiGetAllVenueDataResponseModel:ApiGetAllVenueDataResponseModel?
    var apiAddOneTimeVenueDataResponse:ApiAddOneTimeVenueDataResponse?
    var apiAddVenueResponse:ApiAddVenueResponse?
    var apiStateListResponseModel:ApiStateListResponseModel?
    var apiAllStateDataResponse = [ApiAllStateDataResponse]()
    var apiGetAllVenuListResponse:ApiGetAllVenuListResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addBtn.layer.cornerRadius = self.addBtn.bounds.height / 2
        if ifFromSideMenue {
            self.venueNameTF.text = self.apiGetAllVenuListResponse?.venueName ?? ""
            self.address1TF.text = self.apiGetAllVenuListResponse?.address ?? ""
            self.address2TF.text = self.apiGetAllVenuListResponse?.address2 ?? ""
            self.cityTF.text = self.apiGetAllVenuListResponse?.city ?? ""
            self.stateTF.text = self.apiGetAllVenuListResponse?.state ?? ""
            self.notesTF.text = self.apiGetAllVenuListResponse?.notes ?? ""
            self.zipCodeTF.text = self.apiGetAllVenuListResponse?.zipCode ?? ""
            self.venueId = self.apiGetAllVenuListResponse?.venueID ?? 0
        }else {
            self.venueNameTF.text = self.venueDetail?.VenueName ?? ""
            self.address1TF.text = self.venueDetail?.Address ?? ""
            self.address2TF.text = self.venueDetail?.Address2 ?? ""
            self.cityTF.text = self.venueDetail?.City ?? ""
            self.stateTF.text = self.venueDetail?.State ?? ""
            self.notesTF.text = self.venueDetail?.Notes ?? ""
            self.zipCodeTF.text = self.venueDetail?.ZipCode ?? ""
            self.venueId = self.venueDetail?.VenueID ?? 0
        }
        
     
        print("state array count \(stateDataSouerce.count)")

       // getVenuList()
        getStateList()
        if isFrom == "EDITVENUE"{
            self.venuetitleLbl.text = "Edit Venue Details"
            self.addBtn.setTitle("Update", for: .normal)
        }else {
            self.addBtn.setTitle("Add", for: .normal)
            if isOneTime {
                self.venuetitleLbl.text = "One Time Venue"
            }else {
                self.venuetitleLbl.text = "Add Venue Details"
            }
            
        }
        // Do any additional setup after loading the view.
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == stateTF {
            let selectedText =  textField.text ?? ""
            self.apiGetAllVenueDataResponseModel?.states?.forEach({ stateData2  in
                print("selected Text \(selectedText) , state name  \(stateData2.stateName ?? "")")
                if selectedText == stateData2.stateName ?? "" {
                    self.stateId = stateData2.stateID ?? 0
                    print("state id \(self.stateId)")
                }
            })
        }
    }
    @IBAction func openDepartmentInfo(_ sender: UIButton) {
        
    }
    @IBAction func openStateBtn(_ sender: UIButton) {
    dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
            dropDown.backgroundColor = UIColor.white
            dropDown.layer.cornerRadius = 20
            dropDown.clipsToBounds = true
            dropDown.show() //7
            dropDown.dataSource = stateDataSouerce
            dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
            self?.stateTF.text = item
            
            }
}
    func getStateList(){
        stateDataSouerce.removeAll()
        SwiftLoader.show(animated: true)
              
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let userTypeID = GetPublicData.sharedInstance.userTypeID
        let companyId = GetPublicData.sharedInstance.companyID
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/GetData?methodType=States&UserID=\(userId)&UserType=\(userTypeID)&country=\(companyId)"
        print("url to get states \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success State Data ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiStateListResponseModel = try jsonDecoder.decode(ApiStateListResponseModel.self, from: daata)
                               print("Success")
                                self.apiStateListResponseModel?.states?.forEach { stateData in
                                    let state =  stateData.stateName ?? ""
                                      stateDataSouerce.append(state)
                                    
                                    stateTF.selectedRowColor = UIColor.clear
                                    stateTF.optionArray = stateDataSouerce
                                    stateTF.didSelect{(selectedText , index , id) in
                                        self.stateTF.text = "\(selectedText)"
                                        
                                        self.apiStateListResponseModel?.states?.forEach({ stateData2  in
                                            print("selected Text \(selectedText) , state name  \(stateData2.stateName ?? "")")
                                            if selectedText == stateData2.stateName ?? "" {
                                                self.stateId = stateData2.stateID ?? 0
                                                print("state id \(self.stateId)")
                                            }
                                        })
                                            
                                        
                                    }

                                 }
                                
                                
                                
                        
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                })
     }
    func getVenuList(){
        stateDataSouerce.removeAll()
        SwiftLoader.show(animated: true)
              
        let userId = userDefaults.string(forKey: "userId") ?? ""
        
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/GetData?methodType=VenueData%2CDepartmentData%2CProviderData%2CStates&CustomerID=\(userId)&UserType=Customer&Type=EDITTIME"
        print("url to get states \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success Add venue ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetAllVenueDataResponseModel = try jsonDecoder.decode(ApiGetAllVenueDataResponseModel.self, from: daata)
                               print("Success")
                                self.apiGetAllVenueDataResponseModel?.states?.forEach { stateData in
                                    let state =  stateData.stateName ?? ""
                                      stateDataSouerce.append(state)
                                    
                                    stateTF.selectedRowColor = UIColor.clear
                                    stateTF.optionArray = stateDataSouerce
                                    stateTF.didSelect{(selectedText , index , id) in
                                        self.stateTF.text = "\(selectedText)"
                                        
                                        self.apiGetAllVenueDataResponseModel?.states?.forEach({ stateData2  in
                                            print("selected Text \(selectedText) , state name  \(stateData2.stateName ?? "")")
                                            if selectedText == stateData2.stateName ?? "" {
                                                self.stateId = stateData2.stateID ?? 0
                                                print("state id \(self.stateId)")
                                            }
                                        })
                                            
                                        
                                    }

                                 }
                                
                                
                                
                        
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                })
     }
    @IBAction func cancleBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionAddBtn(_ sender: Any) {
        if venueNameTF.text!.isEmpty {
                    self.view.makeToast("Please fill venue name.",duration: 1, position: .center)
                    
        }
//                else if self.address2TF.text!.isEmpty {
//                    self.view.makeToast("Please fill Address2.",duration: 1, position: .center)
//                }
                else if address1TF.text!.isEmpty {
                    self.view.makeToast("Please fill Address1.",duration: 1, position: .center)
                    
                }
                else if self.cityTF.text!.isEmpty {
                    self.view.makeToast("Please fill City name.",duration: 1, position: .center)
                }

                else if zipCodeTF.text!.isEmpty {
                    self.view.makeToast("Please fill zipcode.",duration: 1, position: .center)
                }
                else if stateTF.text!.isEmpty {
                    self.view.makeToast("Please fill state.",duration: 1, position: .center)
                }else {
                    if isOneTime {
                        addOneTimeVenueDetail()
                    }else {
                        addVenueDetail()
                    }
                    
                    
                }
        
    }
    func addVenueDetail(){
        SwiftLoader.show(animated: true)
        if self.stateId == 0 {
            let selectedText = stateTF.text ?? ""
            self.apiGetAllVenueDataResponseModel?.states?.forEach({ stateData2  in
                print("selected Text \(selectedText) , state name  \(stateData2.stateName ?? "")")
                if selectedText == stateData2.stateName ?? "" {
                    self.stateId = stateData2.stateID ?? 0
                    print("state id \(self.stateId)")
                }
            })
        }else {
            
        }
        
        
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/AddUpdateVenue"
        let parameters = [
            "VenueDetails":[
                "VNCustomerUserid":userId,
                "VenueID" : self.venueId ,
                "VenueName" : self.venueNameTF.text ?? "",
                "UserID" : GetPublicData.sharedInstance.TempCustomerID,
                "CompanyID" : companyId,
                "Address" : self.address1TF.text ?? "",
               "Address2" : self.address2TF.text ?? "",
                "Notes":  self.notesTF.text ?? "",
                "City":  self.cityTF.text ?? "",
                "StateID":  self.stateId ,
               "ZipCode":  self.zipCodeTF.text ?? "",
              // "Contact" : self.contactTF.text ?? "",
                "Active" : true,
               "IsDefault" : false
               ]
                  
             ] as [String:Any]
        print("url to update venue \(urlString),\(parameters)")
                AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiAddVenueResponse = try jsonDecoder.decode(ApiAddVenueResponse.self, from: daata)
                                let status = self.apiAddVenueResponse?.venues?.first?.success ?? 0
                                if status == 1 {
                                    print("Success")
                                    if isFrom == "EDITVENUE" {
                                        self.view.makeToast("Venue updated successfully.",duration: 1, position: .center)
                                    }else {
                                        self.view.makeToast("Venue added successfully.",duration: 1, position: .center)
                                    }
                                    NotificationCenter.default.post(name: Notification.Name("updateVenueInList"), object: nil , userInfo: nil)
                                    
                                    NotificationCenter.default.post(name: Notification.Name("updateVenueList"), object: nil , userInfo: nil)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                                         self.dismiss(animated: true, completion: nil)
                                     }
                                }else {
                                    self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                                }
                            } catch{
                                self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                            self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                           
                        }
                })
     }
    func addOneTimeVenueDetail(){
        
        SwiftLoader.show(animated: true)
        if self.stateId == 0 {
            let selectedText = stateTF.text ?? ""
            self.apiGetAllVenueDataResponseModel?.states?.forEach({ stateData2  in
                print("selected Text \(selectedText) , state name  \(stateData2.stateName ?? "")")
                if selectedText == stateData2.stateName ?? "" {
                    self.stateId = stateData2.stateID ?? 0
                    print("state id \(self.stateId)")
                }
            })
        }
        
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/onetimeAddUpdateVenue"
        let parameters =  ["VenueDetails":[
            "VenueID": self.venueId,
            "VenueName": self.venueNameTF.text ?? "",
            "UserID": userCustomerId,
            "CompanyID": companyId,
            "Address": self.address1TF.text ?? "",
            "Address2": self.address2TF.text ?? "",
            "Notes": self.notesTF.text ?? "",
            "City": self.cityTF.text ?? "",
            "StateID": self.stateId ,
            "ZipCode": self.zipCodeTF.text ?? "",
            "IsDefault": 0
            ]

            ] as [String:Any]
        
        print("onetimeVenue URL \(urlString),\(parameters)")
                AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiAddOneTimeVenueDataResponse = try jsonDecoder.decode(ApiAddOneTimeVenueDataResponse.self, from: daata)
                                let status = self.apiAddOneTimeVenueDataResponse?.venues?.first?.success ?? 0
                                if status == 1 {
                                    print("Success,\(self.apiAddOneTimeVenueDataResponse?.venues)")
                                    let venueID = self.apiAddOneTimeVenueDataResponse?.venues?.first?.status ?? 0
                                     self.view.makeToast("Venue added successfully.",duration: 2, position: .center)
                                    self.delegate?.updateOneTimeVenue(VenueName: self.venueNameTF.text ?? "", cityName: self.cityTF.text ?? "", Address: self.address1TF.text ?? "", State: self.stateTF.text ?? "", zipCode: self.zipCodeTF.text ?? "", venueID :venueID, stateID : self.stateId , address2 : self.address2TF.text ?? "" )
                                     DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                                         self.dismiss(animated: true, completion: nil)
                                     }
                                }else {
                                    self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                                }
                            } catch{
                                self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                            self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                           
                        }
                })
     }
}


//
//  UpdateVenueContainerViewController.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 21/03/22.
//

import UIKit
import Alamofire
class UpdateVenueContainerViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var venuListTV: UITableView!
    var stateDataSouerce = [String]()
    var apiAddVenueResponse:ApiAddVenueResponse?
    var apiGetAllVenueDataResponseModel:ApiGetAllVenueDataResponseModel?
    var venueDetail = [VenueData]()
    var apiGetCustomerDetailResponseModel = [ApiGetCustomerDetailResponseModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        venuListTV.delegate = self
        venuListTV.dataSource = self
        let customerID = GetPublicData.sharedInstance.TempCustomerID
       getVenueDetail(customerId: customerID)
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func updateVenueList(){
      
        let customerID = GetPublicData.sharedInstance.TempCustomerID
       getVenueDetail(customerId: customerID)
        
    }
    
    
    @IBAction func actionBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   /* func getVenuList(){
        if Reachability.isConnectedToNetwork() {
       
        SwiftLoader.show(animated: true)
        stateDataSouerce.removeAll()
        let userId = userDefaults.string(forKey: "userId") ?? ""
      
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/GetData?methodType=VenueData%2CDepartmentData%2CProviderData%2CStates&CustomerID=\(userId)&UserType=Customer&Type=EDITTIME"
       
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetAllVenueDataResponseModel = try jsonDecoder.decode(ApiGetAllVenueDataResponseModel.self, from: daata)
                               print("Success")
                                self.apiGetAllVenueDataResponseModel?.states?.forEach { stateData in
                                    let state =  stateData.stateName ?? ""
                                    self.stateDataSouerce.append(state)
                                 }
                        
                                DispatchQueue.main.async {
                                    venuListTV.reloadData()
                                }
                               
                                
                                
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
     }*/
    
    func getVenueDetail(customerId : String){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
      
        self.venueDetail.removeAll()
       
        
            
            
            
        let urlString = APi.GetVenueCommanddl.url
        let companyID = GetPublicData.sharedInstance.companyID
        let userID = GetPublicData.sharedInstance.userID
        let userTypeId = GetPublicData.sharedInstance.userTypeID
        let searchString = "<INFO><CUSTOMERID>\(customerId)</CUSTOMERID><USERTYPEID>\(userTypeId)</USERTYPEID><LOGINUSERID>\(userID)</LOGINUSERID><COMPANYID>\(companyID)</COMPANYID><FLAG>1</FLAG><AppointmentID>0</AppointmentID></INFO>"
        let parameter = [
            "strSearchString" : searchString
        ] as [String : String]
        print("url and parameter for venue ", urlString, parameter)
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
                        print("Success getvenueDetail Model ",self.apiGetCustomerDetailResponseModel.first?.result ?? "")
                        let str = self.apiGetCustomerDetailResponseModel.first?.result ?? ""
                        let data = str.data(using: .utf8)!
                        do {
//
                            print("DATAAA ISSS \(data)")
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {

                                let newjson = jsonArray.first
                                let venueList = newjson?["Venuelist"] as? [[String:Any]]
                                
                                let departmentList = newjson?["DepartmentList"] as? [[String:Any]] // use the json here
                                let providerList = newjson?["ProviderNameList"] as? [[String:Any]]
                                let customerPermision = newjson?["customerPermission"] as? [[String:Any]]
                                //let customerUserName = userIfo?["CustomerUserName"] as? String
                                print("venue Detail is ",newjson)
                                venueList?.forEach({ venueData in
                                    let address = venueData["Address"] as? String
                                    let address2 = venueData["Address2"] as? String
                                    let city = venueData["City"] as? String
                                    let companyID = venueData["CompanyID"] as? Int
                                    let customerCompany = venueData["CustomerCompany"] as? String
                                    let customerName = venueData["CustomerName"] as? String
                                    let notes = venueData["Notes"] as? String
                                    let state = venueData["State"] as? String
                                    let stateID = venueData["StateID"] as? Int
                                    let venueID = venueData["VenueID"] as? Int
                                    let venueName = venueData["VenueName"] as? String
                                    let zipCode = venueData["ZipCode"] as? String
                                     print("zipcode is \(zipCode)", "venueData is \(venueData)" )
                                    let itemA = VenueData(Address: address, Address2: address2, City: city, CompanyID: companyID, CustomerCompany: customerCompany, CustomerName: customerName, Notes: notes, State: state, StateID: stateID, VenueID: venueID, VenueName: venueName, ZipCode: zipCode,isOneTime: false)
                                    self.venueDetail.append(itemA)
                                    
                                })
                                DispatchQueue.main.async {
                                    self.venuListTV.reloadData()
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
            })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    func deleteVenueAddress(venueId:Int, venueName:String , address:String , address2:String , notes:String , city:String , state:String , zipcode:String){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
    
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/AddUpdateVenue"
        let parameters = [
                  "VenueDetails":[
                       "VenueID" : venueId ,
                       "UserID" : GetPublicData.sharedInstance.TempCustomerID,
                       "CompanyID" : companyId,
                       "VNCustomerUserid":userId,
                       "Active" : false,
                       "IsDefault" : false
                  ]
                  
             ] as [String:Any]
        print("url to get schedule \(urlString)")
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
                                     self.view.makeToast("Venue deleted successfully.",duration: 2, position: .center)
                                    let customerID = GetPublicData.sharedInstance.TempCustomerID
                                  // getVenueDetail(customerId: customerID)
                                    NotificationCenter.default.post(name: Notification.Name("updateVenueList"), object: nil , userInfo: nil)
                                    NotificationCenter.default.post(name: Notification.Name("updateVenueInList"), object: nil , userInfo: nil)
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
                    })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
}
//MARK: - Table work

extension UpdateVenueContainerViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venueDetail.count // self.apiGetAllVenueDataResponseModel?.venueData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueListTableViewCell") as! venueListTableViewCell
        let indx = self.venueDetail[indexPath.row]// self.apiGetAllVenueDataResponseModel?.venueData?[indexPath.row]
        cell.cityLbl.text = indx.City
        cell.address2Lbl.text = indx.Address2
        cell.addressLbl.text = indx.Address
        cell.namLbl.text = indx.VenueName
        cell.customerNameLbl.text = indx.CustomerName
        cell.noteLbl.text = indx.Notes
        cell.zipCodeLbl.text = indx.ZipCode
        cell.stateLbl.text = indx.State
        cell.editBtn.tag  = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(actionEditVenue), for: .touchUpInside)
        cell.deleteBtn.tag  = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(actionDeleteVenue), for: .touchUpInside)
        return cell
    }
    @objc func actionDeleteVenue(_ sender : UIButton){
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete the Venue?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            let indx = self.venueDetail[sender.tag]//self.apiGetAllVenueDataResponseModel?.venueData?[sender.tag]
            let venueId = indx.VenueID ?? 0
                let venueName = indx.VenueName ?? ""
                let address = indx.Address ?? ""
                let address2 = indx.Address2 ?? ""
                let notes = indx.Notes ?? ""
                let city = indx.City ?? ""
                let state = indx.State ?? ""
                let zipcode = indx.ZipCode ?? ""
               // let contact = indx?. ?? ""
            self.deleteVenueAddress(venueId: venueId, venueName: venueName, address: address, address2: address2, notes: notes, city: city, state: state, zipcode: zipcode)
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    @objc func actionEditVenue(_ sender : UIButton){
        let storyboard = UIStoryboard(name: Storyboard_name.home, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        let id = self.venueDetail[sender.tag].VenueID ?? 0//self.apiGetAllVenueDataResponseModel?.venueData?[sender.tag].venueID ?? 0
        vc.isFrom = "EDITVENUE"
        vc.venueId = id
        vc.venueDetail = self.venueDetail[sender.tag]
        vc.apiGetAllVenuListResponse = self.apiGetAllVenueDataResponseModel?.venueData?[sender.tag]
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
}

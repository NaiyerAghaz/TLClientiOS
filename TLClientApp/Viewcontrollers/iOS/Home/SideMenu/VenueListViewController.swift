//
//  VenueListViewController.swift
//  TLClientApp
//
//  Created by Mac on 18/10/21.
//

import UIKit
import Alamofire
class venueListTableViewCell : UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var noteLbl: UILabel!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var stateLbl: UILabel!
    @IBOutlet var zipCodeLbl: UILabel!
    @IBOutlet var cityLbl: UILabel!
    @IBOutlet var customerNameLbl: UILabel!
    @IBOutlet var address2Lbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var namLbl: UILabel!
    override func awakeFromNib() {
        self.mainView.addShadowGrey()
    }
}
class VenueListViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var venuListTV: UITableView!
    var stateDataSouerce = [String]()
    var apiAddVenueResponse:ApiAddVenueResponse?
    var apiGetAllVenueDataResponseModel:ApiGetAllVenueDataResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        venuListTV.delegate = self
        venuListTV.dataSource = self
        getVenuList()
        NotificationCenter.default.addObserver(self, selector: #selector(updateVenueList), name: Notification.Name("updateVenueList"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func updateVenueList(){
        getVenuList()
        
    }
    
    @IBAction func actionAddNewAddress(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        vc.apiAllStateDataResponse = self.apiGetAllVenueDataResponseModel?.states ?? [ApiAllStateDataResponse]()
        vc.stateDataSouerce = self.stateDataSouerce
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func actionBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func getVenuList(){
        stateDataSouerce.removeAll()
        SwiftLoader.show(animated: true)
              /*  let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(UserDefaults.standard.value(forKey:"token") ?? "")",
                           "cache-control": "no-cache"
                       ]
               // print("😗---hitApiSignUpUser -" , Api.profile.url) 10/01/2021 */
        let userId = userDefaults.string(forKey: "userId") ?? ""
        //let urlParam = "CustomerID=\(userId)&UserType=Customer&Type=EDITTIME"
        //let urABC = "\(APi.getVenueData.url)" + urlParam
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/GetData?methodType=VenueData%2CDepartmentData%2CProviderData%2CStates&CustomerID=\(userId)&UserType=Customer&Type=EDITTIME"
        //print("url to get schedule \(urABC)")
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
                })
     }
    func deleteVenueAddress(venueId:Int, venueName:String , address:String , address2:String , notes:String , city:String , state:String , zipcode:String){
        SwiftLoader.show(animated: true)
    
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        let urlString = "https://lsp.totallanguage.com/Controls/Venue/AddUpdateVenue"
        let parameters = [
                "VenueID" : venueId ,
                  "VenueName" : venueName,
                  "UserID" : userId,
                  "CompanyID" : companyId,
                  "Address" : address,
                 "Address2" : address2,
                  "Notes":  notes,
                  "City": city ,
                  "StateID":  state,
                 "ZipCode":  zipcode ,
                // "Contact" : contact ,
                  "Active" : false,
                 "IsDefault" : ""
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
                                     self.view.makeToast("Address deleted successfuly.",duration: 2, position: .center)
                                    getVenuList()
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
extension VenueListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiGetAllVenueDataResponseModel?.venueData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueListTableViewCell") as! venueListTableViewCell
        let indx = self.apiGetAllVenueDataResponseModel?.venueData?[indexPath.row]
        cell.cityLbl.text = indx?.city
        cell.address2Lbl.text = indx?.address2
        cell.addressLbl.text = indx?.address
        cell.namLbl.text = indx?.venueName
        cell.customerNameLbl.text = indx?.customerName
        cell.noteLbl.text = indx?.notes
        cell.zipCodeLbl.text = indx?.zipCode
        cell.stateLbl.text = indx?.state
        cell.editBtn.tag  = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(actionEditVenue), for: .touchUpInside)
        cell.deleteBtn.tag  = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(actionDeleteVenue), for: .touchUpInside)
        return cell
    }
    @objc func actionDeleteVenue(_ sender : UIButton){
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete the Address?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            let indx = self.apiGetAllVenueDataResponseModel?.venueData?[sender.tag]
            let venueId = indx?.venueID ?? 0
                let venueName = indx?.venueName ?? ""
                let address = indx?.address ?? ""
                let address2 = indx?.address2 ?? ""
                let notes = indx?.notes ?? ""
                let city = indx?.city ?? ""
                let state = indx?.state ?? ""
                let zipcode = indx?.zipCode ?? ""
               // let contact = indx?. ?? ""
            self.deleteVenueAddress(venueId: venueId, venueName: venueName, address: address, address2: address2, notes: notes, city: city, state: state, zipcode: zipcode)
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    @objc func actionEditVenue(_ sender : UIButton){
        let vc = storyboard?.instantiateViewController(identifier: "AddNewVenueViewController") as! AddNewVenueViewController
        let id = self.apiGetAllVenueDataResponseModel?.venueData?[sender.tag].venueID ?? 0
        vc.isFrom = "EDITVENUE"
        vc.venueId = id
        
        vc.apiGetAllVenuListResponse = self.apiGetAllVenueDataResponseModel?.venueData?[sender.tag]
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
}

//
//  OPILogsViewController.swift
//  TLClientApp
//
//  Created by Mac on 18/10/21.
//

import UIKit
import Alamofire
class VRIAndOpiTableViewCell: UITableViewCell{
    
    @IBOutlet var DurationLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var targetLanguageLbl: UILabel!
    @IBOutlet var sourceLanguageLbl: UILabel!
}
class VRIAndOPILogsViewController: UIViewController {

    @IBOutlet var callHistoryTV: UITableView!
    var apiVRIOPICallLogResponseModel:ApiVRIOPICallLogResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        getVriCallLogDetails()
        callHistoryTV.delegate = self
        callHistoryTV.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func getVriCallLogDetails(){
        SwiftLoader.show(animated: true)
        self.apiVRIOPICallLogResponseModel = nil
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyID = GetPublicData.sharedInstance.companyID
        let startDate = "11/19/2021"
        let endDate = "11/19/2021"
        let urlPostFix = "CompanyID=\(companyID)&CustomerID=\(userId)&VendorID=&StartDate=\(startDate)&EndDate=\(endDate)&UserId=\(userId)"
        let urlPrefix = "\(APi.Vrilog.url)"
        let urlString = urlPrefix + urlPostFix
        //print("url to get schedule \(urABC)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success Vri log ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiVRIOPICallLogResponseModel = try jsonDecoder.decode(ApiVRIOPICallLogResponseModel.self, from: daata)
                               print("Success vri opi log ")
                               
                                
        
                                
                            } catch{
                                
                                print("error block Vri opi log  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure vri opi log ")
                           
                        }
                })
     }

}
extension VRIAndOPILogsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VRIAndOpiTableViewCell") as! VRIAndOpiTableViewCell
        return cell
    }
    
    
}

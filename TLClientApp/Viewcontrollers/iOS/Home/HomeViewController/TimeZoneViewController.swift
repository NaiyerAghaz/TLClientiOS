//
//  TimeZoneViewController.swift
//  TLClientApp
//
//  Created by SMIT 005 on 31/12/21.
//

import UIKit
import Alamofire
class TimeZoneViewController: UIViewController {

    @IBOutlet weak var timeZoneLbl: UILabel!
    var timeZoneStr = ""
    var currentTimeZone = ""
    var apiUpdateTimeZoneResponse:ApiUpdateTimeZoneResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.timeZoneLbl.text = self.timeZoneStr ?? ""
    }
    

    @IBAction func actionAcknowledge(_ sender: UIButton) {
        updateTimeZoneWithParams()
    }
    
     @IBAction func actionDecline(_ sender: UIButton) {
         userDefaults.set(true, forKey: "isDeclineTimeZone")
        self.dismiss(animated: true, completion: nil)
     }
    func updateTimeZoneWithParams(){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        let userID = GetPublicData.sharedInstance.userID
        let timeZone = self.currentTimeZone.replacingOccurrences(of: " ", with: "%20")
        let url = "https://lsp.totallanguage.com/Home/GetData?methodType=UPDATETIMEZONE&UserID=\(userID)&TZone=\(timeZone)"
        print("url to get time zone ", url )
        AF.request(url, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                
                case .success(_):
                    print("Respose getCurrentTimeZone ")
                    guard let daata100 = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiUpdateTimeZoneResponse = try jsonDecoder.decode(ApiUpdateTimeZoneResponse.self, from: daata100)
                        let success = self.apiUpdateTimeZoneResponse?.uPDATETIMEZONE?.first?.success ?? 0
                        if success == 1 {
                            userDefaults.set(self.currentTimeZone, forKey: "TimeZone")
                            self.view.makeToast("Timezone updated successfully.")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        }else {
                            self.view.makeToast("Please try after sometime.")
                        }
                    } catch{
                        self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                        print("error block forgot password " ,error)
                    }
                case .failure(let error):
                    print("Respose Failure ",error.localizedDescription)
                    self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                   
                }
            })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
        
    }

}

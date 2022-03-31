//
//  OPILogsViewController.swift
//  TLClientApp
//
//  Created by Mac on 18/10/21.
//

import UIKit
import Alamofire
class VRIAndOpiTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var roomNoLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var appointmentTypeLbl: UILabel!
    @IBOutlet weak var refrenceLbl: UILabel!
    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var billRateLbl: UILabel!
    @IBOutlet weak var roundedMinsLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet var DurationLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var targetLanguageLbl: UILabel!
    @IBOutlet var sourceLanguageLbl: UILabel!
}
class VRIAndOPILogsViewController: UIViewController {
    
    var miDate = Calendar.current.date(byAdding: .year, value: -50, to: Date())
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var norecordLbl: UILabel!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet var callHistoryTV: UITableView!
    var startDateForLog = ""
    var EndDateForLog = ""
    var apiVRIOPICallLogResponseModel:ApiVRIOPICallLogResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateParameter = getCurrentStartAndEndDate()
        let startDate = dateParameter.0 //"11/19/2021"
        let endDate = dateParameter.1//"11/19/2021"
        getVriCallLogDetails(startDateForLog: startDate, EndDateForLog: endDate)
        self.titleLbl.text = GetPublicData.sharedInstance.companyName
        callHistoryTV.delegate = self
        callHistoryTV.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSearchTapped(_ sender: UIButton) {
        if self.startDateTF.text == "" {
            self.view.makeToast("Please fill Start Date.")
            return
        }else if self.endDateTF.text == "" {
            self.view.makeToast("Please fill End Date.")
            return
        }else {
            getVriCallLogDetails(startDateForLog: self.startDateForLog, EndDateForLog: self.EndDateForLog)
        }
        
    }
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionEndDate(_ sender: UIButton) {
        //let minDate = Date().adding(minutes: 120)
        print("button tapped ")
//         RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: miDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
//                         // TODO: Your implementation for date
//                         self?.endDateTF.text = selectedDate.dateString("MM/dd/YYYY")
//                          self?.EndDateForLog = selectedDate.dateString("MM/dd/YYYY")
//                         print("selected Date \(selectedDate )")
//
//                     })
        RPicker.selectDate(title: "Select Date", minDate: miDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.endDateTF.text = selectedDate.dateString("MM/dd/YYYY")
            self?.EndDateForLog = selectedDate.dateString("MM/dd/YYYY")
            print("selected Date \(selectedDate )")
        })
    }
    @IBAction func actionStartDate(_ sender: UIButton) {
//         RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .dateAndTime, minDate: miDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
//                         // TODO: Your implementation for date
//                         self?.startDateTF.text = selectedDate.dateString("MM/dd/YYYY")
//            })
        RPicker.selectDate(title: "Select Date", minDate: miDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.startDateForLog = selectedDate.dateString("MM/dd/YYYY")
            self?.startDateTF.text = selectedDate.dateString("MM/dd/YYYY")
        })
    }
    func getCurrentStartAndEndDate() -> (String , String){
        let currentDate = Date().startOfMonth()
        let currentEndDate = Date().endOfMonth()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"//"dd/MM/yyyy HH:mm:ss"
        let startDate = dateFormatter.string(from: currentDate!)
        let endDate = dateFormatter.string(from: currentEndDate!)
        let startDate1 = convertDateFormat(startDate)
        let endDate1 = convertDateFormat(endDate)
        print("date for start appointment \(startDate1)")
        print("date for start appointment \(endDate1)")
        return (startDate1, endDate1)
    }
    func getVriCallLogDetails( startDateForLog : String  , EndDateForLog : String ){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        self.apiVRIOPICallLogResponseModel = nil
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyID = GetPublicData.sharedInstance.companyID
//
     
        let urlPostFix = "CompanyID=\(companyID)&CustomerID=\(userId)&VendorID=&StartDate=\(startDateForLog)&EndDate=\(EndDateForLog)&UserId=\(userId)"
        let urlPrefix = "\(APi.Vrilog.url)"
        let urlString = urlPrefix + urlPostFix
        print("url to get getVriCallLogDetails \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success Vri log ")
                            guard let daata75 = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiVRIOPICallLogResponseModel = try jsonDecoder.decode(ApiVRIOPICallLogResponseModel.self, from: daata75)
                               print("Success vri opi log ")
                                DispatchQueue.main.async {
                                    self.callHistoryTV.reloadData()
                                }
                                
        
                                
                            } catch{
                                
                                print("error block Vri opi log  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure vri opi log ")
                           
                        }
                    })}else {
                        self.view.makeToast(ConstantStr.noItnernet.val)
                    }
     }
    func convertTimeFormater(_ date: String) -> String
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // 2021-11-19T13:54:11
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
    func convertDateFormat(_ date: String) -> String
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            print("date was \(date)")// 2021-11-19T08:24:40.363
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return  dateFormatter.string(from: newdate)
            print("newdate \(newdate)")
        }else {
            return ""
        }
    }
    

}
extension VRIAndOPILogsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countt = self.apiVRIOPICallLogResponseModel?.vRIOPIDASHBORD?.count ?? 0
        if countt == 0 {
            norecordLbl.isHidden = false
            callHistoryTV.isHidden = true
        }else {
            norecordLbl.isHidden = true
            callHistoryTV.isHidden = false
        }
        return countt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VRIAndOpiTableViewCell") as! VRIAndOpiTableViewCell
        let indx = self.apiVRIOPICallLogResponseModel?.vRIOPIDASHBORD?[indexPath.row]
        cell.sourceLanguageLbl.text = indx?.sourceLanguage ?? ""
        cell.targetLanguageLbl.text = indx?.languageName ?? ""
        cell.DurationLbl.text = indx?.duration ?? ""
        cell.roundedMinsLbl.text = indx?.roundedDuration ?? ""
        cell.billRateLbl.text = "$\(indx?.billRate ?? "")"
        cell.vendorNameLbl.text = indx?.vendorName ?? ""
        cell.roomNoLbl.text = indx?.roomNo ?? ""
        cell.refrenceLbl.text = indx?.caseNumber ?? "N/A"
        cell.totalLbl.text = "Total $\(indx?.totalRate ?? "")"
        let appointmentType = indx?.statustype ?? ""
        let description = indx?.decspt ?? false
        print("appointmentType : \(appointmentType) , description : \(description)")
        if appointmentType == "1" {
            if description {
                cell.appointmentTypeLbl.text = "OnDemand VRI"
            }else {
                cell.appointmentTypeLbl.text = "OnDemand OPI"
            }
        }else if appointmentType == "2" {
            if description {
                cell.appointmentTypeLbl.text = "Scheduled VRI"
            }else {
                cell.appointmentTypeLbl.text = "Scheduled OPI"
            }
        }else {
            
        }
        let startTime = indx?.startTime ?? ""
        let endTime = indx?.endTime ?? ""
        let dateA = indx?.datecreated ?? ""
        
        cell.startTimeLbl.text = convertTimeFormater(startTime)
        cell.endTimeLbl.text = convertTimeFormater(endTime)
        cell.dateLbl.text = convertDateFormat(dateA)
        return cell
    }
    
    
}


//extension Date {
//    func startOfMonth() -> Date {
//        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
//    }
//
//    func endOfMonth() -> Date {
//        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
//    }
//}



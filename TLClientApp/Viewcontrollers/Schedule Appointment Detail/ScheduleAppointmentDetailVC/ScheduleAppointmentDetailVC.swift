//
//  ScheduleAppointmentDetailVC.swift
//  TLClientApp
//
//  Created by Mac on 08/10/21.
//

import UIKit
import Alamofire

class ScheduleAppointmentDetailVC: UIViewController {

    var apiScheduleAppointmentResponseModel:ApiScheduleAppointmentResponseModel?
    
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var departmentView: UIView!
   
    
    @IBOutlet var authCodeLbl: UILabel!
   
    
    @IBOutlet weak var lblReference: UILabel!
    @IBOutlet var interpreterLbl: UILabel!
    
    var showAppointmentArr: ApiScheduleAppointmentCustomerDataModel?
    @IBOutlet var startDateLbl: UILabel!
    
    @IBOutlet var appointStatusHeadingLbl: UILabel!
    @IBOutlet var startTimeLbl: UILabel!
    
    
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var patientintialsLbl: UILabel!
    
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var addressLbl: UILabel!
 
    
    @IBOutlet var departmentLbl: UILabel!
    
    @IBOutlet var contactLbl: UILabel!
    
    @IBOutlet weak var specialNotesLbl: ActiveLabel!
    @IBOutlet weak var locationLbl: ActiveLabel!
    @IBOutlet var languageLbl: UILabel!
    
    @IBOutlet weak var venueNameView: UIStackView!
    @IBOutlet weak var venueAddressView: UIView!
    
    @IBOutlet var statusLbl: UILabel!
    
    //New added
    
    @IBOutlet weak var lblTextLocation: UILabel!
    @IBOutlet weak var lblTextNote: UILabel!
    @IBOutlet weak var lblClientPatientName: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
    
   
    
    @IBOutlet weak var lblServiceType: UILabel!
    //end
    var appointmentID = 0
    var apiAppointmentDetailResponseModel:ApiAppointmentDetailResponseModel?
    var ifComeFromNotification = false
    var apiCancelRequestResponseModel:ApiCancelRequestResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.getSelectedAppointmentData()
       // updateUI()
        // Do any additional setup after loading the view.
    }
    func updateUI(){
        let showAppointmentArr =  self.apiAppointmentDetailResponseModel?.appointmentCutomerData?.first
       
        getAppointmentStatus(appointmentType: (showAppointmentArr?.appointmentStatusType)!) { headingStr, statusStr, colorStr in
            self.appointStatusHeadingLbl.text = headingStr
            self.statusLbl.text =  statusStr
            self.appointStatusHeadingLbl.backgroundColor = hexStringToUIColor(hex: colorStr!)
            self.statusLbl.textColor = hexStringToUIColor(hex: colorStr!)
        }
        lblClientPatientName.text = (showAppointmentArr?.clientName != "" && showAppointmentArr?.clientName != nil) ? showAppointmentArr?.clientName : "N/A"
        lblServiceType.text = (showAppointmentArr?.specialityName != "" && showAppointmentArr?.specialityName != nil) ? showAppointmentArr?.specialityName : "N/A"
        lblServiceType.text = (showAppointmentArr?.appointmentType != nil && showAppointmentArr?.appointmentType != "") ? showAppointmentArr?.appointmentType : "N/A"
       
   specialNotesLbl.text =  (showAppointmentArr?.text != "" && showAppointmentArr?.text != nil ) ? showAppointmentArr?.text : "N/A"
            specialNotesLbl.handleURLTap { url in
                
                CEnumClass.share.activeLinkCall(activeURL: url)
            }
        
        
        locationLbl.text =  (showAppointmentArr?.location != "" && showAppointmentArr?.location != nil ) ? showAppointmentArr?.location : "N/A"
        locationLbl.handleURLTap { url in
            
            CEnumClass.share.activeLinkCall(activeURL: url)
        }
        

      
        lblReference.text = (showAppointmentArr?.caseNumber != "" && showAppointmentArr?.caseNumber != nil) ? showAppointmentArr?.caseNumber : "N/A"
        
       
       
        self.lblSpeciality.text = (showAppointmentArr?.displayValue != "" && showAppointmentArr?.displayValue != nil) ? showAppointmentArr?.displayValue : "N/A"
      
        
       
     
        if showAppointmentArr?.appointmentType == "Virtual Meeting"{
            lblTextNote.text = "Notes"
            lblTextLocation.text = "Virtual meeting Details links, ID and Pass codes"
           
            self.venueNameView.visibility = .gone
            self.venueAddressView.visibility = .gone

            self.departmentView.visibility = .gone
            self.contactView.visibility = .visible
        }
        else if showAppointmentArr?.appointmentType == "Telephone Conference" {
            lblTextNote.text = "Conference Call Details-Phone Number"
            lblTextLocation.text = "Details Links, ID and Pass Codes"
           
            self.venueNameView.visibility = .gone
            self.venueAddressView.visibility = .gone

            self.departmentView.visibility = .gone
            self.contactView.visibility = .visible
        }
        else {
            self.venueNameView.visibility = .visible
            self.venueAddressView.visibility = .visible
        
            self.departmentView.visibility = .visible
            self.contactView.visibility = .visible
        }
        if showAppointmentArr?.appointmentType == "Schedule OPI" || showAppointmentArr?.appointmentType == "Schedule VRI" {
            self.authCodeLbl.text = showAppointmentArr?.assignedByName
        }else {
            let str = showAppointmentArr?.authCode ?? "N/A"
            let components = str.components(separatedBy: " ")
            self.authCodeLbl.text = components[0]
            
        }
        
        self.languageLbl.text = showAppointmentArr?.languageName ?? "N/A"
        
        self.nameLbl.text = showAppointmentArr?.venueName ?? "N/A"
        let totalAddress = "\(showAppointmentArr?.address ?? "N/A"),\(showAppointmentArr?.city ?? ""),\(showAppointmentArr?.stateName ?? ""),\(showAppointmentArr?.zipcode ?? "")"
        print("total adddress \(totalAddress)")
        self.addressLbl.text =  totalAddress

        self.departmentLbl.text = showAppointmentArr?.departmentName ?? "N/A"

       
        self.contactLbl.text = showAppointmentArr?.providerName ?? "N/A"
       
       
        if showAppointmentArr?.cPIntials == "" {
            self.patientintialsLbl.text =  "N/A"
        }else {
            self.patientintialsLbl.text = showAppointmentArr?.cPIntials ?? "N/A"
        }
        
       // self.interpreterLbl.text = self.showAppointmentArr?.interpretorName ?? "N/A"
        let rawTime = showAppointmentArr?.startDateTime ?? ""
        let rawEndTime = showAppointmentArr?.endDateTime ?? ""
        let newTime = convertTimeFormater(rawTime)
        let newDate = convertDateFormater(rawTime)
        let newEndDate = convertTimeFormater(rawEndTime)
       
        
        self.startTimeLbl.text = "Arrive \(newTime) (\(userDefaults.string(forKey: "zoneShortForm")!)) - End \(newEndDate) (Estimated)"
        self.startDateLbl.text = newDate
       // self.endTimeLbl.text = newEndDate
         print("new tew \(newTime)")
        self.apiScheduleAppointmentResponseModel?.appointmentStatus?.forEach({ data in
            if showAppointmentArr?.appointmentStatusType == data.code {
              
                let statusColor = data.color ?? ""
                self.statusLbl.textColor = UIColor(hexString: statusColor )
                self.appointStatusHeadingLbl.backgroundColor = UIColor(hexString: statusColor )
            }
        })
        let cancelStatus = showAppointmentArr?.customerCancelRequest ?? nil
        print("appointment status id \(showAppointmentArr?.appointmentStatusID ?? "0")")
        let appointmentStatusID = showAppointmentArr?.appointmentStatusID ?? "0"
        if cancelStatus != nil && (cancelStatus == 0 || appointmentStatusID == "3" || appointmentStatusID == "5" || appointmentStatusID == "13" || appointmentStatusID == "7" || appointmentStatusID == "8" || appointmentStatusID == "4") {
        
            self.cancelBtn.isHidden = true
        
                
            
        }else{
            
            
            self.cancelBtn.isHidden = false
            
        }
        
        if showAppointmentArr?.appointmentType == "Schedule OPI" || showAppointmentArr?.appointmentType == "Schedule VRI" {
            self.interpreterLbl.attributedText = showAppointmentArr?.vendorName?.convertHtmlToAttributedStringWithCSS(font: UIFont.systemFont(ofSize: 10), csscolor: "black", lineheight: 5, csstextalign: "left")
        }else {
            
            self.interpreterLbl.text = (showAppointmentArr?.vendorName != "" && showAppointmentArr?.vendorName != nil) ? showAppointmentArr?.vendorName : "N/A"
            
        }
        
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        if ifComeFromNotification{
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func cancelRequestBtnTapped(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure that you want request for cancellation?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            self.hitApiCancelRequest()
           }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)

    }
    func getSelectedAppointmentData(){
        if Reachability.isConnectedToNetwork(){
        SwiftLoader.show(animated: true)
        let userId = GetPublicData.sharedInstance.userID
        let urlPostfix = "NotoficationId=0&AppointmentID=\(self.appointmentID)&flag=2&UserID=\(userId)"
        let urlPrefix = "\(APi.selectedAppointment.url)"
        let urlString = urlPrefix + urlPostfix
       
             print("url to create Appointment \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success get appointment data  ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiAppointmentDetailResponseModel = try jsonDecoder.decode(ApiAppointmentDetailResponseModel.self, from: daata)
                                print("Respose Success get appointment data  ",apiAppointmentDetailResponseModel)
                                   updateUI()
                                
                            } catch{
                                self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                                print("error block appointment Data " ,error)
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
    func hitApiCancelRequest(){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
        let userId = GetPublicData.sharedInstance.userID
        let urlPostfix = "AppointmentId=\(self.appointmentID)&CurrentUserId=\(userId)&UserType=Customer"
        let urlPrefix = "\(APi.cancelAppointmentRequest.url)"
        let urlString = urlPrefix + urlPostfix
       
             print("url to cancel Appointment \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success cancel request  ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiCancelRequestResponseModel = try jsonDecoder.decode(ApiCancelRequestResponseModel.self, from: daata)
                                let status = self.apiCancelRequestResponseModel?.cancelledData?.first?.success ?? 0
                                print(self.apiCancelRequestResponseModel?.cancelledData)
                                if status == 1 {
                                    print("Success")
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }else {
                                
                                    
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
    func convertDateFormater(_ date: String) -> String
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
        

    }
    func convertTimeFormater(_ date: String) -> String
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
}

extension String {
    var digits: String {
            return components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
        }
    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
        
        var htmlToString: String {
              return convertHtmlToNSAttributedString?.string ?? ""
          }
    }
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    
}

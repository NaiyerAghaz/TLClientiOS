//
//  HomeViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/14/21.
//

import UIKit
import FSCalendar
import Alamofire
import GoogleMaps
var userImageURl = ""
import SwiftPullToRefresh
class ScheduleAppointmentTableViewCell:UITableViewCell{
    
    @IBOutlet var statusOuterView: UIView!
    @IBOutlet var checkOutOuterView: UIView!
    @IBOutlet var startDateLbl: UILabel!
    @IBOutlet var customerName: UILabel!
    @IBOutlet var checkInLbl: UILabel!
    @IBOutlet var statusOfAppointmentLbl: UILabel!
    @IBOutlet var outerView: UIView!
    @IBOutlet var interpreterLbl: UILabel!
    @IBOutlet var typeOfMeetLbl: UILabel!
    @IBOutlet var venuLbl: UILabel!
    @IBOutlet var checkOutHeadingLbl: UILabel!
    @IBOutlet var clientNameLbl: UILabel!
    @IBOutlet var targetLanguageLbl: UILabel!
    @IBOutlet var sourceLanguageLbl: UILabel!
    @IBOutlet var appointmentTimeLbl: UILabel!
    @IBOutlet var appointmentIDLbl: UILabel!
    override func awakeFromNib() {
        outerView.addShadowGrey()
    }
}
class ScheduleMeetingTableViewCell:UITableViewCell{
    
    @IBOutlet var statusOuterView: UIView!
   
    @IBOutlet var startDateLbl: UILabel!
    
    @IBOutlet var checkInLbl: UILabel!
    @IBOutlet var statusOfAppointmentLbl: UILabel!
    @IBOutlet var outerView: UIView!
    @IBOutlet var interpreterLbl: UILabel!
   
    @IBOutlet weak var joinMeetBtn: UIButton!
    
    @IBOutlet var appointmentTimeLbl: UILabel!
    @IBOutlet var appointmentIDLbl: UILabel!
    override func awakeFromNib() {
        outerView.addShadowGrey()
    }
}
class HomeViewController: UIViewController,FSCalendarDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var tblCalenderView: UITableView!
    var navigator = Navigator()
    var loginVM = DetailsModal()
    var eventColor = [UIColor]()
    var currentUserGUID = ""
    var lattitude = "0.0"
    var longitude = "0.0"
    var apiGoogleTimeZoneresponse:ApiGoogleTimeZoneresponse?
    var apiUpdateDeviceTokenRespose : ApiUpdateDeviceTokenRespose?
    var apiLogoutResponseModel : ApiLogoutResponseModel?
    @IBOutlet var dashBoardTitleLbl: UILabel!
    var apiGetSpecialityDataModel :ApiGetSpecialityDataModel?
     var apiNotificationResponseModel:ApiNotificationResponseModel?
    var apiCheckCallStatusResponseModel = [ApiCheckCallStatusResponseModel]()
    @IBOutlet var notificationBtn: MIBadgeButton!
    var cLocationManager = CLLocationManager()
    var apiScheduleAppointmentResponseModel:ApiScheduleAppointmentResponseModel?
    var showAppointmentArr = [ApiScheduleAppointmentCustomerDataModel]()
    var apiCheckMeetSatusResponseModel = [ApiCheckMeetSatusResponseModel]()
    fileprivate weak var calendarObject: FSCalendar!
    @IBOutlet weak var calenderView: UIView!
    static func createWith(navigator: Navigator, storyboard: UIStoryboard,userModel: DetailsModal) -> HomeViewController {
        return storyboard.instantiateViewController(ofType: HomeViewController.self).then { viewController in
            viewController.loginVM = userModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCalenderView.spr_setIndicatorHeader { [weak self] in
                        self?.action()
                    }
        checkSingleSignin()
        getServiceType()
        getallweekDate()
        self.dashBoardTitleLbl.text = GetPublicData.sharedInstance.companyName
        GetPublicData.sharedInstance.getAllLanguage()
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToUploadImg(notification:)), name: Notification.Name("UpdateProfilePic"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.actionLogout(notification:)), name: Notification.Name("LogoutFunction"), object: nil)// LogoutFunction
        
    }
    
    @IBAction func actionVirtualMeeting(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "VirtualMeetingViewController" ) as! VirtualMeetingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func actionLogout(notification: Notification) {
        updateDeviceToken()
    }
    func hitApiGetNotificationCount(){
        SwiftLoader.show(animated: true)
        self.apiNotificationResponseModel = nil
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyID = GetPublicData.sharedInstance.companyID
        let urlPostFix = "UserID=\(userId)&methodType=NotificationsCounts&CompanyId=\(companyID)"
        let urlPrefix = "\(APi.getData.url)"
        let urlString = urlPrefix + urlPostFix
        print("url to get notificationCount  \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success Notification Count ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiNotificationResponseModel = try jsonDecoder.decode(ApiNotificationResponseModel.self, from: daata)
                               print("Success notification count ")
                                let count = self.apiNotificationResponseModel?.notificationsCounts?.first?.notificationCounts ?? ""
                                print("notification count\(count)" )
                                self.notificationBtn.badgeString = count
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                })
     }
    func action() {
            print("Data reload ")
            updateUI()
             hitApiGetNotificationCount()
            createCalendar()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tblCalenderView.spr_endRefreshing()
            }
        }
    @objc func moveToUploadImg(notification: Notification) {
        let vc = storyboard?.instantiateViewController(identifier: "UpdateProfilePicViewController") as! UpdateProfilePicViewController
    
           vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        print("UpdateProfilePicViewController")
    }
    override func viewWillAppear(_ animated: Bool) {
        tblCalenderView.spr_beginRefreshing()
        locAuthentication()
       // updateUI()
        //calenderView.removeFromSuperview()
       // createCalendar()
    }
    func locAuthentication(){
        cLocationManager.delegate = self
        cLocationManager.distanceFilter = 200
        cLocationManager.startUpdatingLocation()
        cLocationManager.requestAlwaysAuthorization()
        cLocationManager.requestWhenInUseAuthorization()
    }
    func getCurrentTimeZone(lattitude : String , longitude: String , timeStamp : String){
        let url = "https://maps.googleapis.com/maps/api/timezone/json?location=\(lattitude),\(longitude)&timestamp=\(timeStamp)&key=AIzaSyBs4BqawAAkN1ily7xcXUDeN7kruZ2BBI0"
        print("url to get time zone ", url )
        AF.request(url, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                
                case .success(_):
                    print("Respose getCurrentTimeZone ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGoogleTimeZoneresponse = try jsonDecoder.decode(ApiGoogleTimeZoneresponse.self, from: daata)
                        let status = self.apiGoogleTimeZoneresponse?.status ?? ""
                        if status == "OK" {
                            let timeConverter1 = DateFormatter()
                            timeConverter1.dateFormat = "MM/dd/yyyy"
                            let dateStr = timeConverter1.string(from: Date())
                            let timeZone = self.apiGoogleTimeZoneresponse?.timeZoneName ?? ""
                            print("current time zone from google", timeZone)
                            let previousTimeZone = userDefaults.string(forKey: "TimeZone") ?? ""
                            print("previous TimeZone ",previousTimeZone ?? "")
                            if previousTimeZone == timeZone {
                                
                            }else {
                                let vc = storyboard?.instantiateViewController(identifier: "TimeZoneViewController") as! TimeZoneViewController
                                vc.currentTimeZone = timeZone
                                vc.timeZoneStr = "Your timezone had appeared to change from \(dateStr) - \(previousTimeZone) to \(dateStr) - \(timeZone)."
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true, completion: nil)
                            }
                            
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       print("location running....")
        self.lattitude = "\(locations.last!.coordinate.latitude)"
        self.longitude = "\(locations.last!.coordinate.longitude)"
       // self.studioListModel.dataList?.removeAllObjects()
        
        //startLocation = locations.last!
        let timeStamp = Int(Date().timeIntervalSince1970)
        let timeStampString = "\(timeStamp)"
        self.getCurrentTimeZone(lattitude: self.lattitude, longitude: self.longitude, timeStamp: timeStampString)
      }
    func createCalendar(){
        //calenderView.removeFromSuperview()
        calenderView.subviews.forEach { (item) in
             item.removeFromSuperview()
        }
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        //calendar.removeFromSuperview()+
        calendar.placeholderType = .none
        //calendar.appearance.separators = .interRows
        calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        
        
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .blue
        calendar.today = Date()
        //calendar.currentPage = Date()
        calendar.setCurrentPage(Date(), animated: true)
        calendar.calendarHeaderView.backgroundColor = UIColor(hexString: "#33A5FF")
        calendar.appearance.headerMinimumDissolvedAlpha = (0.3)
        calendar.appearance.headerTitleColor = .white
        self.calendarObject = calendar
        calendar.scope = .month
      //  if calenderView.subviews.count == 0 {
            calenderView.addSubview(calendar)
        let FirstDate = Date()
        let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: FirstDate) as String? else { return }
        print("selected Date -->",result )
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let CustomerID = userDefaults.string(forKey: "CustomerID") ?? ""
        let userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        print("userId is \(userId) , cutomerId is \(CustomerID) , usertypeID is \(userTypeID)")
        self.hitApigetAllScheduleAppointment(date: result, customerId: userId, selectedDate: result)
    }
    func updateDeviceToken(){
        SwiftLoader.show(animated: true)
    
        //let userId = userDefaults.string(forKey: "userId") ?? ""
        //let companyId = userDefaults.string(forKey: "companyID") ?? ""
        
        let urlString = APi.addUpdateUserDeviceToken.url
        let fcmToken = userDefaults.string(forKey: "fcmToken") ?? ""
        let parameters = [
            "TokenID":fcmToken ,
               "Status":"Y",
               "UserID":GetPublicData.sharedInstance.userID,
               "DeviceType":"I",
               "voipToken":""
             ] as [String:Any]
        print("url to get schedule \(urlString),\(parameters)")
                AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success update device ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiUpdateDeviceTokenRespose = try jsonDecoder.decode(ApiUpdateDeviceTokenRespose.self, from: daata)
                                let status = self.apiUpdateDeviceTokenRespose?.table?.first?.success ?? 0
                                if status == 1 {
                                    print("Success update device token ")
                                    let userGUID = self.apiUpdateDeviceTokenRespose?.table?.first?.currentUserGuid ?? ""
                                    self.currentUserGUID = userGUID
                                    self.actionLogout(userGuid: userGUID)
                                    
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
    func checkSingleSignin(){
        SwiftLoader.show(animated: true)
        
        let urlString = APi.checkSingleUser.url
        let userID = GetPublicData.sharedInstance.userID
        let currentGUID = userDefaults.string(forKey: "userGUID") ?? ""
        let srchString = "<INFO><USERID>\(userID)</USERID><GUID>\(currentGUID)</GUID></INFO>"
        let parameters = [
            "strSearchString":srchString
             ] as [String:Any]
        print("url to get  checkSingleSignin \(urlString),\(parameters)")
                AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                    
                        case .success(_):
                            guard let daata = response.data else { return }
                            do {
                                print("check singel user response ",daata)
                                let jsonDecoder = JSONDecoder()
                                self.apiCheckCallStatusResponseModel = try jsonDecoder.decode([ApiCheckCallStatusResponseModel].self, from: daata)
                                print("Success getVendorIDs Model ",self.apiCheckCallStatusResponseModel.first?.result ?? "")
                                let str = self.apiCheckCallStatusResponseModel.first?.result ?? ""
                        
                                print("STRING DATA IS \(str)")
                                let data = str.data(using: .utf8)!
                                do {
    //
                                    print("DATAAA ISSS \(data)")
                                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                                    {

                                        let newjson = jsonArray.first
                                        let userInfo = newjson?["UserGuIdInfo"] as? [[String:Any]]
                                        
                                        let userIfo = userInfo?.first
                                        let vendorId = userIfo?["id"] as? Int
                                       print("vendorId ....",vendorId ?? 0)
                                        
                                        if vendorId == nil {
                                            // user is  login another device
                                            self.view.makeToast("This customer already logged-in on another device")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                self.updateDeviceToken()
                                            }
                                        }else {
                                          // user is not login on another device
                                            
                                        }
                                       
                                        
                                       
                                        
                                    } else {
                                        print("bad json")
                                    }
                                } catch let error as NSError {
                                    print(error)
                                }
                            
                            } catch{
                            
                                print("error block getVendorIDs Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure getVendorIDs ")
                            
                        }
                    })
     }
    func actionLogout(userGuid : String ){
        SwiftLoader.show(animated: true)
    
        //let userId = userDefaults.string(forKey: "userId") ?? ""
        //let companyId = userDefaults.string(forKey: "companyID") ?? ""
        
        let urlString = APi.changeLogoutStatus.url
        let fcmToken = userDefaults.string(forKey: "fcmToken") ?? ""
        let parameters = [
            "UserGuid": userGuid,
            "UserID": GetPublicData.sharedInstance.userID ?? ""
             ] as [String:Any]
        print("url to get schedule \(urlString),\(parameters)")
                AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success logout ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiLogoutResponseModel = try jsonDecoder.decode(ApiLogoutResponseModel.self, from: daata)
                                let status = self.apiLogoutResponseModel?.table?.first?.success ?? 0
                                if status == 1 {
                                    print("Success logout ")
                                    
                                    userDefaults.removeObject(forKey: "userId")
                                    
                                    
                                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let storyboard:UIStoryboard = UIStoryboard(name: Storyboard_name.login, bundle: nil)
                                    let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                    let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "InitialLoginVC") as! InitialLoginVC
                                    navigationController.viewControllers = [rootViewController]
                                    appDelegate.window!.rootViewController = navigationController
                                    appDelegate.window!.makeKeyAndVisible()
                                    
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
    @IBAction func telephoneConfrenceServiceBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "TelephoneConfrenceServiceViewController" ) as! TelephoneConfrenceServiceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func documentTranslationBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "DocumentTranslationViewController" ) as! DocumentTranslationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onsiteAppointmentBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "OnsiteInterpretationNewViewController" ) as! OnsiteInterpretationNewViewController
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = storyboard?.instantiateViewController(identifier: "OnSiteInterpretationAppointmentVC" ) as! OnSiteInterpretationAppointmentVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSideMenu(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "SideMenuViewController" ) as! SideMenuViewController
//        vc.modalPresentationStyle = .overCurrentContext
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.present(vc, animated: false, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTapped(_ sender: UIButton){
      print("Last button tapped ")
        if sender.tag == 3 {
            //navigator.show(segue: .vRIOPI, sender: self)
//            let pager = navigator.homeStoryBoard.instantiateViewController(identifier: "VRIOPIViewController") as! VRIOPIViewController
//            self.navigationController?.pushViewController(pager, animated: true)
            
//            if !(self.navigationController?.topViewController is VRIOPIViewController) {
//                print("MainSegue LoginViewController")
//                self.performSegue(withIdentifier: "VRIOPIViewController", sender: nil)
//            }
            let vc = storyboard?.instantiateViewController(identifier: "VRIOPIViewController") as! VRIOPIViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    @IBAction func actionNotification(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "NotificationViewController" ) as! NotificationViewController
        vc.modalPresentationStyle = .overCurrentContext
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
        
    }
    private func updateUI(){
        tblCalenderView.register(UINib(nibName: nibNamed.calendarTVCell, bundle: nil), forCellReuseIdentifier: HomeCellIdentifier.calendarTVCell.rawValue)
        tblCalenderView.delegate = self
        tblCalenderView.dataSource = self
        tblCalenderView.reloadData()
    }
    func hitApiCheckMeetingStatus(roomNo: String, callTime : String){
        self.apiCheckMeetSatusResponseModel.removeAll()
        let urlString = APi.getMeetingClientStatus.url
       
        let parameter = [
            "strSearchString":"<Info><ROOMNO>\(roomNo)</ROOMNO></Info>"
        ]
        print("url and parameter for getCreateVRICallVendor", urlString , parameter)
        AF.request(urlString, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { (response) in
                SwiftLoader.hide()
                switch(response.result){
                
                case .success(_):
                    
                    print("hitApiCheckMeetingStatus ")
                    guard let daata = response.data else { return }
                    print("response are ", response.data)
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiCheckMeetSatusResponseModel = try jsonDecoder.decode([ApiCheckMeetSatusResponseModel].self, from: daata)
                        let duration = self.apiCheckMeetSatusResponseModel.first?.resultData?.first?.dURATION ?? 0
                        print("check meet data ", self.apiCheckMeetSatusResponseModel)
                        let roomId = self.apiCheckMeetSatusResponseModel.first?.resultData?.first?.rOOMNO ?? ""
                        if duration < 1 {
                            //Move to VRI and OPI
                            //print("call started", callTime)
                            // check time of call
                            
                           // let isoDate = "2016-04-14T10:44:00+0000"
                            print("time of call before conversion ", callTime)
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                            dateFormatter1.dateFormat = "h:mm a"//"yyyy-MM-dd'T'HH:mm:ssZ"
                            let finalDate = dateFormatter1.date(from:callTime)!
                            
                            
                            
                            let calendar = Calendar.current
                            let timeBeforeCall = calendar.date(byAdding: .minute, value: -10, to: finalDate) ?? Date()
                            
                            print("date from string", finalDate , timeBeforeCall)
                            
                            
                            let dateFormatter = DateFormatter()
                             dateFormatter.dateFormat = "h:mm a"
                            let time10Before = dateFormatter.string(from: timeBeforeCall)
                           let currentTime =  dateFormatter.string(from: Date())
                            print("time for call ", callTime, currentTime , time10Before)
                           
                            
                            if time10Before > currentTime {
                                print("call not started , wait ")
                                let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
                                let vdoCall = sB.instantiateViewController(identifier: "VideoCallViewController") as! VideoCallViewController
                                vdoCall.ifComeFromMeet = true
                                vdoCall.ifTimereach = false
                                vdoCall.modalPresentationStyle = .overFullScreen
                                
                                self.present(vdoCall, animated: true, completion: nil)
                            }else {
                              print("call can start ")
                                
                                    print("VRI call start ")
                                    if roomId != "" {
                                        //self.addAppCall()
                                       // self.getCallPriorityVideoWithCompletion()
                                       // debugPrint("roomId:\(roomId),sourceID:\(sourceID),targetID:\(targetID),sourceName:\(sourceName),targetName:\(targetName)")
                                        let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
                                        let vdoCall = sB.instantiateViewController(identifier: "VideoCallViewController") as! VideoCallViewController
                                        vdoCall.roomID = roomId
                                        vdoCall.ifComeFromMeet = true
                                        vdoCall.ifTimereach = true
                                       // vdoCall.sourceLangID = sourceID
                                       // vdoCall.targetLangID = targetID
                                        vdoCall.isClientDetails = true
                                        vdoCall.isScheduled = false
                                       // vdoCall.sourceLangName = sourceName
                                        //vdoCall.targetLangName = targetName
                                        //vdoCall.patientno = txtPatientClientNumber.text ?? ""
                                       // vdoCall.patientname = txtPatientClientName.text ?? ""
                                        vdoCall.modalPresentationStyle = .overFullScreen
                                        
                                        self.present(vdoCall, animated: true, completion: nil)
                                    
                                    }
                                
                                
                            }
                        }else {
                            self.view.makeToast("Meeting is already Completed.")
                        }
                        
                    }catch (let error) {
                        print("error in do catch ", error.localizedDescription)
                    }

                case .failure(_):
                    print("Respose Failure hitApiCheckMeetingStatus ")
                   
                }
        })
        
    }
    func hitApigetAllScheduleAppointment(date:String ,customerId:String , selectedDate:String){
                            SwiftLoader.show(animated: true)
                                  /*  let headers: HTTPHeaders = [
                                        "Authorization": "Bearer \(UserDefaults.standard.value(forKey:"token") ?? "")",
                                               "cache-control": "no-cache"
                                           ]
                                   // print("😗---hitApiSignUpUser -" , Api.profile.url) 10/01/2021 */
                            let urlString = "https://lsp.totallanguage.com/Appointment/GetFormData?methodType=GETCUSTOMERSCHEDULEDATA&Customer=\(customerId)&UType=Customer&Date=\(date)"
                            print("url to get schedule \(urlString)")
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
                                                    self.apiScheduleAppointmentResponseModel = try jsonDecoder.decode(ApiScheduleAppointmentResponseModel.self, from: daata)
                                                   print("Success")
                                                    self.showAppointmentArr.removeAll()
                                                    self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA?.forEach({ appointmentData in
                                                        let rawDate = appointmentData.startDateTime ?? ""
                                                        let newDate = convertDateFormater(rawDate)
                                                        print("raw date is ",rawDate)
                                                        print("new date is ",newDate)
                                                        print("selected date is ",selectedDate)
                                                        if selectedDate == newDate {
                                                            self.showAppointmentArr.append(appointmentData)
                                                        }
                                                    })
                                                   
                                                    print("total appointment for \(selectedDate) are \(self.showAppointmentArr.count)")

                                                    tblCalenderView.reloadData()
                                                    calendarObject.reloadData()
                                                } catch{
                                                    
                                                    print("error block forgot password " ,error)
                                                }
                                            case .failure(_):
                                                print("Respose Failure ")
                                               
                                            }
                                    })
                         }
    func getServiceType(){
        SwiftLoader.show(animated: true)
        
        //Appointment/GetData?methodType=Speciality&CompanyId=55&SpType1=1
             let userId = userDefaults.string(forKey: "userId") ?? ""
              let companyId = userDefaults.string(forKey: "companyID") ?? ""
            let userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
            let urlPostFix = "&CompanyId=\(companyId)&SpType1=1"
              
            let urlString = "\(APi.speciality.url)" + urlPostFix
        print("url for service  \(urlString)")
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
                                self.apiGetSpecialityDataModel = try jsonDecoder.decode(ApiGetSpecialityDataModel.self, from: daata)
                               print("Success")
                                GetPublicData.sharedInstance.apiGetSpecialityDataModel = self.apiGetSpecialityDataModel
                                
                                
                                
                                GetPublicData.sharedInstance.apic.removeAll()
                                self.apiGetSpecialityDataModel?.appointmentType?.forEach({ (abc) in
                                    GetPublicData.sharedInstance.apic.append(abc)
                                })
                                print("count for appointment data \(GetPublicData.sharedInstance.apic.count)")
                                
                                
                                
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure service ")
                           
                        }
                })
     }
    func convertDateAndTimeFormat(_ date: String) -> String
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
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

extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell  = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifier.calendarTVCell.rawValue, for: indexPath) as! CalendarTVCell
        let index = showAppointmentArr[indexPath.row]
        let statustype = index.appointmentStatusType ?? ""
        print("statsu type \(statustype)")
        if statustype == "Meeting" {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ScheduleMeetingTableViewCell", for: indexPath) as! ScheduleMeetingTableViewCell
            let dateValue = index.startDateTime ?? ""
            let timeValue = convertDateFormater(dateValue)
            cell.startDateLbl.text = timeValue
            cell.checkInLbl.text = index.vendorName ?? ""
            cell.interpreterLbl.text = convertTimeFormater(dateValue)
            cell.statusOfAppointmentLbl.text = index.appointmentStatusType ?? ""
            let rawTime = index.startDateTime ?? ""
            let newTime = convertTimeFormater(rawTime)
            cell.appointmentTimeLbl.text = newTime
            if index.appointmentType == "Schedule OPI" || index.appointmentType == "Schedule VRI" {
                cell.appointmentIDLbl.text = index.assignedByName
            }else {
                let str = index.authCode ?? ""
                let components = str.components(separatedBy: " ")
                cell.appointmentIDLbl.text = components[0]
            }
            cell.joinMeetBtn.tag = indexPath.row
            cell.joinMeetBtn.addTarget(self, action: #selector(actionJoinMeet), for: .touchUpInside)
            return cell
        }else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ScheduleAppointmentTableViewCell", for: indexPath) as! ScheduleAppointmentTableViewCell
            
            cell.targetLanguageLbl.text = index.languageName ?? ""
            cell.venuLbl.text = index.venueName ?? ""
            cell.typeOfMeetLbl.text = index.appointmentType ?? ""
            cell.clientNameLbl.text = index.clientName ?? ""
            cell.customerName.text = index.customerName ?? ""
           // cell.interpreterLbl.text = index.interpretorName
            cell.sourceLanguageLbl.text = ""
            cell.statusOfAppointmentLbl.text = index.appointmentStatusType ?? ""
            let dateValue = index.startDateTime ?? ""
            let timeValue = convertDateAndTimeFormat(dateValue)
            cell.startDateLbl.text = timeValue
            self.apiScheduleAppointmentResponseModel?.appointmentStatus?.forEach({ statusDetail in
                if statusDetail.code == index.appointmentStatusType {
                    //cell.statusOuterView.backgroundColor = UIColor(hexString: statusDetail.color!)
                   cell.statusOfAppointmentLbl.backgroundColor = UIColor(hexString: statusDetail.color!)
                }else if index.appointmentStatusType == "Meeting"{
                    cell.statusOfAppointmentLbl.backgroundColor = .clear
                }
            })
            
            let checkInStatus = index.checkIn ?? 0
            let checkOutStatus = index.checkOut  ?? 0
            let statusType = index.appointmentStatusType ?? ""
            print("stsus of appointment  \(statusType) ,\(checkInStatus) , \(checkOutStatus)")
            if statusType == "BOOKED"{
                if checkInStatus == 1  && checkOutStatus == 0 {
                   cell.checkInLbl.isHidden = false
                   cell.checkOutHeadingLbl.isHidden = false
                   cell.checkInLbl.text = "Checked In"
               }else if checkInStatus == 1  && checkOutStatus == 1 {
                   cell.checkInLbl.isHidden = false
                   cell.checkOutHeadingLbl.isHidden = false
                   cell.checkInLbl.text = "Checked Out"
               }else {
                   cell.checkInLbl.isHidden = true
                   cell.checkOutHeadingLbl.isHidden = true
               }
            }else{
                cell.checkInLbl.isHidden = true
                cell.checkOutHeadingLbl.isHidden = true
            }
             
            let rawTime = index.startDateTime ?? ""
            let newTime = convertTimeFormater(rawTime)
            cell.appointmentTimeLbl.text = newTime
            if index.appointmentType == "Schedule OPI" || index.appointmentType == "Schedule VRI" {
                cell.appointmentIDLbl.text = index.assignedByName
                let interpretorname  = index.interpretorName?.replacingOccurrences(of: "fffb4a", with: "000000")
                
                cell.interpreterLbl.attributedText = interpretorname?.convertHtmlToAttributedStringWithCSS(font: UIFont.systemFont(ofSize: 12), csscolor: "black", lineheight: 5, csstextalign: "left")
                cell.interpreterLbl.textColor = UIColor.black
            }else {
                let str = index.authCode ?? ""
                let components = str.components(separatedBy: " ")
                cell.appointmentIDLbl.text = components[0]
                cell.interpreterLbl.text = index.interpretorName ?? "N/A"
            }
            
            
            return cell
        }
       
    }
    @objc func actionJoinMeet(_ sender: UIButton){
        print("sendervalue ",self.showAppointmentArr[sender.tag])
        let timeOfcall = self.showAppointmentArr[sender.tag].startDateTime ?? ""
      //  let rawTime = index.startDateTime ?? ""
        let newTime = convertTimeFormater(timeOfcall)
        let roomNo = self.showAppointmentArr[sender.tag].authCode ?? ""
        self.hitApiCheckMeetingStatus(roomNo: roomNo, callTime: newTime)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let typeid = self.showAppointmentArr[indexPath.row].appointmentTypeID ?? 0
        if typeid != 12 {
            let vc = self.storyboard?.instantiateViewController(identifier: "ScheduleAppointmentDetailVC") as! ScheduleAppointmentDetailVC
            vc.showAppointmentArr = self.showAppointmentArr[indexPath.row]
            vc.appointmentID = self.showAppointmentArr[indexPath.row].appointmentID ?? 0
            vc.apiScheduleAppointmentResponseModel = self.apiScheduleAppointmentResponseModel ?? ApiScheduleAppointmentResponseModel()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showAppointmentArr.count  ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //240
    }
}


extension HomeViewController :FSCalendarDataSource ,FSCalendarDelegateAppearance  {
   
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            print("changed")
            let maxDate = calendar.currentPage
            // Create Date Formatter
            let dateFormatter = DateFormatter()
            // Set Date Format
            dateFormatter.dateFormat = "MM/dd/yyyy"
            // Convert Date to String
            let endDate = dateFormatter.string(from: maxDate)
           // self.hitApiGetWeeklyJournals(dateStr: endDate, calender: calendar )
            print("Week end date \(endDate) is")
       // let FirstDate = date.startOfMonth() ?? Date()
        let userId = userDefaults.string(forKey: "userId") ?? ""
        print("userId is \(userId)")
        
        self.hitApigetAllScheduleAppointment(date: endDate, customerId: userId, selectedDate: endDate)
          
    }
    
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: date) as String? else { return UIImage(named: "")}
        var eventCount = 0
        print("count of appointment \(self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA?.count ?? 0) for date \(result)")
        for scheduleAppointment in (self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA ?? [ApiScheduleAppointmentCustomerDataModel]())! {
            let rawDate = scheduleAppointment.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
            print("new date is in number of event\(newDate)")
            print("result date is in number of event  \(result)")
            if newDate == result {
                eventCount = eventCount + 1
                print("event count \(eventCount)")
                
            }
        }
        if eventCount > 3 {
            return UIImage(named: "addTest")
        }else {
            return UIImage(named: "")
        }

//        return UIImage(named: "addTest")
        
        
    }
    
    
    
    
    
    func getallweekDate (){
        let dateInWeek = Date()//7th June 2017

        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: dateInWeek)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: dateInWeek)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: dateInWeek) }

        print("dates of week are ", days)
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: date) as String? else { return nil }
        eventColor.removeAll()
        self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA?.forEach({ appointmentData in
            let rawDate = appointmentData.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
            print("new date is in number of event\(newDate)")
            print("result date is in number of event  \(result)")
            if newDate == result {
                self.apiScheduleAppointmentResponseModel?.appointmentStatus?.forEach({ appointmentStatusData in
                    if  appointmentStatusData.code  == appointmentData.appointmentStatusType
                    {
                        
                        let statusColor = appointmentStatusData.color ?? ""
                        eventColor.append(UIColor(hexString: statusColor))
                    }
                })
            }
        
        })
           
            print("eventDefaultColorsFor")
        if eventColor.count == 0 {
            return nil
            
        }else {
            return eventColor //[UIColor.green , UIColor.red]
        }
      
        }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let FirstDate = date.startOfMonth() ?? Date()
        let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: FirstDate) as String? else { return }
        guard let selectedDate : String = formatter.string(from: date) as String? else { return }
                   print("selected Date -->",result )
        let userId = userDefaults.string(forKey: "userId") ?? ""
        print("userId is \(userId)")
        
        self.hitApigetAllScheduleAppointment(date: result, customerId: userId, selectedDate: selectedDate)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: -5)
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: date) as String? else { return 0}
        var eventCount = 0
        print("count of appointment \(self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA?.count)")
        for scheduleAppointment in (self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA ?? [ApiScheduleAppointmentCustomerDataModel]())! {
            let rawDate = scheduleAppointment.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
            print("new date is in number of event\(newDate)")
            print("result date is in number of event  \(result)")
            if newDate == result {
                eventCount = eventCount + 1
                print("event count \(eventCount)")
                
            }
        }
        return eventCount
    }
}

extension Date {
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }

    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
    func nearestHour() -> Date? {
            var components = NSCalendar.current.dateComponents([.minute], from: self)
            let minute = components.minute ?? 0
            components.minute = minute >= 30 ? 60 - minute : -minute
            return Calendar.current.date(byAdding: components, to: self)
    }
}



/*struct ApiNotificationResponseModel : Codable {
    let notificationsCounts : [ApiNotificationsCountsResponseData]?

    enum CodingKeys: String, CodingKey {

        case notificationsCounts = "NotificationsCounts"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notificationsCounts = try values.decodeIfPresent([ApiNotificationsCountsResponseData].self, forKey: .notificationsCounts)
    }

}


struct ApiNotificationsCountsResponseData : Codable {
    let success : String?
    let message : String?
    let businessID : Int?
    let customChecklistID : Int?
    let interpreterID : Int?
    let checklistName : Int?
    let checklistType : Int?
    let createDate : String?
    let interpreterCheckList : String?
    let userID : String?
    let isResume : String?
    let resumeFile : String?
    let isMedical : String?
    let isLegal : String?
    let isGeneral : String?
    let isOther : String?
    let isVRI : String?
    let medicalFile : String?
    let legalFile : String?
    let generalFile : String?
    let otherFile : String?
    let vriFile : String?
    let medicalYear : String?
    let legalYear : String?
    let generalYear : String?
    let otherYear : String?
    let vriYear : String?
    let medicalState : String?
    let legalState : String?
    let generalState : String?
    let vriState : String?
    let otherState : String?
    let medicalDOC : String?
    let legalDOC : String?
    let generalDOC : String?
    let otherDOC : String?
    let vriDOC : String?
    let medicalHours : String?
    let legalHours : String?
    let generalHours : String?
    let otherHours : String?
    let vriHours : String?
    let hIPPAFile : String?
    let cORIFile : String?
    let sFFile : String?
    let cAFile : String?
    let w9File : String?
    let pPFile : String?
    let photoFile : String?
    let cOAFile : String?
    let isResumeNotification : String?
    let isMedicalNotification : String?
    let isLegalNotification : String?
    let isGeneralNotification : String?
    let isOtherNotification : String?
    let isHIPPANotification : String?
    let isCORINotification : String?
    let isSFNotification : String?
    let isCANotification : String?
    let isW9Notification : String?
    let isPPNotification : String?
    let isPhotoNotification : String?
    let isCOANotification : String?
    let isVriNotification : String?
    let notification : String?
    let notificationType : String?
    let notificationCounts : String?
    let flga : String?
    let type : String?
    let appointmentID : String?
    let notoficationId : String?
    let notificationRed : Bool?
    let redornot : Bool?
    let interpreterBookedName : String?
    let fromEmail : String?
    let vendorEmail : String?
    let userFullName : String?
    let senderID : String?
    let createUser : String?
    let fileName : String?
    let filePath : String?
    let medState : String?
    let legState : String?
    let oState : String?
    let genState : String?
    let userType : String?
    let appStatus : String?
    let subStatus : String?
    let phoneNumber : String?
    let decspt : Bool?
    let sSN : String?
    let fileType : String?
    let companyName : String?
    let displayValue : String?
    let languageName : String?
    let gender : String?
    let groupName : String?
    let groupID : String?
    let vendorStateName : String?
    let badgeNumber : String?
    let city : String?
    let isPerdim : String?
    let isContarctor1099 : String?
    let isEmployee : String?
    let is3rdParty : String?
    let active : String?
    let firstName : String?
    let middleNameIntital : String?
    let lastName : String?
    let previousLastName : String?
    let nickName : String?
    let vendorFee : String?
    let dOB : String?
    let zipCode : String?
    let streetAddress : String?
    let totalMedicalHours : String?
    let totalLegalHours : String?
    let totalGeneralHours : String?
    let totalOtherHours : String?
    let totalVriHours : String?
    let signatureDate : String?
    let checklistFileID : String?
    let expiredDate : String?
    let appointmentType : String?
    let isDPSI : String?
    let isUKBased : String?
    let isSCClearance : String?
    let isESCClearance : String?
    let isCTClearance : String?
    let isNPPV3Clearance : String?
    let isNRPSIMembership : String?
    let isITIMembership : String?
    let isCIOLMembership : String?
    let dPSIFile : String?
    let uKBasedFile : String?
    let sCClearanceFile : String?
    let eSCClearanceFile : String?
    let cTClearanceFile : String?
    let nPPV3ClearanceFile : String?
    let nRPSIMembershipFile : String?
    let iTIMembershipFile : String?
    let cIOLMembershipFile : String?
    let dPSIDOC : String?
    let uKBasedDOC : String?
    let sCClearanceDOC : String?
    let eSCClearanceDOC : String?
    let cTClearanceDOC : String?
    let nPPV3ClearanceDOC : String?
    let nRPSIMembershipDOC : String?
    let iTIMembershipDOC : String?
    let cIOLMembershipDOC : String?
    let spokenLevel1 : String?
    let spokenLevel2 : String?
    let spokenLevel3 : String?
    let spokenLevel4 : String?
    let spokenLevel5 : String?
    let signLevel1 : String?
    let signLevel2 : String?
    let signLevel3 : String?
    let signLevel4 : String?
    let signLevel5 : String?
    let interpreterFileList : String?
    let screeningFormFile : String?
    let hepBFile : String?
    let mMRFile : String?
    let covidFile : String?
    let fluFile : String?
    let pPDFile : String?
    let tdapFile : String?
    let varicellaFile : String?
    let orientation : String?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case message = "message"
        case businessID = "BusinessID"
        case customChecklistID = "CustomChecklistID"
        case interpreterID = "InterpreterID"
        case checklistName = "ChecklistName"
        case checklistType = "ChecklistType"
        case createDate = "CreateDate"
        case interpreterCheckList = "InterpreterCheckList"
        case userID = "UserID"
        case isResume = "IsResume"
        case resumeFile = "ResumeFile"
        case isMedical = "IsMedical"
        case isLegal = "IsLegal"
        case isGeneral = "IsGeneral"
        case isOther = "IsOther"
        case isVRI = "IsVRI"
        case medicalFile = "MedicalFile"
        case legalFile = "LegalFile"
        case generalFile = "GeneralFile"
        case otherFile = "OtherFile"
        case vriFile = "VriFile"
        case medicalYear = "MedicalYear"
        case legalYear = "LegalYear"
        case generalYear = "GeneralYear"
        case otherYear = "OtherYear"
        case vriYear = "VriYear"
        case medicalState = "MedicalState"
        case legalState = "LegalState"
        case generalState = "GeneralState"
        case vriState = "VriState"
        case otherState = "OtherState"
        case medicalDOC = "MedicalDOC"
        case legalDOC = "LegalDOC"
        case generalDOC = "GeneralDOC"
        case otherDOC = "OtherDOC"
        case vriDOC = "VriDOC"
        case medicalHours = "MedicalHours"
        case legalHours = "LegalHours"
        case generalHours = "GeneralHours"
        case otherHours = "OtherHours"
        case vriHours = "VriHours"
        case hIPPAFile = "HIPPAFile"
        case cORIFile = "CORIFile"
        case sFFile = "SFFile"
        case cAFile = "CAFile"
        case w9File = "W9File"
        case pPFile = "PPFile"
        case photoFile = "PhotoFile"
        case cOAFile = "COAFile"
        case isResumeNotification = "IsResumeNotification"
        case isMedicalNotification = "IsMedicalNotification"
        case isLegalNotification = "IsLegalNotification"
        case isGeneralNotification = "IsGeneralNotification"
        case isOtherNotification = "IsOtherNotification"
        case isHIPPANotification = "IsHIPPANotification"
        case isCORINotification = "IsCORINotification"
        case isSFNotification = "IsSFNotification"
        case isCANotification = "IsCANotification"
        case isW9Notification = "IsW9Notification"
        case isPPNotification = "IsPPNotification"
        case isPhotoNotification = "IsPhotoNotification"
        case isCOANotification = "IsCOANotification"
        case isVriNotification = "IsVriNotification"
        case notification = "Notification"
        case notificationType = "NotificationType"
        case notificationCounts = "NotificationCounts"
        case flga = "flga"
        case type = "Type"
        case appointmentID = "AppointmentID"
        case notoficationId = "NotoficationId"
        case notificationRed = "notificationRed"
        case redornot = "redornot"
        case interpreterBookedName = "InterpreterBookedName"
        case fromEmail = "FromEmail"
        case vendorEmail = "VendorEmail"
        case userFullName = "UserFullName"
        case senderID = "SenderID"
        case createUser = "CreateUser"
        case fileName = "FileName"
        case filePath = "FilePath"
        case medState = "MedState"
        case legState = "LegState"
        case oState = "OState"
        case genState = "GenState"
        case userType = "UserType"
        case appStatus = "AppStatus"
        case subStatus = "SubStatus"
        case phoneNumber = "PhoneNumber"
        case decspt = "decspt"
        case sSN = "SSN"
        case fileType = "FileType"
        case companyName = "CompanyName"
        case displayValue = "DisplayValue"
        case languageName = "LanguageName"
        case gender = "Gender"
        case groupName = "GroupName"
        case groupID = "GroupID"
        case vendorStateName = "VendorStateName"
        case badgeNumber = "BadgeNumber"
        case city = "City"
        case isPerdim = "IsPerdim"
        case isContarctor1099 = "isContarctor1099"
        case isEmployee = "IsEmployee"
        case is3rdParty = "Is3rdParty"
        case active = "Active"
        case firstName = "FirstName"
        case middleNameIntital = "MiddleNameIntital"
        case lastName = "LastName"
        case previousLastName = "PreviousLastName"
        case nickName = "NickName"
        case vendorFee = "VendorFee"
        case dOB = "DOB"
        case zipCode = "ZipCode"
        case streetAddress = "StreetAddress"
        case totalMedicalHours = "TotalMedicalHours"
        case totalLegalHours = "TotalLegalHours"
        case totalGeneralHours = "TotalGeneralHours"
        case totalOtherHours = "TotalOtherHours"
        case totalVriHours = "TotalVriHours"
        case signatureDate = "signatureDate"
        case checklistFileID = "checklistFileID"
        case expiredDate = "expiredDate"
        case appointmentType = "AppointmentType"
        case isDPSI = "IsDPSI"
        case isUKBased = "IsUKBased"
        case isSCClearance = "IsSCClearance"
        case isESCClearance = "IsESCClearance"
        case isCTClearance = "IsCTClearance"
        case isNPPV3Clearance = "IsNPPV3Clearance"
        case isNRPSIMembership = "IsNRPSIMembership"
        case isITIMembership = "IsITIMembership"
        case isCIOLMembership = "IsCIOLMembership"
        case dPSIFile = "DPSIFile"
        case uKBasedFile = "UKBasedFile"
        case sCClearanceFile = "SCClearanceFile"
        case eSCClearanceFile = "ESCClearanceFile"
        case cTClearanceFile = "CTClearanceFile"
        case nPPV3ClearanceFile = "NPPV3ClearanceFile"
        case nRPSIMembershipFile = "NRPSIMembershipFile"
        case iTIMembershipFile = "ITIMembershipFile"
        case cIOLMembershipFile = "CIOLMembershipFile"
        case dPSIDOC = "DPSIDOC"
        case uKBasedDOC = "UKBasedDOC"
        case sCClearanceDOC = "SCClearanceDOC"
        case eSCClearanceDOC = "ESCClearanceDOC"
        case cTClearanceDOC = "CTClearanceDOC"
        case nPPV3ClearanceDOC = "NPPV3ClearanceDOC"
        case nRPSIMembershipDOC = "NRPSIMembershipDOC"
        case iTIMembershipDOC = "ITIMembershipDOC"
        case cIOLMembershipDOC = "CIOLMembershipDOC"
        case spokenLevel1 = "SpokenLevel1"
        case spokenLevel2 = "SpokenLevel2"
        case spokenLevel3 = "SpokenLevel3"
        case spokenLevel4 = "SpokenLevel4"
        case spokenLevel5 = "SpokenLevel5"
        case signLevel1 = "SignLevel1"
        case signLevel2 = "SignLevel2"
        case signLevel3 = "SignLevel3"
        case signLevel4 = "SignLevel4"
        case signLevel5 = "SignLevel5"
        case interpreterFileList = "InterpreterFileList"
        case screeningFormFile = "ScreeningFormFile"
        case hepBFile = "HepBFile"
        case mMRFile = "MMRFile"
        case covidFile = "CovidFile"
        case fluFile = "FluFile"
        case pPDFile = "PPDFile"
        case tdapFile = "TdapFile"
        case varicellaFile = "VaricellaFile"
        case orientation = "Orientation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        businessID = try values.decodeIfPresent(Int.self, forKey: .businessID)
        customChecklistID = try values.decodeIfPresent(Int.self, forKey: .customChecklistID)
        interpreterID = try values.decodeIfPresent(Int.self, forKey: .interpreterID)
        checklistName = try values.decodeIfPresent(Int.self, forKey: .checklistName)
        checklistType = try values.decodeIfPresent(Int.self, forKey: .checklistType)
        createDate = try values.decodeIfPresent(String.self, forKey: .createDate)
        interpreterCheckList = try values.decodeIfPresent(String.self, forKey: .interpreterCheckList)
        userID = try values.decodeIfPresent(String.self, forKey: .userID)
        isResume = try values.decodeIfPresent(String.self, forKey: .isResume)
        resumeFile = try values.decodeIfPresent(String.self, forKey: .resumeFile)
        isMedical = try values.decodeIfPresent(String.self, forKey: .isMedical)
        isLegal = try values.decodeIfPresent(String.self, forKey: .isLegal)
        isGeneral = try values.decodeIfPresent(String.self, forKey: .isGeneral)
        isOther = try values.decodeIfPresent(String.self, forKey: .isOther)
        isVRI = try values.decodeIfPresent(String.self, forKey: .isVRI)
        medicalFile = try values.decodeIfPresent(String.self, forKey: .medicalFile)
        legalFile = try values.decodeIfPresent(String.self, forKey: .legalFile)
        generalFile = try values.decodeIfPresent(String.self, forKey: .generalFile)
        otherFile = try values.decodeIfPresent(String.self, forKey: .otherFile)
        vriFile = try values.decodeIfPresent(String.self, forKey: .vriFile)
        medicalYear = try values.decodeIfPresent(String.self, forKey: .medicalYear)
        legalYear = try values.decodeIfPresent(String.self, forKey: .legalYear)
        generalYear = try values.decodeIfPresent(String.self, forKey: .generalYear)
        otherYear = try values.decodeIfPresent(String.self, forKey: .otherYear)
        vriYear = try values.decodeIfPresent(String.self, forKey: .vriYear)
        medicalState = try values.decodeIfPresent(String.self, forKey: .medicalState)
        legalState = try values.decodeIfPresent(String.self, forKey: .legalState)
        generalState = try values.decodeIfPresent(String.self, forKey: .generalState)
        vriState = try values.decodeIfPresent(String.self, forKey: .vriState)
        otherState = try values.decodeIfPresent(String.self, forKey: .otherState)
        medicalDOC = try values.decodeIfPresent(String.self, forKey: .medicalDOC)
        legalDOC = try values.decodeIfPresent(String.self, forKey: .legalDOC)
        generalDOC = try values.decodeIfPresent(String.self, forKey: .generalDOC)
        otherDOC = try values.decodeIfPresent(String.self, forKey: .otherDOC)
        vriDOC = try values.decodeIfPresent(String.self, forKey: .vriDOC)
        medicalHours = try values.decodeIfPresent(String.self, forKey: .medicalHours)
        legalHours = try values.decodeIfPresent(String.self, forKey: .legalHours)
        generalHours = try values.decodeIfPresent(String.self, forKey: .generalHours)
        otherHours = try values.decodeIfPresent(String.self, forKey: .otherHours)
        vriHours = try values.decodeIfPresent(String.self, forKey: .vriHours)
        hIPPAFile = try values.decodeIfPresent(String.self, forKey: .hIPPAFile)
        cORIFile = try values.decodeIfPresent(String.self, forKey: .cORIFile)
        sFFile = try values.decodeIfPresent(String.self, forKey: .sFFile)
        cAFile = try values.decodeIfPresent(String.self, forKey: .cAFile)
        w9File = try values.decodeIfPresent(String.self, forKey: .w9File)
        pPFile = try values.decodeIfPresent(String.self, forKey: .pPFile)
        photoFile = try values.decodeIfPresent(String.self, forKey: .photoFile)
        cOAFile = try values.decodeIfPresent(String.self, forKey: .cOAFile)
        isResumeNotification = try values.decodeIfPresent(String.self, forKey: .isResumeNotification)
        isMedicalNotification = try values.decodeIfPresent(String.self, forKey: .isMedicalNotification)
        isLegalNotification = try values.decodeIfPresent(String.self, forKey: .isLegalNotification)
        isGeneralNotification = try values.decodeIfPresent(String.self, forKey: .isGeneralNotification)
        isOtherNotification = try values.decodeIfPresent(String.self, forKey: .isOtherNotification)
        isHIPPANotification = try values.decodeIfPresent(String.self, forKey: .isHIPPANotification)
        isCORINotification = try values.decodeIfPresent(String.self, forKey: .isCORINotification)
        isSFNotification = try values.decodeIfPresent(String.self, forKey: .isSFNotification)
        isCANotification = try values.decodeIfPresent(String.self, forKey: .isCANotification)
        isW9Notification = try values.decodeIfPresent(String.self, forKey: .isW9Notification)
        isPPNotification = try values.decodeIfPresent(String.self, forKey: .isPPNotification)
        isPhotoNotification = try values.decodeIfPresent(String.self, forKey: .isPhotoNotification)
        isCOANotification = try values.decodeIfPresent(String.self, forKey: .isCOANotification)
        isVriNotification = try values.decodeIfPresent(String.self, forKey: .isVriNotification)
        notification = try values.decodeIfPresent(String.self, forKey: .notification)
        notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
        notificationCounts = try values.decodeIfPresent(String.self, forKey: .notificationCounts)
        flga = try values.decodeIfPresent(String.self, forKey: .flga)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        appointmentID = try values.decodeIfPresent(String.self, forKey: .appointmentID)
        notoficationId = try values.decodeIfPresent(String.self, forKey: .notoficationId)
        notificationRed = try values.decodeIfPresent(Bool.self, forKey: .notificationRed)
        redornot = try values.decodeIfPresent(Bool.self, forKey: .redornot)
        interpreterBookedName = try values.decodeIfPresent(String.self, forKey: .interpreterBookedName)
        fromEmail = try values.decodeIfPresent(String.self, forKey: .fromEmail)
        vendorEmail = try values.decodeIfPresent(String.self, forKey: .vendorEmail)
        userFullName = try values.decodeIfPresent(String.self, forKey: .userFullName)
        senderID = try values.decodeIfPresent(String.self, forKey: .senderID)
        createUser = try values.decodeIfPresent(String.self, forKey: .createUser)
        fileName = try values.decodeIfPresent(String.self, forKey: .fileName)
        filePath = try values.decodeIfPresent(String.self, forKey: .filePath)
        medState = try values.decodeIfPresent(String.self, forKey: .medState)
        legState = try values.decodeIfPresent(String.self, forKey: .legState)
        oState = try values.decodeIfPresent(String.self, forKey: .oState)
        genState = try values.decodeIfPresent(String.self, forKey: .genState)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        appStatus = try values.decodeIfPresent(String.self, forKey: .appStatus)
        subStatus = try values.decodeIfPresent(String.self, forKey: .subStatus)
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        decspt = try values.decodeIfPresent(Bool.self, forKey: .decspt)
        sSN = try values.decodeIfPresent(String.self, forKey: .sSN)
        fileType = try values.decodeIfPresent(String.self, forKey: .fileType)
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
        displayValue = try values.decodeIfPresent(String.self, forKey: .displayValue)
        languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        groupName = try values.decodeIfPresent(String.self, forKey: .groupName)
        groupID = try values.decodeIfPresent(String.self, forKey: .groupID)
        vendorStateName = try values.decodeIfPresent(String.self, forKey: .vendorStateName)
        badgeNumber = try values.decodeIfPresent(String.self, forKey: .badgeNumber)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        isPerdim = try values.decodeIfPresent(String.self, forKey: .isPerdim)
        isContarctor1099 = try values.decodeIfPresent(String.self, forKey: .isContarctor1099)
        isEmployee = try values.decodeIfPresent(String.self, forKey: .isEmployee)
        is3rdParty = try values.decodeIfPresent(String.self, forKey: .is3rdParty)
        active = try values.decodeIfPresent(String.self, forKey: .active)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        middleNameIntital = try values.decodeIfPresent(String.self, forKey: .middleNameIntital)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        previousLastName = try values.decodeIfPresent(String.self, forKey: .previousLastName)
        nickName = try values.decodeIfPresent(String.self, forKey: .nickName)
        vendorFee = try values.decodeIfPresent(String.self, forKey: .vendorFee)
        dOB = try values.decodeIfPresent(String.self, forKey: .dOB)
        zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
        streetAddress = try values.decodeIfPresent(String.self, forKey: .streetAddress)
        totalMedicalHours = try values.decodeIfPresent(String.self, forKey: .totalMedicalHours)
        totalLegalHours = try values.decodeIfPresent(String.self, forKey: .totalLegalHours)
        totalGeneralHours = try values.decodeIfPresent(String.self, forKey: .totalGeneralHours)
        totalOtherHours = try values.decodeIfPresent(String.self, forKey: .totalOtherHours)
        totalVriHours = try values.decodeIfPresent(String.self, forKey: .totalVriHours)
        signatureDate = try values.decodeIfPresent(String.self, forKey: .signatureDate)
        checklistFileID = try values.decodeIfPresent(String.self, forKey: .checklistFileID)
        expiredDate = try values.decodeIfPresent(String.self, forKey: .expiredDate)
        appointmentType = try values.decodeIfPresent(String.self, forKey: .appointmentType)
        isDPSI = try values.decodeIfPresent(String.self, forKey: .isDPSI)
        isUKBased = try values.decodeIfPresent(String.self, forKey: .isUKBased)
        isSCClearance = try values.decodeIfPresent(String.self, forKey: .isSCClearance)
        isESCClearance = try values.decodeIfPresent(String.self, forKey: .isESCClearance)
        isCTClearance = try values.decodeIfPresent(String.self, forKey: .isCTClearance)
        isNPPV3Clearance = try values.decodeIfPresent(String.self, forKey: .isNPPV3Clearance)
        isNRPSIMembership = try values.decodeIfPresent(String.self, forKey: .isNRPSIMembership)
        isITIMembership = try values.decodeIfPresent(String.self, forKey: .isITIMembership)
        isCIOLMembership = try values.decodeIfPresent(String.self, forKey: .isCIOLMembership)
        dPSIFile = try values.decodeIfPresent(String.self, forKey: .dPSIFile)
        uKBasedFile = try values.decodeIfPresent(String.self, forKey: .uKBasedFile)
        sCClearanceFile = try values.decodeIfPresent(String.self, forKey: .sCClearanceFile)
        eSCClearanceFile = try values.decodeIfPresent(String.self, forKey: .eSCClearanceFile)
        cTClearanceFile = try values.decodeIfPresent(String.self, forKey: .cTClearanceFile)
        nPPV3ClearanceFile = try values.decodeIfPresent(String.self, forKey: .nPPV3ClearanceFile)
        nRPSIMembershipFile = try values.decodeIfPresent(String.self, forKey: .nRPSIMembershipFile)
        iTIMembershipFile = try values.decodeIfPresent(String.self, forKey: .iTIMembershipFile)
        cIOLMembershipFile = try values.decodeIfPresent(String.self, forKey: .cIOLMembershipFile)
        dPSIDOC = try values.decodeIfPresent(String.self, forKey: .dPSIDOC)
        uKBasedDOC = try values.decodeIfPresent(String.self, forKey: .uKBasedDOC)
        sCClearanceDOC = try values.decodeIfPresent(String.self, forKey: .sCClearanceDOC)
        eSCClearanceDOC = try values.decodeIfPresent(String.self, forKey: .eSCClearanceDOC)
        cTClearanceDOC = try values.decodeIfPresent(String.self, forKey: .cTClearanceDOC)
        nPPV3ClearanceDOC = try values.decodeIfPresent(String.self, forKey: .nPPV3ClearanceDOC)
        nRPSIMembershipDOC = try values.decodeIfPresent(String.self, forKey: .nRPSIMembershipDOC)
        iTIMembershipDOC = try values.decodeIfPresent(String.self, forKey: .iTIMembershipDOC)
        cIOLMembershipDOC = try values.decodeIfPresent(String.self, forKey: .cIOLMembershipDOC)
        spokenLevel1 = try values.decodeIfPresent(String.self, forKey: .spokenLevel1)
        spokenLevel2 = try values.decodeIfPresent(String.self, forKey: .spokenLevel2)
        spokenLevel3 = try values.decodeIfPresent(String.self, forKey: .spokenLevel3)
        spokenLevel4 = try values.decodeIfPresent(String.self, forKey: .spokenLevel4)
        spokenLevel5 = try values.decodeIfPresent(String.self, forKey: .spokenLevel5)
        signLevel1 = try values.decodeIfPresent(String.self, forKey: .signLevel1)
        signLevel2 = try values.decodeIfPresent(String.self, forKey: .signLevel2)
        signLevel3 = try values.decodeIfPresent(String.self, forKey: .signLevel3)
        signLevel4 = try values.decodeIfPresent(String.self, forKey: .signLevel4)
        signLevel5 = try values.decodeIfPresent(String.self, forKey: .signLevel5)
        interpreterFileList = try values.decodeIfPresent(String.self, forKey: .interpreterFileList)
        screeningFormFile = try values.decodeIfPresent(String.self, forKey: .screeningFormFile)
        hepBFile = try values.decodeIfPresent(String.self, forKey: .hepBFile)
        mMRFile = try values.decodeIfPresent(String.self, forKey: .mMRFile)
        covidFile = try values.decodeIfPresent(String.self, forKey: .covidFile)
        fluFile = try values.decodeIfPresent(String.self, forKey: .fluFile)
        pPDFile = try values.decodeIfPresent(String.self, forKey: .pPDFile)
        tdapFile = try values.decodeIfPresent(String.self, forKey: .tdapFile)
        varicellaFile = try values.decodeIfPresent(String.self, forKey: .varicellaFile)
        orientation = try values.decodeIfPresent(String.self, forKey: .orientation)
    }

}*/


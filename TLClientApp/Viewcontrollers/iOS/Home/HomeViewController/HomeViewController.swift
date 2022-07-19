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
import SideMenu


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
    var callManagerVM = CallManagerVM()
    var callingScheduleArr = [Int]()
    let app = UIApplication.shared.delegate as? AppDelegate
    var calendar = FSCalendar()
    static func createWith(navigator: Navigator, storyboard: UIStoryboard,userModel: DetailsModal) -> HomeViewController {
        return storyboard.instantiateViewController(ofType: HomeViewController.self).then { viewController in
            viewController.loginVM = userModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
        updateUI()
        tblCalenderView.spr_setIndicatorHeader { [weak self] in
            self?.action()
        }
        tblCalenderView.separatorStyle = .none
       
        //checkSingleSignin()
        getServiceType()
        getallweekDate()
        self.dashBoardTitleLbl.text = userDefaults.string(forKey: "companyName") ?? ""
        GetPublicData.sharedInstance.getAllLanguage()
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToUploadImg(notification:)), name: Notification.Name("UpdateProfilePic"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.actionLogout(notification:)), name: Notification.Name("LogoutFunction"), object: nil)// LogoutFunction
        locAuthentication()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //tblCalenderView.spr_beginRefreshing()
       // locAuthentication()
        // updateUI()
        //calenderView.removeFromSuperview()
       
       self.appointmentScheduling()
       }
    
  
    @IBAction func actionVirtualMeeting(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "VirtualMeetingParentNewVC" ) as! VirtualMeetingParentNewVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        //let vc = storyboard?.instantiateViewController(identifier: "VirtualMeetingViewController" ) as! VirtualMeetingViewController
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func actionLogout(notification: Notification) {
        // updateDeviceToken()
        
        userLogout(userGuid: userDefaults.string(forKey: "userGUID") ?? "")
    }
    func hitApiGetNotificationCount(){
        if Reachability.isConnectedToNetwork() {
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
                    //SwiftLoader.hide()
                    switch(response.result){
                        
                    case .success(_):
                        print("Respose Success Notification Count ")
                        guard let daata91 = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiNotificationResponseModel = try jsonDecoder.decode(ApiNotificationResponseModel.self, from: daata91)
                            print("Success notification count ")
                            let count = self.apiNotificationResponseModel?.notificationsCounts?.first?.notificationCounts ?? ""
                            print("notification count\(count)" )
                            if count == "0" {
                                self.notificationBtn.badgeString = ""
                            }
                            else {
                                self.notificationBtn.badgeString = count
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
    }
    func action() {
        print("Data reload ")
        
        hitApiGetNotificationCount()
        appointmentScheduling()
       // createCalendar()
        //  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //self.tblCalenderView.spr_endRefreshing()
        // }
    }
    @objc func moveToUploadImg(notification: Notification) {
        if notification.userInfo?["val"] as? String == "1" {
            let vc = storyboard?.instantiateViewController(identifier: "UpdateProfilePicViewController") as! UpdateProfilePicViewController
            
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        else if notification.userInfo?["val"] as? String == "2" {
        print("got scanner ----->")
       
    }
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
              
                switch(response.result){
                    
                case .success(_):
                    
                    guard let daata92 = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiGoogleTimeZoneresponse = try jsonDecoder.decode(ApiGoogleTimeZoneresponse.self, from: daata92)
                        let status = self.apiGoogleTimeZoneresponse?.status ?? ""
                        if status == "OK" {
                            let timeConverter1 = DateFormatter()
                            timeConverter1.dateFormat = "MM/dd/yyyy"
                            let dateStr = timeConverter1.string(from: Date())
                            let timeZone = self.apiGoogleTimeZoneresponse?.timeZoneName ?? ""
                           
                            let previousTimeZone = userDefaults.string(forKey: "TimeZone") ?? ""
                           
                            if previousTimeZone == timeZone {
                                
                            }else {
                                SwiftLoader.hide()
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
        let timeZones = userDefaults.value(forKey: "isDeclineTimeZone") ?? false
        
        if  timeZones as! Bool == false {
            self.getCurrentTimeZone(lattitude: self.lattitude, longitude: self.longitude, timeStamp: timeStampString)
        }
        //  userDefaults.removeObject(forKey: "isDeclineTimeZone")
        
    }
    func appointmentScheduling(){
      
        let FirstDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let result02 : String = formatter.string(from: FirstDate) as String? else { return }
        print("selected Date -->",result02 )
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let CustomerID = userDefaults.string(forKey: "CustomerID") ?? ""
        let userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        print("userId is--------> \(userId) , cutomerId is \(CustomerID) , usertypeID is \(userTypeID)")
        DispatchQueue.main.async {
            self.hitApigetAllScheduleAppointment(date: result02, customerId: userId, selectedDate: result02)
        }
        
    }
    func createCalendar(){
        //calenderView.removeFromSuperview()
        calenderView.subviews.forEach { (item) in
            item.removeFromSuperview()
        }
       
        //calendar.removeFromSuperview()+
        calendar.placeholderType = .none
        //calendar.appearance.separators = .interRows
        calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        
        let tDate = Date()
        let formatterTest = DateFormatter()
        formatterTest.dateFormat = "yyyy/MM/dd"
        print(formatterTest.string(from: tDate))
        let finalDate = formatterTest.string(from: tDate)
        
        calendar.select(formatterTest.date(from: finalDate)!)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .blue
        calendar.today = Date()
       
        calendar.setCurrentPage(Date(), animated: true)
        calendar.calendarHeaderView.backgroundColor = UIColor(hexString: "#33A5FF")
        calendar.appearance.headerMinimumDissolvedAlpha = (0.3)
        calendar.appearance.headerTitleColor = .white
        self.calendarObject = calendar
        calendar.scope = .month
        
        calenderView.addSubview(calendar)
       
    }
    
    func userLogout(userGuid : String ){
        if Reachability.isConnectedToNetwork() {
            SwiftLoader.show(title:"Logout..",animated: true)
            let urlString = APi.changeLogoutStatus.url
            let parameters = [
                "UserGuid": userGuid,
                "UserID": userDefaults.string(forKey: .kUSER_ID) ?? ""
            ] as [String:Any]
            
            AF.request(urlString, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    SwiftLoader.hide()
                    switch(response.result){
                    case .success(_):
                        
                        guard let daata95 = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiLogoutResponseModel = try jsonDecoder.decode(ApiLogoutResponseModel.self, from: daata95)
                            let status = self.apiLogoutResponseModel?.table?.first?.success ?? 0
                            if status == 1 {
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
                })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    @IBAction func telephoneConfrenceServiceBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TelephonicConferenceParentVC" ) as! TelephonicConferenceParentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func documentTranslationBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "DocumentTranslationViewController" ) as! DocumentTranslationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onsiteAppointmentBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SchedulingAppointments", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "OnsiteAppointmentParentVC" ) as! OnsiteAppointmentParentVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnSideMenu(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "SideMenuViewController" ) as! SideMenuViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTapped(_ sender: UIButton){
        print("Last button tapped ")
        if sender.tag == 3 {
            
            GetVriOPIController(fromAppointment: false, appointmentId: "", index: 0)
            
        }
        
    }
    public func GetVriOPIController(fromAppointment: Bool,appointmentId: String, index : Int){
        if index == 2 {
            let vc = storyboard?.instantiateViewController(identifier: "VRIOPIViewController") as! VRIOPIViewController
            vc.isFromAppointmentVRI = fromAppointment
            vc.selectedIndex = index
            vc.apmntID = appointmentId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if index == 3 {
            let vc = storyboard?.instantiateViewController(identifier: "VRIOPIViewController") as! VRIOPIViewController
            vc.isFromAppointmentOPI = fromAppointment
            vc.selectedIndex = index
            vc.apmntID = appointmentId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
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
    
    //test doc only:
   
    //end
    private func updateUI(){
        
        createCalendar()
        tblCalenderView.register(UINib(nibName: nibNamed.calendarTVCell, bundle: nil), forCellReuseIdentifier: HomeCellIdentifier.calendarTVCell.rawValue)
        tblCalenderView.delegate = self
        tblCalenderView.dataSource = self
        
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
                    
                    guard let daata96 = response.data else { return }
                    print("response are ", response.data)
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiCheckMeetSatusResponseModel = try jsonDecoder.decode([ApiCheckMeetSatusResponseModel].self, from: daata96)
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
        if Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                SwiftLoader.show(animated: true)
            }
           let urlString = "https://lsp.totallanguage.com/Appointment/GetFormData?methodType=GETCUSTOMERSCHEDULEDATA&Customer=\(customerId)&UType=Customer&Date=\(date)"
            print("url to get schedule \(urlString)")
            callingScheduleArr.removeAll()
            AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    
                    switch(response.result){
                        
                    case .success(_):
                        print("Respose Appointment data--> ",response.result)
                        guard let daata97 = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiScheduleAppointmentResponseModel = try jsonDecoder.decode(ApiScheduleAppointmentResponseModel.self, from: daata97)
                            print("Success")
                            self.showAppointmentArr.removeAll()
                            
                            self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA?.forEach({ appointmentData in
                                let rawDate = appointmentData.startDateTime ?? ""
                                let newDate = convertDateFormater(rawDate)
                              
                                if selectedDate == newDate {
                                    self.showAppointmentArr.append(appointmentData)
                                }
                            })
                         
                            DispatchQueue.main.async {
                                self.tblCalenderView.spr_endRefreshing()
                                self.tblCalenderView.reloadData()
                                self.calendarObject.reloadData()
                                SwiftLoader.hide()
                            }
                            
                        } catch{
                            SwiftLoader.hide()
                            self.tblCalenderView.spr_endRefreshing()
                            print("error block forgot password " ,error)
                        }
                    case .failure(_):
                        SwiftLoader.hide()
                        print("Respose Failure ")
                        self.tblCalenderView.spr_endRefreshing()
                    }
                    
                })}
        
        else {
            SwiftLoader.hide()
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
    }
    func getServiceType(){
        if Reachability.isConnectedToNetwork() {
          
            let companyId = userDefaults.string(forKey: "companyID") ?? ""
            
            let urlPostFix = "&CompanyId=\(companyId)&SpType1=1"
            
            let urlString = "\(APi.speciality.url)" + urlPostFix
            
            AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    
                    switch(response.result){
                        
                    case .success(_):
                        print("Respose Success ")
                        guard let daata98 = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetSpecialityDataModel = try jsonDecoder.decode(ApiGetSpecialityDataModel.self, from: daata98)
                            print("Success")
                            GetPublicData.sharedInstance.apiGetSpecialityDataModel = self.apiGetSpecialityDataModel
                            GetPublicData.sharedInstance.apic.removeAll()
                            self.apiGetSpecialityDataModel?.appointmentType?.forEach({ (abc) in
                                GetPublicData.sharedInstance.apic.append(abc)
                            })
                            print("count for appointment data \(GetPublicData.sharedInstance.apic.count)")
                            
                            
                            
                        } catch{
                            SwiftLoader.hide()
                            print("error block forgot password " ,error)
                        }
                    case .failure(_):
                        SwiftLoader.hide()
                        print("Respose Failure service ")
                        
                    }
                })}else {
                    SwiftLoader.hide()
                    self.view.makeToast(ConstantStr.noItnernet.val)}
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
       
        let index = showAppointmentArr[indexPath.row]
        let statustype = index.appointmentStatusType ?? ""
        
        if statustype == "Meeting" {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ScheduleMeetingTableViewCell", for: indexPath) as! ScheduleMeetingTableViewCell
            let dateValue = index.startDateTime ?? ""
            let timeValue = convertDateFormater(dateValue)
            
            cell.startDateLbl.text = "\(timeValue) (\(userDefaults.string(forKey: "zoneShortForm")!))"
            // cell.appointmentTitleLbl.text = "Meeting"
            cell.checkInLbl.text = index.vendorName ?? ""
            cell.interpreterLbl.text = convertTimeFormater(dateValue)
            
            if index.appointmentStatusType ?? "" == "CANCELLED" || index.appointmentStatusType ?? "" == "BOTCHED" || index.appointmentStatusType ?? "" == "COULDNOTBOOK" {
                
                cell.statusOfAppointmentLbl.text = "CANCELLED"
                
            }else {
                
                cell.statusOfAppointmentLbl.text = index.appointmentStatusType ?? ""
                
            }
            cell.statusOfAppointmentLbl.lineBreakMode = .byWordWrapping
            
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
            let titleString = index.title
            if titleString == "R " {
                cell.appointmentTitleLbl.text = "Regular Appointment"
                cell.customerValueStack.isHidden = false
                cell.CustomerNameStack.isHidden = false
                cell.clientnameStack.isHidden = false
                cell.clientValueStack.isHidden = false
                cell.jobTypeText.isHidden = false
                cell.typeOfMeetLbl.isHidden = false
            }else if titleString == "B " {
                cell.appointmentTitleLbl.text = "Blocked Appointment"
                cell.customerValueStack.isHidden = false
                cell.CustomerNameStack.isHidden = false
                cell.jobTypeText.isHidden = true
                cell.typeOfMeetLbl.isHidden = true
                
                cell.clientnameStack.isHidden = true
                cell.clientValueStack.isHidden = true
            }else if titleString == "RC" {
                cell.jobTypeText.isHidden = false
                cell.typeOfMeetLbl.isHidden = false
                cell.customerValueStack.isHidden = false
                cell.CustomerNameStack.isHidden = false
                cell.clientnameStack.isHidden = false
                cell.clientValueStack.isHidden = false
                cell.appointmentTitleLbl.text = "Regular Appointment"
            }else {
                cell.jobTypeText.isHidden = false
                cell.typeOfMeetLbl.isHidden = false
                cell.customerValueStack.isHidden = false
                cell.CustomerNameStack.isHidden = false
                cell.clientnameStack.isHidden = false
                cell.clientValueStack.isHidden = false
                cell.appointmentTitleLbl.text = ""
            }
            
            let cancelStatus = index.customerCancelRequest
            
            if cancelStatus == 0 {
                let appStats = index.appointmentStatusType ?? ""
                print("app status in case of cancel \(appStats)")
                if appStats == "Late Cancelled" || appStats == "Botched" || appStats == "Cancelled" {
                    cell.cancelMessageStack.visibility = .gone
                }else {
                    cell.cancelMessageStack.visibility = .visible
                }
            }else {
                let appStats = index.appointmentStatusType ?? ""
                print("app status in case of cancel \(appStats)")
                cell.cancelMessageStack.visibility = .gone
            }
            cell.targetLanguageLbl.text = index.languageName ?? ""
           
            if index.appointmentType?.lowercased() == "telephone conference" || index.appointmentType?.lowercased() == "virtual meeting"{
                cell.venuLbl.isHidden = true
                cell.lblTextVenue.isHidden = true
            }
            else {
                cell.venuLbl.isHidden = false
                cell.lblTextVenue.isHidden = false
                cell.venuLbl.text = index.venueName ?? ""
            }
            cell.typeOfMeetLbl.text = index.appointmentType ?? ""
            if index.clientName == nil || index.clientName == ""{
                cell.clientNameLbl.text =  "N/A"
            }else {
                cell.clientNameLbl.text = index.clientName
            }
            
            cell.customerName.text = index.customerName ?? "N/A"
            // cell.interpreterLbl.text = index.interpretorName
            if index.sLanguageName == nil {
                cell.sourceLanguageLbl.text = "English"
            }else {
                cell.sourceLanguageLbl.text = index.sLanguageName ?? ""
            }
            
            if index.appointmentStatusType ?? "" == "CANCELLED" || index.appointmentStatusType ?? "" == "BOTCHED" || index.appointmentStatusType ?? "" == "COULDNOTBOOK" {
                
                cell.statusOfAppointmentLbl.text = "CANCELLED"
                cell.statusOfAppointmentLbl.backgroundColor = hexStringToUIColor(hex: getHexaString(status: ("CANCELLED".lowercased()))!)
                
            }else if index.appointmentStatusType ?? "" == "PENDING"{
                cell.statusOfAppointmentLbl.backgroundColor = hexStringToUIColor(hex: getHexaString(status: (index.appointmentStatusType!.lowercased()))!)
                cell.statusOfAppointmentLbl.text = index.appointmentStatusType ?? ""
                
            }else {
                cell.statusOfAppointmentLbl.text = index.appointmentStatusType ?? ""
                cell.statusOfAppointmentLbl.backgroundColor = hexStringToUIColor(hex: getHexaString(status: (index.appointmentStatusType!.lowercased()))!)
            }
            cell.statusOfAppointmentLbl.lineBreakMode = .byWordWrapping
            let dateValue = index.startDateTime ?? ""
            let endValue = index.endDateTime ?? ""
            let endTimeValue = convertTimeFormater(endValue)
            let timeValue = convertTimeFormater(dateValue)
            cell.sourceLanguageLbl.text = endTimeValue
            cell.startDateLbl.text = "\(timeValue) (\(userDefaults.string(forKey: "zoneShortForm")!))"
          
            
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
                if index.appointmentType == "Schedule OPI" {
                    cell.btnVideoAndAudioCall.isHidden = false
                    cell.btnVideoAndAudioWidth.constant = 45.0
                }
                else if index.appointmentType == "Schedule VRI" {
                    cell.btnVideoAndAudioCall.isHidden = false
                    cell.btnVideoAndAudioWidth.constant = 45.0
                    if let obj = callingScheduleArr.firstIndex(where: {$0 == index.appointmentID}) {
                        cell.lblCallWarning.text = "Button will be enabled 10 minutes before and disable 20 minutes after the schedules time."
                    }
                    else {
                        cell.lblCallWarning.text = ""
                    }
                    
                }
            }else{
                cell.lblCallWarning.text = ""
                cell.btnVideoAndAudioWidth.constant = 0.0
                cell.btnVideoAndAudioCall.isHidden = true
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
                cell.btnVideoAndAudioCall.tag = indexPath.row
                cell.btnVideoAndAudioCall.addTarget(self, action: #selector(scheduleCallMethod(sender:)), for: .touchUpInside)
                
            }else {
                let str = index.authCode ?? ""
                let components = str.components(separatedBy: " ")
                cell.appointmentIDLbl.text = components[0]
                cell.interpreterLbl.text = index.interpretorName ?? "N/A"
            }
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = self.showAppointmentArr[indexPath.row]
        if rowData.appointmentTypeID != 12 {
            let title = self.showAppointmentArr[indexPath.row].title ?? ""
           if rowData.appointmentType == "Schedule VRI" {
               GetVriOPIController(fromAppointment: true, appointmentId: "\(rowData.appointmentID!)", index: 2)
               
           }
            else if rowData.appointmentType == "Schedule OPI" {
                GetVriOPIController(fromAppointment: true, appointmentId: "\(rowData.appointmentID!)", index: 3)
            }
            else if title == "B " {
                let vc = self.storyboard?.instantiateViewController(identifier: "BlockedAppointmentDetailVC") as! BlockedAppointmentDetailVC
                vc.startDateString = convertDateFormater(self.showAppointmentArr[indexPath.row].startDateTime ?? "")
                vc.startTime = convertTimeFormater(self.showAppointmentArr[indexPath.row].startDateTime ?? "")
                vc.cancelKey = self.showAppointmentArr[indexPath.row].customerCancelRequest
                vc.EndTime = convertTimeFormater(self.showAppointmentArr[indexPath.row].endDateTime ?? "")
                vc.appointmentID = self.showAppointmentArr[indexPath.row].appointmentID!
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = self.storyboard?.instantiateViewController(identifier: "ScheduleAppointmentDetailVC") as! ScheduleAppointmentDetailVC
                vc.showAppointmentArr = self.showAppointmentArr[indexPath.row]
                vc.appointmentID = self.showAppointmentArr[indexPath.row].appointmentID ?? 0
                
                vc.apiScheduleAppointmentResponseModel = self.apiScheduleAppointmentResponseModel ?? ApiScheduleAppointmentResponseModel()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }else {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showAppointmentArr.count == 0 {
            tblCalenderView.setEmptyView(title: ConstantStr.nodata.val, message: ConstantStr.noRecordMsz.val)
        }
        else {
            tblCalenderView.restore()
        }
        return self.showAppointmentArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //240
    }
    
    @objc func scheduleCallMethod(sender: UIButton) {
        let obj  = showAppointmentArr[sender.tag]
        let cDate = CEnumClass.share.scheduleCurrentApmtDateAndTime
        let tMinutes = CEnumClass.share.scheduleApmtDateAndTime(sDate: obj.startDateTime!).minutes(from: cDate())
        print("tminutes------>",tMinutes)
        if tMinutes <= 10 && tMinutes >= -20 {
           if Reachability.isConnectedToNetwork() {
                 DispatchQueue.main.async { SwiftLoader.show(animated: true)}
                 callManagerVM.getRoomList { roolist, error in
                     if error == nil {
                        let roomID = roolist?[0].RoomNo ?? "0"
                         self.app?.roomIDAppdel = roomID
                         let para = self.callManagerVM.addAppCallReqAPI(sourceID:"\(obj.sLanguageID!)", targetID: "\(obj.languageID!)", roomId: roomID, targetName: obj.languageName ?? "", sourceName: obj.sLanguageName ?? "", patientName: "",patientNo: "", toUserId: "\(obj.interpreterID!)")
                         print("Addappcall Para---->",para)
                         self.addAppCall(para: para, roomid: roomID, sID: "\(obj.sLanguageID!)", tID: "\(obj.languageID!)", sName: obj.sLanguageName ?? "", tName: obj.languageName ?? "")
                    }
                     else {
                         SwiftLoader.hide()
                     }
                 }}
             else {
                 self.view.makeToast(ConstantStr.noItnernet.val)
             }
        }
        else {
            self.callingScheduleArr.append(obj.appointmentID!)
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: sender.tag, section: 0)
               
                self.tblCalenderView.reloadRows(at: [indexPath], with: .fade)
            }
          
          
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
    func addAppCall(para: [String:Any],roomid:String,sID:String,tID:String,sName:String,tName:String){
        DispatchQueue.main.async {
            SwiftLoader.hide()
            let sB = UIStoryboard(name: Storyboard_name.home, bundle: nil)
            let vdoCall = sB.instantiateViewController(identifier: Control_Name.vdoCall) as! VideoCallViewController
            vdoCall.roomID = roomid
            vdoCall.sourceLangID = sID
            vdoCall.targetLangID = tID
            vdoCall.parameter = para
            vdoCall.isScheduled = true
            vdoCall.sourceLangName = sName
            vdoCall.targetLangName = tName
            vdoCall.patientno =  ""
            vdoCall.patientname =  ""
           
            vdoCall.modalPresentationStyle = .overFullScreen
          
            self.present(vdoCall, animated: true, completion: nil)
        }
        
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
        let calendarmonth = Calendar.current.component(.month, from: maxDate)
        
        
        let dateInWeek = Date()//7th June 2017
        
       let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: dateInWeek)
        //let currentMonth = Calendar.current.component(<#T##component: Calendar.Component##Calendar.Component#>, from: <#T##Date#>)
        // self.hitApiGetWeeklyJournals(dateStr: endDate, calender: calendar )
        print("Week end date \(endDate) is: month:\(calendarmonth), currentMonth:\(currentMonth)")
        // let FirstDate = date.startOfMonth() ?? Date()
        let userId = userDefaults.string(forKey: "userId") ?? ""
        print("userId is \(userId)")
        if currentMonth == calendarmonth {
        
            let tDate = Date()
            let formatterTest = DateFormatter()
            formatterTest.dateFormat = "yyyy/MM/dd"
            print(formatterTest.string(from: tDate))
            let finalDate = formatterTest.string(from: tDate)
            
            self.calendar.select(formatterTest.date(from: finalDate)!)

           
            
            
            self.hitApigetAllScheduleAppointment(date: endDate, customerId: userId, selectedDate: CEnumClass.share.getCurrentDates2())
        }
        else {
            self.hitApigetAllScheduleAppointment(date: endDate, customerId: userId, selectedDate: endDate)
        }
        
        
        
        
    }
    
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let resultA : String = formatter.string(from: date) as String? else { return UIImage(named: "")}
        var eventCount = 0
        print("count of appointment \(self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA?.count ?? 0) for date \(resultA)")
        for scheduleAppointment in (self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA ?? [ApiScheduleAppointmentCustomerDataModel]())! {
            let rawDate = scheduleAppointment.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
            
            if newDate == resultA {
                eventCount = eventCount + 1
           }
        }
        if eventCount > 3 {
            return UIImage(named: "addTest")
        }else {
            return UIImage(named: "")
        }
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
        guard let resultB : String = formatter.string(from: date) as String? else { return nil }
        eventColor.removeAll()
        self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA?.forEach({ appointmentData in
            let rawDate = appointmentData.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
            
            if newDate == resultB {
                self.apiScheduleAppointmentResponseModel?.appointmentStatus?.forEach({ appointmentStatusData in
                    
                    if  appointmentStatusData.code  == appointmentData.appointmentStatusType
                    {
                       
                        let statusCode = getHexaString(status: (appointmentData.appointmentStatusType?.lowercased())!)
                        //let statusColor = appointmentStatusData.color ?? ""
                        eventColor.append(UIColor(hexString: statusCode!))
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
        guard let resultC : String = formatter.string(from: FirstDate) as String? else { return }
        guard let selectedDate : String = formatter.string(from: date) as String? else { return }
        
        let userId = userDefaults.string(forKey: "userId") ?? ""
        print("userId is \(userId)")
        
        self.hitApigetAllScheduleAppointment(date: resultC, customerId: userId, selectedDate: selectedDate)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let result : String = formatter.string(from: date) as String? else { return 0}
        var eventCount = 0
       
        for scheduleAppointment in (self.apiScheduleAppointmentResponseModel?.gETCUSTOMERSCHEDULEDATA ?? [ApiScheduleAppointmentCustomerDataModel]())! {
            let rawDate = scheduleAppointment.startDateTime ?? ""
            let newDate = convertDateFormater(rawDate)
          
            if newDate == result {
                eventCount = eventCount + 1
           }
        }
        // SwiftLoader.hide()
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
        components.minute = minute >= 59 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
    func timePicker(time:Date) -> Date? {
        let components = NSCalendar.current.dateComponents([.minute], from: time)
       
        return Calendar.current.date(byAdding: components, to: self)
    }
}
extension HomeViewController {
    func scannerMethod() {
        print("scann")
    }
}

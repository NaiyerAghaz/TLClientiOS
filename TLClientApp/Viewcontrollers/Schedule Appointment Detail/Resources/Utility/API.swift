//
//  API.swift
//  TLClientApp
//
//  Created by Naiyer on 8/8/21.
//

import Foundation

let baseUrl = "https://lspservices.totallanguage.com/api"
//let baseUrl = "https://lspservices.smsionline.com/api"

let nBaseUrl = "https://lsp.totallanguage.com"
//let nBaseUrl = "https://lsp.smsionline.com/VendorManagement/Vendor"

let twiliBaseURL = "https://sai1.smsionline.com"
let baseOPI = "https://lsp.totallanguage.com/OPI/GetOPIAccessToken"
//let baseOPI = "https://lsp.smsionline.com/OPI/GetOPIAccessToken"
let chatURL = "https://vriservices.totallanguage.com"


//https://lsp.totallanguage.com/Voicecall/Logoutfromwebforall
enum APi{
    case login
    case forgetPassword
    case languagedata
    case getRoomId
    case apitoken
    case addUpdateUserDeviceToken
    case accessToken
    case getVriVendorsbyLidKE
    case createvricallclient
    case getVRICallVendorWithCheckCallStatus
    case getVenueData
    case getAuthCode
    case speciality
    case vriCallStart
    case ConferenceParticipant
    case addAppointment
    case addDepartment
    case addproviderData
    case getProfileImg
    case importImage
    case uploadImageData
    case changeLogoutStatus
    case cancelAppointmentRequest
    case selectedAppointment
    case getData
    case notificationDetail
    case Vrilog
    case vricallstart
    case getVriVendorsbyLid
    case AddUpdateConferenceData
    case getParticipantByRoom
    case getMeetingClientStatus
    case chattoken
    case AddScheduleMeeting
    case AddScheduleVRI
    case createVRICallClient
    case opiAcceptCall
    case getCheckCallStatus
    case createVRICallVendor
    case endVRICall
    case addCallFeedback
    case getFeedbackDetails
    case checkSingleUser
    case getOPIDetailsByRoomID
    case GetCustomerDetail
    case GetCommonDetail
    case ParticipantEndCall
    case GetVenueCommanddl
    case AddUpdateDeptAndContactData
    case tladdupdateappointment
    case encryptdecryptvalue
    case GetBlokedAppointmentDetailApi
    case customerVRIEndCall
    case logoutfromwebforall
    case tladdupdateRecurringappointment
    case getCompanydetails
    var url: URL{
        switch self {
        case .login:
            return URL(string: baseUrl + "/Security/Login")!
        case .forgetPassword:
            return URL(string: baseUrl + "/Security/ForgetPassword")!
        case .languagedata:
            return URL(string: nBaseUrl + "/VendorManagement/Vendor/GetData?methodType=LanguageData")!
        case .getRoomId:
            return URL(string: baseUrl + "/GetRoomID")!
        case .apitoken:
            return URL(string: twiliBaseURL + "/apitoken")!
        case .addUpdateUserDeviceToken:
            return URL(string: baseUrl + "/Security/AddUpdateUserDeviceToken")!
        case .accessToken :
            return URL(string: baseOPI + "/GetOPIAccessToken")!
        case .getVriVendorsbyLidKE:
            return URL(string: baseUrl + "/chatBox/getVriVendorsbyLid_KE")!
        case .createvricallclient:
            return URL(string: baseUrl + "/createvricallclient")!
        case .getVRICallVendorWithCheckCallStatus:
            return URL(string: baseUrl + "/getVRICallVendorWithCheckCallStatus")!
        case .getVenueData:
            return URL(string: nBaseUrl + "/Controls/Venue/GetData?methodType=VenueData%2CDepartmentData%2CProviderData%2CStates&")!
        case .getAuthCode:
            return URL(string: nBaseUrl + "/Appointment/GetData?methodType=AuthenticationCode&")!

        case .speciality:
            return URL(string: nBaseUrl + "/Appointment/GetData?methodType=Speciality")!
        case .addAppointment:
            return URL(string: nBaseUrl + "/Appointment/AddUpdateAppointment")!
        case .addDepartment:
            return URL(string: nBaseUrl + "/HrManagement/Department/AddUpdateDepartment")!
        case .addproviderData:
            return URL(string: nBaseUrl + "/HrManagement/Provider/AddUpdateProvider")!
        case .getProfileImg:
            return URL(string: nBaseUrl + "/Home/GetData?methodType=USERLOGOS&")!
        case .importImage:
            return URL(string: nBaseUrl + "/Security/ImportDataprofile")!
        case .uploadImageData:
            return URL(string: nBaseUrl + "/Security/SaveImageUpload")!
        case .changeLogoutStatus:
            return URL(string: baseUrl + "/Security/ChangeLogoutStatus")!
        case .cancelAppointmentRequest:
            return URL(string: nBaseUrl + "/Appointment/GetChartData?methodType=CancelAppointmentByCustomer&")!
            
        case .selectedAppointment:
            return URL(string: nBaseUrl + "/Home/GetData?methodType=AppointmentCutomerData&")!
            
        case .getData:
            return URL(string: nBaseUrl + "/Home/GetData?")!
           
        case .Vrilog:
            return URL(string: nBaseUrl + "/CustomerManagement/CustomerDetail/GetData?methodType=VRIOPIDASHBORD&")!
            
        case .notificationDetail:
            return URL(string: nBaseUrl + "/Home/GetData?methodType=NotificationsByUsername&")!
            
        case .getVriVendorsbyLid:
            return URL(string: baseUrl + "/chatBox/getVriVendorsbyLid")!
        case .vricallstart:
            return URL(string: nBaseUrl + "/VRICall/vricallstart")!
        case .AddUpdateConferenceData:
            return URL(string: baseUrl + "/AddUpdateConferenceData")!
        case .vriCallStart:
            return URL(string: nBaseUrl + "/VRICall/vricallstart")!
        case .ConferenceParticipant:
            return URL(string: baseUrl + "/ConferenceParticipant")!
        case .getParticipantByRoom:
            return URL(string: baseUrl + "/GetParticipantsByRoom")!
        case .getMeetingClientStatus:
            return URL(string: baseUrl + "/getMeetingClientStatus")!
        case .chattoken:
            return URL(string: chatURL + "/chattoken")!
        case .AddScheduleMeeting:
            return URL(string: nBaseUrl + "/Appointment/AddScheduleMeeting")!
        case .AddScheduleVRI:
            return URL(string: nBaseUrl + "/Appointment/AddScheduleVRI")!
        case .createVRICallClient:
            return URL(string: baseUrl + "/CreateVRICallClient")!
        case .opiAcceptCall:
            return URL(string: baseUrl + "/Appointment/opiAcceptCall")!
        case .getCheckCallStatus:
            return URL(string: baseUrl + "/GetVRICallVendorWithCheckCallStatus")!
        case .createVRICallVendor:
            return URL(string: baseUrl + "/CreateVRICallVendor")!
        case .endVRICall:
            return URL(string: baseUrl + "/EndVRICall")!
        case .addCallFeedback:
            return URL(string: baseUrl + "/Security/AddCallFeedback")!
        case .getFeedbackDetails:
            return URL(string: baseUrl + "/chatBox/getFeedbackdetails")!
        case .checkSingleUser:
            return URL(string: baseUrl + "/GetUserGUIDtoChecksinglesignin")!
        case .getOPIDetailsByRoomID:
            return URL(string: baseUrl + "/Appointment/getOPIDetailsByRoomID")!
        case .GetCustomerDetail:
            return URL(string: baseUrl + "/GetGetAppointmentCommanddl")!
        case .GetCommonDetail:
            return URL(string: baseUrl + "/GetGetAppointmentDropDown")!
        case .ParticipantEndCall:
            return URL(string: chatURL + "/ParticipantEndCall")!
        case .GetVenueCommanddl:
            return URL(string: baseUrl + "/GetVenueCommanddl")!
        case .AddUpdateDeptAndContactData:
            return URL(string: baseUrl + "/AddUpdateDeptAndContactData")!
        case .tladdupdateappointment:
            return URL(string: baseUrl + "/tladdupdateappointment")!
        case .encryptdecryptvalue:
            return URL(string: baseUrl + "/encryptdecryptvalue")!
        case .GetBlokedAppointmentDetailApi:
            return URL(string: baseUrl + "/GetAppointmentBlokedHomeScreenPopupApi")!
        case .customerVRIEndCall:
            return URL(string: nBaseUrl + "/VRICall/customervriendcall")!
        case .logoutfromwebforall:
            return URL(string: nBaseUrl + "/Voicecall/Logoutfromwebforall")!
        case .tladdupdateRecurringappointment:
            return URL(string: baseUrl + "/tladdupdateRecurringappointment")!
        case .getCompanydetails:
            return URL(string: baseUrl + "/GetCompanydetails")!
        }
    }
}



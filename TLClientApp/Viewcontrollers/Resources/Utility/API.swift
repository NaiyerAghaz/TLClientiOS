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
            
        }
    }
}


//let baseUrl = "https://lspservices.totallanguage.com/api"
//let nBaseUrl = "https://lsp.totallanguage.com/VendorManagement/Vendor/"
//
//enum APi{
//    case login
//    case forgetPassword
//    case languagedata
//
//    var url: URL{
//        switch self {
//        case .login:
//            return URL(string: baseUrl + "/Security/Login")!
//        case .forgetPassword:
//            return URL(string: baseUrl + "/Security/ForgetPassword")!
//        case .languagedata:
//            return URL(string: nBaseUrl + "GetData?methodType=LanguageData")!
//        }
//    }
//}

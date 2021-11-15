//
//  API.swift
//  TLClientApp
//
//  Created by Naiyer on 8/8/21.
//

import Foundation
let baseUrl = "https://lspservices.totallanguage.com/api"
let baseOPI = "https://lsp.totallanguage.com/OPI/GetOPIAccessToken"
let nBaseUrl = "https://lsp.totallanguage.com"
let twiliBaseURL = "https://sai1.smsionline.com"
let chatURL = "https://vriservices.totallanguage.com"
enum APi{
    case login
    case forgetPassword
    case languagedata
    case getRoomId
    case apitoken
    case addUpdateUserDeviceToken
    case accessToken
    case vriCallStart
    case ConferenceParticipant
    case vricallstart
    case getVriVendorsbyLid
    case getParticipantByRoom
    case AddUpdateConferenceData
    case chattoken
    case getMeetingClientStatus
    
    
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
            return URL(string: nBaseUrl + "/OPI/GetOPIAccessToken")!
        case .vriCallStart :
            return URL(string: nBaseUrl + "/VRICall/vricallstart")!
        case .ConferenceParticipant:
            return URL(string: baseUrl + "/ConferenceParticipant")!
        case .vricallstart:
            return URL(string: nBaseUrl + "/VRICall/vricallstart")!
        case .getVriVendorsbyLid:
            return URL(string: baseUrl + "/chatBox/getVriVendorsbyLid")!
        case .getParticipantByRoom:
            return URL(string: baseUrl + "/GetParticipantsByRoom")!
        case .AddUpdateConferenceData:
            return URL(string: baseUrl + "/AddUpdateConferenceData")!
        case .chattoken:
            return URL(string: chatURL + "/chattoken")!
        case .getMeetingClientStatus:
            return URL(string: baseUrl + "/getMeetingClientStatus")!
       
        }
    }
}

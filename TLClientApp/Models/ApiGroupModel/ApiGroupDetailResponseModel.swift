/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiGroupDetailResponseModel : Codable {
	let message : String?
	let status : String?
	let userName : String?
	let flag : String?
	let userType : String?
	let userGuID : String?
	let password : String?
	let prozFlag : String?
	let proz_imgurl : String?
	let proZ_UUID : String?
	let firstName : String?
	let lastName : String?
	let customerID : String?
	let email : String?
	let sessionID : String?
	let emailActivationKey : String?
	let device : String?
	let emailActivationKeyDateTime : String?
	let isAuthenticated : Bool?
	let phoneNumber : String?
	let isAlreadyLoggedIN : String?
	let messageActivationKey : String?
	let companyID : String?
	let userID : String?
	let userTypeID : String?
	let imageData : String?
	let userTypeName : String?
	let groupID : Int?
	let groupName : String?
	let isAcceptedAgreement : String?
	let companyName : String?
	let companyEmail : String?
	let companyLogo : String?
	let planName : String?
	let latitude : String?
	let longitude : String?
	let ip : String?
	let demoExpirationDays : String?
	let adminJobApproval : String?
	let vendorActive : String?
	let loginTime : String?
	let logoutTime : String?
	let diffhr : String?
	let isTransalationServices : String?
	let isOnsiteInterpretation : String?
	let telephoneConferenceService : String?
	let transcription : String?
	let vRI : String?
	let languageids : String?
	let languageName : String?
	let serviceTypes : String?
	let notcount : Int?
	let usertoken : String?
	let companyUserToken : String?
	let currencyCode : String?
	let timeZone : String?
	let companyTimeZone : String?
	let paymentType : String?
	let currantBal : String?
	let userSessionId : String?
	let userLogInKey : String?
	let sucessStatus : String?
	let dateFormat : String?
	let dateTimeFormate : String?
	let isSupportPermission : String?
	let companyPhone : String?

	enum CodingKeys: String, CodingKey {

		case message = "message"
		case status = "status"
		case userName = "UserName"
		case flag = "flag"
		case userType = "UserType"
		case userGuID = "UserGuID"
		case password = "Password"
		case prozFlag = "ProzFlag"
		case proz_imgurl = "Proz_imgurl"
		case proZ_UUID = "ProZ_UUID"
		case firstName = "FirstName"
		case lastName = "LastName"
		case customerID = "CustomerID"
		case email = "Email"
		case sessionID = "SessionID"
		case emailActivationKey = "EmailActivationKey"
		case device = "device"
		case emailActivationKeyDateTime = "EmailActivationKeyDateTime"
		case isAuthenticated = "IsAuthenticated"
		case phoneNumber = "PhoneNumber"
		case isAlreadyLoggedIN = "IsAlreadyLoggedIN"
		case messageActivationKey = "MessageActivationKey"
		case companyID = "CompanyID"
		case userID = "UserID"
		case userTypeID = "UserTypeID"
		case imageData = "ImageData"
		case userTypeName = "UserTypeName"
		case groupID = "GroupID"
		case groupName = "GroupName"
		case isAcceptedAgreement = "IsAcceptedAgreement"
		case companyName = "CompanyName"
		case companyEmail = "CompanyEmail"
		case companyLogo = "CompanyLogo"
		case planName = "PlanName"
		case latitude = "Latitude"
		case longitude = "Longitude"
		case ip = "Ip"
		case demoExpirationDays = "DemoExpirationDays"
		case adminJobApproval = "AdminJobApproval"
		case vendorActive = "VendorActive"
		case loginTime = "LoginTime"
		case logoutTime = "LogoutTime"
		case diffhr = "diffhr"
		case isTransalationServices = "IsTransalationServices"
		case isOnsiteInterpretation = "IsOnsiteInterpretation"
		case telephoneConferenceService = "TelephoneConferenceService"
		case transcription = "Transcription"
		case vRI = "VRI"
		case languageids = "languageids"
		case languageName = "LanguageName"
		case serviceTypes = "ServiceTypes"
		case notcount = "Notcount"
		case usertoken = "usertoken"
		case companyUserToken = "CompanyUserToken"
		case currencyCode = "currencyCode"
		case timeZone = "TimeZone"
		case companyTimeZone = "CompanyTimeZone"
		case paymentType = "PaymentType"
		case currantBal = "CurrantBal"
		case userSessionId = "UserSessionId"
		case userLogInKey = "UserLogInKey"
		case sucessStatus = "SucessStatus"
		case dateFormat = "DateFormat"
		case dateTimeFormate = "DateTimeFormate"
		case isSupportPermission = "IsSupportPermission"
		case companyPhone = "CompanyPhone"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		userName = try values.decodeIfPresent(String.self, forKey: .userName)
		flag = try values.decodeIfPresent(String.self, forKey: .flag)
		userType = try values.decodeIfPresent(String.self, forKey: .userType)
		userGuID = try values.decodeIfPresent(String.self, forKey: .userGuID)
		password = try values.decodeIfPresent(String.self, forKey: .password)
		prozFlag = try values.decodeIfPresent(String.self, forKey: .prozFlag)
		proz_imgurl = try values.decodeIfPresent(String.self, forKey: .proz_imgurl)
		proZ_UUID = try values.decodeIfPresent(String.self, forKey: .proZ_UUID)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		customerID = try values.decodeIfPresent(String.self, forKey: .customerID)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		sessionID = try values.decodeIfPresent(String.self, forKey: .sessionID)
		emailActivationKey = try values.decodeIfPresent(String.self, forKey: .emailActivationKey)
		device = try values.decodeIfPresent(String.self, forKey: .device)
		emailActivationKeyDateTime = try values.decodeIfPresent(String.self, forKey: .emailActivationKeyDateTime)
		isAuthenticated = try values.decodeIfPresent(Bool.self, forKey: .isAuthenticated)
		phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
		isAlreadyLoggedIN = try values.decodeIfPresent(String.self, forKey: .isAlreadyLoggedIN)
		messageActivationKey = try values.decodeIfPresent(String.self, forKey: .messageActivationKey)
		companyID = try values.decodeIfPresent(String.self, forKey: .companyID)
		userID = try values.decodeIfPresent(String.self, forKey: .userID)
		userTypeID = try values.decodeIfPresent(String.self, forKey: .userTypeID)
		imageData = try values.decodeIfPresent(String.self, forKey: .imageData)
		userTypeName = try values.decodeIfPresent(String.self, forKey: .userTypeName)
		groupID = try values.decodeIfPresent(Int.self, forKey: .groupID)
		groupName = try values.decodeIfPresent(String.self, forKey: .groupName)
		isAcceptedAgreement = try values.decodeIfPresent(String.self, forKey: .isAcceptedAgreement)
		companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
		companyEmail = try values.decodeIfPresent(String.self, forKey: .companyEmail)
		companyLogo = try values.decodeIfPresent(String.self, forKey: .companyLogo)
		planName = try values.decodeIfPresent(String.self, forKey: .planName)
		latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
		ip = try values.decodeIfPresent(String.self, forKey: .ip)
		demoExpirationDays = try values.decodeIfPresent(String.self, forKey: .demoExpirationDays)
		adminJobApproval = try values.decodeIfPresent(String.self, forKey: .adminJobApproval)
		vendorActive = try values.decodeIfPresent(String.self, forKey: .vendorActive)
		loginTime = try values.decodeIfPresent(String.self, forKey: .loginTime)
		logoutTime = try values.decodeIfPresent(String.self, forKey: .logoutTime)
		diffhr = try values.decodeIfPresent(String.self, forKey: .diffhr)
		isTransalationServices = try values.decodeIfPresent(String.self, forKey: .isTransalationServices)
		isOnsiteInterpretation = try values.decodeIfPresent(String.self, forKey: .isOnsiteInterpretation)
		telephoneConferenceService = try values.decodeIfPresent(String.self, forKey: .telephoneConferenceService)
		transcription = try values.decodeIfPresent(String.self, forKey: .transcription)
		vRI = try values.decodeIfPresent(String.self, forKey: .vRI)
		languageids = try values.decodeIfPresent(String.self, forKey: .languageids)
		languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
		serviceTypes = try values.decodeIfPresent(String.self, forKey: .serviceTypes)
		notcount = try values.decodeIfPresent(Int.self, forKey: .notcount)
		usertoken = try values.decodeIfPresent(String.self, forKey: .usertoken)
		companyUserToken = try values.decodeIfPresent(String.self, forKey: .companyUserToken)
		currencyCode = try values.decodeIfPresent(String.self, forKey: .currencyCode)
		timeZone = try values.decodeIfPresent(String.self, forKey: .timeZone)
		companyTimeZone = try values.decodeIfPresent(String.self, forKey: .companyTimeZone)
		paymentType = try values.decodeIfPresent(String.self, forKey: .paymentType)
		currantBal = try values.decodeIfPresent(String.self, forKey: .currantBal)
		userSessionId = try values.decodeIfPresent(String.self, forKey: .userSessionId)
		userLogInKey = try values.decodeIfPresent(String.self, forKey: .userLogInKey)
		sucessStatus = try values.decodeIfPresent(String.self, forKey: .sucessStatus)
		dateFormat = try values.decodeIfPresent(String.self, forKey: .dateFormat)
		dateTimeFormate = try values.decodeIfPresent(String.self, forKey: .dateTimeFormate)
		isSupportPermission = try values.decodeIfPresent(String.self, forKey: .isSupportPermission)
		companyPhone = try values.decodeIfPresent(String.self, forKey: .companyPhone)
	}

}

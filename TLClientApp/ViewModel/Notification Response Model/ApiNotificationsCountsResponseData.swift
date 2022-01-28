/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
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

}

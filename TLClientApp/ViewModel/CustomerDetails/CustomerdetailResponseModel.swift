/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CustomerdetailResponseModel : Codable {
	let qBID : String?
	let qBEditID : String?
	let customerID : Int?
	let auditFlg : Int?
	let recordID : Int?
	let customerUserName : String?
	let customerFullName : String?
	let customerClassification : Int?
	let companyID : Int?
	let userID : Int?
	let password : String?
	let updateBy : String?
	let firstName : String?
	let lastName : String?
	let priority : Bool?
	let email : String?
	let jobTitle : String?
	let others : String?
	let officialCompany : String?
	let newOfficialCompany : String?
	let billingContactName : String?
	let billingPhone : String?
	let mobilePhone : String?
	let fAX : String?
	let website : String?
	let telephoneAccessCode : String?
	let customerimg : String?
	let notes : String?
	let isActive : Bool?
	let groupID : String?
	let address : CustomerAddressResponseModel?
	let custCheckList : CustomerCheckListresponseModel?
	let billing : CustomerBillingResponseModel?
	let settings : CustomerSettingsResponseModel?
	let tEMPLATEDATA : String?
	let active : Bool?
	let emailTemplate : String?
	let venueID : String?
	let billingExtension : String?
	let mobileExtension : String?
	let uniqueID : String?
	let isServiceVerificication : Bool?
	let cCEmail : String?
	let mobile : String?
	let userName : String?
	let addressLine1 : String?
	let addressLine2 : String?
	let city : String?
	let stateID : String?
	let stateName : String?
	let zipCode : String?
	let fullName : String?
	let willProvideTranslation : Bool?
	let willProvideOnsite : Bool?
	let invoiceBatch : Bool?
	let purchaseOrder : Bool?
	let claim : Bool?
	let reference : Bool?
	let createUser : String?
	let isSpecialtyVisible : Bool?
	let isLogisticsVisible : Bool?
	let quote : Bool?
	let isVriOpi : Bool?
	let isTelephonic : Bool?
	let clientID : String?
	let purchaseOrderNote : String?
	let isencounter : Bool?
	let willProvideVirtualMeeting : Bool?
	let emailToRequestor : Bool?
	let masterID : String?

	enum CodingKeys: String, CodingKey {

		case qBID = "QBID"
		case qBEditID = "QBEditID"
		case customerID = "CustomerID"
		case auditFlg = "AuditFlg"
		case recordID = "RecordID"
		case customerUserName = "CustomerUserName"
		case customerFullName = "CustomerFullName"
		case customerClassification = "CustomerClassification"
		case companyID = "CompanyID"
		case userID = "UserID"
		case password = "Password"
		case updateBy = "updateBy"
		case firstName = "FirstName"
		case lastName = "LastName"
		case priority = "Priority"
		case email = "Email"
		case jobTitle = "JobTitle"
		case others = "Others"
		case officialCompany = "OfficialCompany"
		case newOfficialCompany = "NewOfficialCompany"
		case billingContactName = "BillingContactName"
		case billingPhone = "BillingPhone"
		case mobilePhone = "MobilePhone"
		case fAX = "FAX"
		case website = "Website"
		case telephoneAccessCode = "TelephoneAccessCode"
		case customerimg = "customerimg"
		case notes = "Notes"
		case isActive = "IsActive"
		case groupID = "GroupID"
		case address = "Address"
		case custCheckList = "CustCheckList"
		case billing = "Billing"
		case settings = "Settings"
		case tEMPLATEDATA = "TEMPLATEDATA"
		case active = "Active"
		case emailTemplate = "EmailTemplate"
		case venueID = "VenueID"
		case billingExtension = "BillingExtension"
		case mobileExtension = "MobileExtension"
		case uniqueID = "UniqueID"
		case isServiceVerificication = "isServiceVerificication"
		case cCEmail = "CCEmail"
		case mobile = "Mobile"
		case userName = "UserName"
		case addressLine1 = "AddressLine1"
		case addressLine2 = "AddressLine2"
		case city = "City"
		case stateID = "StateID"
		case stateName = "StateName"
		case zipCode = "ZipCode"
		case fullName = "FullName"
		case willProvideTranslation = "WillProvideTranslation"
		case willProvideOnsite = "WillProvideOnsite"
		case invoiceBatch = "InvoiceBatch"
		case purchaseOrder = "PurchaseOrder"
		case claim = "Claim"
		case reference = "Reference"
		case createUser = "CreateUser"
		case isSpecialtyVisible = "IsSpecialtyVisible"
		case isLogisticsVisible = "IsLogisticsVisible"
		case quote = "Quote"
		case isVriOpi = "isVriOpi"
		case isTelephonic = "isTelephonic"
		case clientID = "ClientID"
		case purchaseOrderNote = "PurchaseOrderNote"
		case isencounter = "isencounter"
		case willProvideVirtualMeeting = "WillProvideVirtualMeeting"
		case emailToRequestor = "EmailToRequestor"
		case masterID = "MasterID"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		qBID = try values.decodeIfPresent(String.self, forKey: .qBID)
		qBEditID = try values.decodeIfPresent(String.self, forKey: .qBEditID)
		customerID = try values.decodeIfPresent(Int.self, forKey: .customerID)
		auditFlg = try values.decodeIfPresent(Int.self, forKey: .auditFlg)
		recordID = try values.decodeIfPresent(Int.self, forKey: .recordID)
		customerUserName = try values.decodeIfPresent(String.self, forKey: .customerUserName)
		customerFullName = try values.decodeIfPresent(String.self, forKey: .customerFullName)
		customerClassification = try values.decodeIfPresent(Int.self, forKey: .customerClassification)
		companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
		userID = try values.decodeIfPresent(Int.self, forKey: .userID)
		password = try values.decodeIfPresent(String.self, forKey: .password)
		updateBy = try values.decodeIfPresent(String.self, forKey: .updateBy)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		priority = try values.decodeIfPresent(Bool.self, forKey: .priority)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		jobTitle = try values.decodeIfPresent(String.self, forKey: .jobTitle)
		others = try values.decodeIfPresent(String.self, forKey: .others)
		officialCompany = try values.decodeIfPresent(String.self, forKey: .officialCompany)
		newOfficialCompany = try values.decodeIfPresent(String.self, forKey: .newOfficialCompany)
		billingContactName = try values.decodeIfPresent(String.self, forKey: .billingContactName)
		billingPhone = try values.decodeIfPresent(String.self, forKey: .billingPhone)
		mobilePhone = try values.decodeIfPresent(String.self, forKey: .mobilePhone)
		fAX = try values.decodeIfPresent(String.self, forKey: .fAX)
		website = try values.decodeIfPresent(String.self, forKey: .website)
		telephoneAccessCode = try values.decodeIfPresent(String.self, forKey: .telephoneAccessCode)
		customerimg = try values.decodeIfPresent(String.self, forKey: .customerimg)
		notes = try values.decodeIfPresent(String.self, forKey: .notes)
		isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
		groupID = try values.decodeIfPresent(String.self, forKey: .groupID)
		address = try values.decodeIfPresent(CustomerAddressResponseModel.self, forKey: .address)
		custCheckList = try values.decodeIfPresent(CustomerCheckListresponseModel.self, forKey: .custCheckList)
		billing = try values.decodeIfPresent(CustomerBillingResponseModel.self, forKey: .billing)
		settings = try values.decodeIfPresent(CustomerSettingsResponseModel.self, forKey: .settings)
		tEMPLATEDATA = try values.decodeIfPresent(String.self, forKey: .tEMPLATEDATA)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		emailTemplate = try values.decodeIfPresent(String.self, forKey: .emailTemplate)
		venueID = try values.decodeIfPresent(String.self, forKey: .venueID)
		billingExtension = try values.decodeIfPresent(String.self, forKey: .billingExtension)
		mobileExtension = try values.decodeIfPresent(String.self, forKey: .mobileExtension)
		uniqueID = try values.decodeIfPresent(String.self, forKey: .uniqueID)
		isServiceVerificication = try values.decodeIfPresent(Bool.self, forKey: .isServiceVerificication)
		cCEmail = try values.decodeIfPresent(String.self, forKey: .cCEmail)
		mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
		userName = try values.decodeIfPresent(String.self, forKey: .userName)
		addressLine1 = try values.decodeIfPresent(String.self, forKey: .addressLine1)
		addressLine2 = try values.decodeIfPresent(String.self, forKey: .addressLine2)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		stateID = try values.decodeIfPresent(String.self, forKey: .stateID)
		stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
		zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		willProvideTranslation = try values.decodeIfPresent(Bool.self, forKey: .willProvideTranslation)
		willProvideOnsite = try values.decodeIfPresent(Bool.self, forKey: .willProvideOnsite)
		invoiceBatch = try values.decodeIfPresent(Bool.self, forKey: .invoiceBatch)
		purchaseOrder = try values.decodeIfPresent(Bool.self, forKey: .purchaseOrder)
		claim = try values.decodeIfPresent(Bool.self, forKey: .claim)
		reference = try values.decodeIfPresent(Bool.self, forKey: .reference)
		createUser = try values.decodeIfPresent(String.self, forKey: .createUser)
		isSpecialtyVisible = try values.decodeIfPresent(Bool.self, forKey: .isSpecialtyVisible)
		isLogisticsVisible = try values.decodeIfPresent(Bool.self, forKey: .isLogisticsVisible)
		quote = try values.decodeIfPresent(Bool.self, forKey: .quote)
		isVriOpi = try values.decodeIfPresent(Bool.self, forKey: .isVriOpi)
		isTelephonic = try values.decodeIfPresent(Bool.self, forKey: .isTelephonic)
		clientID = try values.decodeIfPresent(String.self, forKey: .clientID)
		purchaseOrderNote = try values.decodeIfPresent(String.self, forKey: .purchaseOrderNote)
		isencounter = try values.decodeIfPresent(Bool.self, forKey: .isencounter)
		willProvideVirtualMeeting = try values.decodeIfPresent(Bool.self, forKey: .willProvideVirtualMeeting)
		emailToRequestor = try values.decodeIfPresent(Bool.self, forKey: .emailToRequestor)
		masterID = try values.decodeIfPresent(String.self, forKey: .masterID)
	}

}

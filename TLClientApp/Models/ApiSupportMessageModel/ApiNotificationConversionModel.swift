/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiNotificationConversionModel : Codable {
	let notificationId : String?
	let supportID : String?
	let email : String?
	let vendorPhoneId : String?
	let receiverID : String?
	let notification : String?
	let notificationType : String?
	let notificationRed : Bool?
	let isUpdated : Bool?
	let vendorName : String?
	let active : Bool?
	let interpreterIDsList : String?
	let createDate : String?
	let fromEmail : String?
	let senderID : String?
	let imageData : String?
	let userType : String?
	let userGroupID : Int?
	let companyId : String?
	let appointmentId : String?
	let senderby : String?
	let receiverby : String?
	let supportType : String?
	let categoryid : String?

	enum CodingKeys: String, CodingKey {

		case notificationId = "NotificationId"
		case supportID = "SupportID"
		case email = "Email"
		case vendorPhoneId = "VendorPhoneId"
		case receiverID = "ReceiverID"
		case notification = "Notification"
		case notificationType = "NotificationType"
		case notificationRed = "NotificationRed"
		case isUpdated = "IsUpdated"
		case vendorName = "VendorName"
		case active = "Active"
		case interpreterIDsList = "InterpreterIDsList"
		case createDate = "CreateDate"
		case fromEmail = "FromEmail"
		case senderID = "SenderID"
		case imageData = "ImageData"
		case userType = "UserType"
		case userGroupID = "UserGroupID"
		case companyId = "CompanyId"
		case appointmentId = "AppointmentId"
		case senderby = "Senderby"
		case receiverby = "Receiverby"
		case supportType = "SupportType"
		case categoryid = "categoryid"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		notificationId = try values.decodeIfPresent(String.self, forKey: .notificationId)
		supportID = try values.decodeIfPresent(String.self, forKey: .supportID)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		vendorPhoneId = try values.decodeIfPresent(String.self, forKey: .vendorPhoneId)
		receiverID = try values.decodeIfPresent(String.self, forKey: .receiverID)
		notification = try values.decodeIfPresent(String.self, forKey: .notification)
		notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
		notificationRed = try values.decodeIfPresent(Bool.self, forKey: .notificationRed)
		isUpdated = try values.decodeIfPresent(Bool.self, forKey: .isUpdated)
		vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		interpreterIDsList = try values.decodeIfPresent(String.self, forKey: .interpreterIDsList)
		createDate = try values.decodeIfPresent(String.self, forKey: .createDate)
		fromEmail = try values.decodeIfPresent(String.self, forKey: .fromEmail)
		senderID = try values.decodeIfPresent(String.self, forKey: .senderID)
		imageData = try values.decodeIfPresent(String.self, forKey: .imageData)
		userType = try values.decodeIfPresent(String.self, forKey: .userType)
		userGroupID = try values.decodeIfPresent(Int.self, forKey: .userGroupID)
		companyId = try values.decodeIfPresent(String.self, forKey: .companyId)
		appointmentId = try values.decodeIfPresent(String.self, forKey: .appointmentId)
		senderby = try values.decodeIfPresent(String.self, forKey: .senderby)
		receiverby = try values.decodeIfPresent(String.self, forKey: .receiverby)
		supportType = try values.decodeIfPresent(String.self, forKey: .supportType)
		categoryid = try values.decodeIfPresent(String.self, forKey: .categoryid)
	}

}

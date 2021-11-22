/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiVRIOPICallLogDataModel : Codable {
	let roomNo : String?
	let fromUser : Int?
	let toUser : Int?
	let startTime : String?
	let endTime : String?
	let duration : String?
	let roundedDuration : String?
	let datecreated : String?
	let leaveoutstatus : Int?
	let senderleaveoutstatus : Int?
	let languageId : Int?
	let languageName : String?
	let vendorName : String?
	let customerName : String?
	let billRate : String?
	let totalRate : String?
	let spin : String?
	let statustype : String?
	let decspt : Bool?
	let caseName : String?
	let caseNumber : String?
	let callQuality : String?
	let vriRating : String?
	let vrating : String?
	let vcallquality : String?
	let id : Int?
	let inHouseTotal : Int?
	let thirdPartyTotal : String?
	let usertoken : String?
	let sourceLanguage : String?
	let clientID : String?
	let cvendor : String?
	let customerRate : String?
	let departmentName : String?
	let contactName : String?

	enum CodingKeys: String, CodingKey {

		case roomNo = "RoomNo"
		case fromUser = "FromUser"
		case toUser = "ToUser"
		case startTime = "StartTime"
		case endTime = "EndTime"
		case duration = "Duration"
		case roundedDuration = "RoundedDuration"
		case datecreated = "Datecreated"
		case leaveoutstatus = "leaveoutstatus"
		case senderleaveoutstatus = "senderleaveoutstatus"
		case languageId = "LanguageId"
		case languageName = "LanguageName"
		case vendorName = "VendorName"
		case customerName = "CustomerName"
		case billRate = "BillRate"
		case totalRate = "TotalRate"
		case spin = "Spin"
		case statustype = "Statustype"
		case decspt = "decspt"
		case caseName = "CaseName"
		case caseNumber = "CaseNumber"
		case callQuality = "CallQuality"
		case vriRating = "VriRating"
		case vrating = "vrating"
		case vcallquality = "vcallquality"
		case id = "Id"
		case inHouseTotal = "InHouseTotal"
		case thirdPartyTotal = "ThirdPartyTotal"
		case usertoken = "usertoken"
		case sourceLanguage = "SourceLanguage"
		case clientID = "ClientID"
		case cvendor = "Cvendor"
		case customerRate = "CustomerRate"
		case departmentName = "DepartmentName"
		case contactName = "ContactName"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		roomNo = try values.decodeIfPresent(String.self, forKey: .roomNo)
		fromUser = try values.decodeIfPresent(Int.self, forKey: .fromUser)
		toUser = try values.decodeIfPresent(Int.self, forKey: .toUser)
		startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
		endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
		duration = try values.decodeIfPresent(String.self, forKey: .duration)
		roundedDuration = try values.decodeIfPresent(String.self, forKey: .roundedDuration)
		datecreated = try values.decodeIfPresent(String.self, forKey: .datecreated)
		leaveoutstatus = try values.decodeIfPresent(Int.self, forKey: .leaveoutstatus)
		senderleaveoutstatus = try values.decodeIfPresent(Int.self, forKey: .senderleaveoutstatus)
		languageId = try values.decodeIfPresent(Int.self, forKey: .languageId)
		languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
		vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
		customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		billRate = try values.decodeIfPresent(String.self, forKey: .billRate)
		totalRate = try values.decodeIfPresent(String.self, forKey: .totalRate)
		spin = try values.decodeIfPresent(String.self, forKey: .spin)
		statustype = try values.decodeIfPresent(String.self, forKey: .statustype)
		decspt = try values.decodeIfPresent(Bool.self, forKey: .decspt)
		caseName = try values.decodeIfPresent(String.self, forKey: .caseName)
		caseNumber = try values.decodeIfPresent(String.self, forKey: .caseNumber)
		callQuality = try values.decodeIfPresent(String.self, forKey: .callQuality)
		vriRating = try values.decodeIfPresent(String.self, forKey: .vriRating)
		vrating = try values.decodeIfPresent(String.self, forKey: .vrating)
		vcallquality = try values.decodeIfPresent(String.self, forKey: .vcallquality)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		inHouseTotal = try values.decodeIfPresent(Int.self, forKey: .inHouseTotal)
		thirdPartyTotal = try values.decodeIfPresent(String.self, forKey: .thirdPartyTotal)
		usertoken = try values.decodeIfPresent(String.self, forKey: .usertoken)
		sourceLanguage = try values.decodeIfPresent(String.self, forKey: .sourceLanguage)
		clientID = try values.decodeIfPresent(String.self, forKey: .clientID)
		cvendor = try values.decodeIfPresent(String.self, forKey: .cvendor)
		customerRate = try values.decodeIfPresent(String.self, forKey: .customerRate)
		departmentName = try values.decodeIfPresent(String.self, forKey: .departmentName)
		contactName = try values.decodeIfPresent(String.self, forKey: .contactName)
	}

}

/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiCLASSIFICATIONDetails : Codable {
	let customerUserID : Int?
	let recordID : Int?
	let userName : String?
	let password : String?
	let fullName : String?
	let firstName : String?
	let lastName : String?
	let officialCompanyName : String?
	let billingContactName : String?
	let email : String?
	let billingPhone : String?
	let mobilePhone : String?
	let fax : String?
	let website : String?
	let telephoneAccessCode : Int?
	let note : String?
	let groupID : Int?
	let isActive : Bool?
	let customerID : Int?
	let userID : Int?
	let id : Int?
	let customerClassification : String?
	let classification : String?
	//let extension : String?
	let address : String?
	let settings : String?

	enum CodingKeys: String, CodingKey {

		case customerUserID = "CustomerUserID"
		case recordID = "RecordID"
		case userName = "UserName"
		case password = "Password"
		case fullName = "FullName"
		case firstName = "FirstName"
		case lastName = "LastName"
		case officialCompanyName = "OfficialCompanyName"
		case billingContactName = "BillingContactName"
		case email = "Email"
		case billingPhone = "BillingPhone"
		case mobilePhone = "MobilePhone"
		case fax = "Fax"
		case website = "Website"
		case telephoneAccessCode = "TelephoneAccessCode"
		case note = "Note"
		case groupID = "GroupID"
		case isActive = "IsActive"
		case customerID = "CustomerID"
		case userID = "UserID"
		case id = "id"
		case customerClassification = "CustomerClassification"
		case classification = "classification"
		//case extension = "Extension"
		case address = "Address"
		case settings = "Settings"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerUserID = try values.decodeIfPresent(Int.self, forKey: .customerUserID)
		recordID = try values.decodeIfPresent(Int.self, forKey: .recordID)
		userName = try values.decodeIfPresent(String.self, forKey: .userName)
		password = try values.decodeIfPresent(String.self, forKey: .password)
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		officialCompanyName = try values.decodeIfPresent(String.self, forKey: .officialCompanyName)
		billingContactName = try values.decodeIfPresent(String.self, forKey: .billingContactName)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		billingPhone = try values.decodeIfPresent(String.self, forKey: .billingPhone)
		mobilePhone = try values.decodeIfPresent(String.self, forKey: .mobilePhone)
		fax = try values.decodeIfPresent(String.self, forKey: .fax)
		website = try values.decodeIfPresent(String.self, forKey: .website)
		telephoneAccessCode = try values.decodeIfPresent(Int.self, forKey: .telephoneAccessCode)
		note = try values.decodeIfPresent(String.self, forKey: .note)
		groupID = try values.decodeIfPresent(Int.self, forKey: .groupID)
		isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
		customerID = try values.decodeIfPresent(Int.self, forKey: .customerID)
		userID = try values.decodeIfPresent(Int.self, forKey: .userID)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		customerClassification = try values.decodeIfPresent(String.self, forKey: .customerClassification)
		classification = try values.decodeIfPresent(String.self, forKey: .classification)
		//extension = try values.decodeIfPresent(String.self, forKey: .extension)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		settings = try values.decodeIfPresent(String.self, forKey: .settings)
	}

}

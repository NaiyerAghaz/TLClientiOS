/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiUSERLOGOSDataModel : Codable {
	let success : Int?
	let companyLogo : String?
	let imageData : String?
	let isAcceptedAgreement : Bool?
	let agentOnline : Bool?
	let passwordResetStatus : Int?
	let userName : String?
	let firstName : String?
	let lastName : String?
	let email : String?
	let phone : String?
	let newRegFlag : Int?
	let companyNameTemp : String?
	let companyPhone : String?

	enum CodingKeys: String, CodingKey {

		case success = "success"
		case companyLogo = "CompanyLogo"
		case imageData = "ImageData"
		case isAcceptedAgreement = "IsAcceptedAgreement"
		case agentOnline = "AgentOnline"
		case passwordResetStatus = "PasswordResetStatus"
		case userName = "UserName"
		case firstName = "FirstName"
		case lastName = "LastName"
		case email = "Email"
		case phone = "Phone"
		case newRegFlag = "NewRegFlag"
		case companyNameTemp = "CompanyNameTemp"
		case companyPhone = "CompanyPhone"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		success = try values.decodeIfPresent(Int.self, forKey: .success)
		companyLogo = try values.decodeIfPresent(String.self, forKey: .companyLogo)
		imageData = try values.decodeIfPresent(String.self, forKey: .imageData)
		isAcceptedAgreement = try values.decodeIfPresent(Bool.self, forKey: .isAcceptedAgreement)
		agentOnline = try values.decodeIfPresent(Bool.self, forKey: .agentOnline)
		passwordResetStatus = try values.decodeIfPresent(Int.self, forKey: .passwordResetStatus)
		userName = try values.decodeIfPresent(String.self, forKey: .userName)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		newRegFlag = try values.decodeIfPresent(Int.self, forKey: .newRegFlag)
		companyNameTemp = try values.decodeIfPresent(String.self, forKey: .companyNameTemp)
		companyPhone = try values.decodeIfPresent(String.self, forKey: .companyPhone)
	}

}

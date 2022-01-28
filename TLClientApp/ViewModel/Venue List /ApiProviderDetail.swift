/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiProviderDetail : Codable {
	let providerID : Int?
	let departmentID : Int?
	let companyID : Int?
	let venueID : Int?
	let venueName : String?
	let departmentName : String?
	let providerName : String?
	let customerCompany : String?
	let customerName : String?
	let active : Bool?
	let userid : String?
	let flag : String?

	enum CodingKeys: String, CodingKey {

		case providerID = "ProviderID"
		case departmentID = "DepartmentID"
		case companyID = "CompanyID"
		case venueID = "VenueID"
		case venueName = "VenueName"
		case departmentName = "DepartmentName"
		case providerName = "ProviderName"
		case customerCompany = "CustomerCompany"
		case customerName = "CustomerName"
		case active = "Active"
		case userid = "Userid"
		case flag = "Flag"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		providerID = try values.decodeIfPresent(Int.self, forKey: .providerID)
		departmentID = try values.decodeIfPresent(Int.self, forKey: .departmentID)
		companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
		venueID = try values.decodeIfPresent(Int.self, forKey: .venueID)
		venueName = try values.decodeIfPresent(String.self, forKey: .venueName)
		departmentName = try values.decodeIfPresent(String.self, forKey: .departmentName)
		providerName = try values.decodeIfPresent(String.self, forKey: .providerName)
		customerCompany = try values.decodeIfPresent(String.self, forKey: .customerCompany)
		customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		userid = try values.decodeIfPresent(String.self, forKey: .userid)
		flag = try values.decodeIfPresent(String.self, forKey: .flag)
	}

}

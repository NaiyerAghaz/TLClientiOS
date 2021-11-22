/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiDepartmentData : Codable {
	let departmentID : Int?
	let companyID : Int?
	let userID : Int?
	let venueID : Int?
	let venueName : String?
	let departmentName : String?
	let customerCompany : String?
	let customerName : String?
	let active : Bool?
	let deActive : Bool?

	enum CodingKeys: String, CodingKey {

		case departmentID = "DepartmentID"
		case companyID = "CompanyID"
		case userID = "UserID"
		case venueID = "VenueID"
		case venueName = "VenueName"
		case departmentName = "DepartmentName"
		case customerCompany = "CustomerCompany"
		case customerName = "CustomerName"
		case active = "Active"
		case deActive = "DeActive"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		departmentID = try values.decodeIfPresent(Int.self, forKey: .departmentID)
		companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
		userID = try values.decodeIfPresent(Int.self, forKey: .userID)
		venueID = try values.decodeIfPresent(Int.self, forKey: .venueID)
		venueName = try values.decodeIfPresent(String.self, forKey: .venueName)
		departmentName = try values.decodeIfPresent(String.self, forKey: .departmentName)
		customerCompany = try values.decodeIfPresent(String.self, forKey: .customerCompany)
		customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		deActive = try values.decodeIfPresent(Bool.self, forKey: .deActive)
	}

}

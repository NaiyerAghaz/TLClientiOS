/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiGetAllVenuListResponse : Codable {
	let venueID : Int?
	let displayValue : String?
	let userID : String?
	let companyID : Int?
	let isDefault : String?
	let venueName : String?
	let customerCompany : String?
	let customerName : String?
	let address : String?
	let address2 : String?
	let city : String?
	let state : String?
	let stateID : Int?
	let zipCode : String?
	let notes : String?
	let active : String?

	enum CodingKeys: String, CodingKey {

		case venueID = "VenueID"
		case displayValue = "DisplayValue"
		case userID = "UserID"
		case companyID = "CompanyID"
		case isDefault = "IsDefault"
		case venueName = "VenueName"
		case customerCompany = "CustomerCompany"
		case customerName = "CustomerName"
		case address = "Address"
		case address2 = "Address2"
		case city = "City"
		case state = "State"
		case stateID = "StateID"
		case zipCode = "ZipCode"
		case notes = "Notes"
		case active = "Active"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		venueID = try values.decodeIfPresent(Int.self, forKey: .venueID)
		displayValue = try values.decodeIfPresent(String.self, forKey: .displayValue)
		userID = try values.decodeIfPresent(String.self, forKey: .userID)
		companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
		isDefault = try values.decodeIfPresent(String.self, forKey: .isDefault)
		venueName = try values.decodeIfPresent(String.self, forKey: .venueName)
		customerCompany = try values.decodeIfPresent(String.self, forKey: .customerCompany)
		customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		address2 = try values.decodeIfPresent(String.self, forKey: .address2)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		stateID = try values.decodeIfPresent(Int.self, forKey: .stateID)
		zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
		notes = try values.decodeIfPresent(String.self, forKey: .notes)
		active = try values.decodeIfPresent(String.self, forKey: .active)
	}

}

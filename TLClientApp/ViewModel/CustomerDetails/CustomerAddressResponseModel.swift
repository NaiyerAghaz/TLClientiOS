/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CustomerAddressResponseModel : Codable {
	let customerAddressID : Int?
	let recordID : String?
	let address1 : String?
	let address2 : String?
	let address3 : String?
	let city : String?
	let stateID : Int?
	let stateName : String?
	let zipCode : String?
	let isSameBillingAddress : Bool?
	let billingAddress : String?
	let billingCity : String?
	let billingStateID : Int?
	let billingStateName : String?
	let billingZipCode : String?
	let active : Bool?
	let userID : String?

	enum CodingKeys: String, CodingKey {

		case customerAddressID = "CustomerAddressID"
		case recordID = "RecordID"
		case address1 = "Address1"
		case address2 = "Address2"
		case address3 = "Address3"
		case city = "City"
		case stateID = "StateID"
		case stateName = "StateName"
		case zipCode = "ZipCode"
		case isSameBillingAddress = "IsSameBillingAddress"
		case billingAddress = "BillingAddress"
		case billingCity = "BillingCity"
		case billingStateID = "BillingStateID"
		case billingStateName = "BillingStateName"
		case billingZipCode = "BillingZipCode"
		case active = "Active"
		case userID = "UserID"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerAddressID = try values.decodeIfPresent(Int.self, forKey: .customerAddressID)
		recordID = try values.decodeIfPresent(String.self, forKey: .recordID)
		address1 = try values.decodeIfPresent(String.self, forKey: .address1)
		address2 = try values.decodeIfPresent(String.self, forKey: .address2)
		address3 = try values.decodeIfPresent(String.self, forKey: .address3)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		stateID = try values.decodeIfPresent(Int.self, forKey: .stateID)
		stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
		zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
		isSameBillingAddress = try values.decodeIfPresent(Bool.self, forKey: .isSameBillingAddress)
		billingAddress = try values.decodeIfPresent(String.self, forKey: .billingAddress)
		billingCity = try values.decodeIfPresent(String.self, forKey: .billingCity)
		billingStateID = try values.decodeIfPresent(Int.self, forKey: .billingStateID)
		billingStateName = try values.decodeIfPresent(String.self, forKey: .billingStateName)
		billingZipCode = try values.decodeIfPresent(String.self, forKey: .billingZipCode)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		userID = try values.decodeIfPresent(String.self, forKey: .userID)
	}

}

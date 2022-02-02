/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiScheduleVRIDataModel : Codable {
	let success : Int?
	let fastTrackOrNot : String?
	let currentLabel : String?
	let appointmentID : String?
	let vendorCount : String?
	let customerCount : String?
	let appointmentCount : String?
	let staffCount : String?
	let vriCount : String?
	let todayAppointmentCount : String?

	enum CodingKeys: String, CodingKey {

		case success = "success"
		case fastTrackOrNot = "FastTrackOrNot"
		case currentLabel = "currentLabel"
		case appointmentID = "appointmentID"
		case vendorCount = "VendorCount"
		case customerCount = "CustomerCount"
		case appointmentCount = "AppointmentCount"
		case staffCount = "StaffCount"
		case vriCount = "VriCount"
		case todayAppointmentCount = "TodayAppointmentCount"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		success = try values.decodeIfPresent(Int.self, forKey: .success)
		fastTrackOrNot = try values.decodeIfPresent(String.self, forKey: .fastTrackOrNot)
		currentLabel = try values.decodeIfPresent(String.self, forKey: .currentLabel)
		appointmentID = try values.decodeIfPresent(String.self, forKey: .appointmentID)
		vendorCount = try values.decodeIfPresent(String.self, forKey: .vendorCount)
		customerCount = try values.decodeIfPresent(String.self, forKey: .customerCount)
		appointmentCount = try values.decodeIfPresent(String.self, forKey: .appointmentCount)
		staffCount = try values.decodeIfPresent(String.self, forKey: .staffCount)
		vriCount = try values.decodeIfPresent(String.self, forKey: .vriCount)
		todayAppointmentCount = try values.decodeIfPresent(String.self, forKey: .todayAppointmentCount)
	}

}

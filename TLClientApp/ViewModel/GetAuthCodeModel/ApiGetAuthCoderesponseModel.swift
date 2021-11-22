/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiGetAuthCoderesponseModel : Codable {
	let authenticationCode : [AuthenticationCodeDataModel]?
	let appointmentType : [AppointmentTypeDataModel]?
	let documentTranslationJobType : [DocumentTranslationJobTypeDataModel]?
	let appointmentStatus : [AppointmentStatusDataModel]?
	let gender : [GenderDataModel]?
	let vendorRanking : [VendorRankingDataModel]?
	let travelMiles : [TravelMilesDataModel]?

	enum CodingKeys: String, CodingKey {

		case authenticationCode = "AuthenticationCode"
		case appointmentType = "AppointmentType"
		case documentTranslationJobType = "DocumentTranslationJobType"
		case appointmentStatus = "AppointmentStatus"
		case gender = "Gender"
		case vendorRanking = "VendorRanking"
		case travelMiles = "TravelMiles"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		authenticationCode = try values.decodeIfPresent([AuthenticationCodeDataModel].self, forKey: .authenticationCode)
		appointmentType = try values.decodeIfPresent([AppointmentTypeDataModel].self, forKey: .appointmentType)
		documentTranslationJobType = try values.decodeIfPresent([DocumentTranslationJobTypeDataModel].self, forKey: .documentTranslationJobType)
		appointmentStatus = try values.decodeIfPresent([AppointmentStatusDataModel].self, forKey: .appointmentStatus)
		gender = try values.decodeIfPresent([GenderDataModel].self, forKey: .gender)
		vendorRanking = try values.decodeIfPresent([VendorRankingDataModel].self, forKey: .vendorRanking)
		travelMiles = try values.decodeIfPresent([TravelMilesDataModel].self, forKey: .travelMiles)
	}

}

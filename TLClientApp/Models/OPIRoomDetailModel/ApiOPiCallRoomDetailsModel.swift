/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiOPiCallRoomDetailsModel : Codable {
	let roomNo : String?
	let fromUser : Int?
	let targetLName : String?
	let slname : String?
	let clientName : String?
	let vendorName : String?
	let clientImage : String?
	let vendorImage : String?

	enum CodingKeys: String, CodingKey {

		case roomNo = "RoomNo"
		case fromUser = "FromUser"
		case targetLName = "TargetLName"
		case slname = "Slname"
		case clientName = "ClientName"
		case vendorName = "VendorName"
		case clientImage = "ClientImage"
		case vendorImage = "VendorImage"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		roomNo = try values.decodeIfPresent(String.self, forKey: .roomNo)
		fromUser = try values.decodeIfPresent(Int.self, forKey: .fromUser)
		targetLName = try values.decodeIfPresent(String.self, forKey: .targetLName)
		slname = try values.decodeIfPresent(String.self, forKey: .slname)
		clientName = try values.decodeIfPresent(String.self, forKey: .clientName)
		vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
		clientImage = try values.decodeIfPresent(String.self, forKey: .clientImage)
		vendorImage = try values.decodeIfPresent(String.self, forKey: .vendorImage)
	}

}

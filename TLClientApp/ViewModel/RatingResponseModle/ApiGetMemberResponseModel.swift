/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiGetMemberResponseModel : Codable {
	let custID : Int?
	let vendorName : String?
	let sourcelanguageName : String?
	let customerName : String?
	let vendorImg : String?
	let languageName : String?
	let vendorName1 : String?
	let custImg : String?
	let vendID : Int?
	let lID : Int?
	let roomno : String?
	let duration : String?

	enum CodingKeys: String, CodingKey {

		case custID = "CustID"
		case vendorName = "VendorName"
		case sourcelanguageName = "SourcelanguageName"
		case customerName = "customerName"
		case vendorImg = "vendorImg"
		case languageName = "languageName"
		case vendorName1 = "VendorName1"
		case custImg = "CustImg"
		case vendID = "VendID"
		case lID = "LID"
		case roomno = "roomno"
		case duration = "duration"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		custID = try values.decodeIfPresent(Int.self, forKey: .custID)
		vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
		sourcelanguageName = try values.decodeIfPresent(String.self, forKey: .sourcelanguageName)
		customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		vendorImg = try values.decodeIfPresent(String.self, forKey: .vendorImg)
		languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
		vendorName1 = try values.decodeIfPresent(String.self, forKey: .vendorName1)
		custImg = try values.decodeIfPresent(String.self, forKey: .custImg)
		vendID = try values.decodeIfPresent(Int.self, forKey: .vendID)
		lID = try values.decodeIfPresent(Int.self, forKey: .lID)
		roomno = try values.decodeIfPresent(String.self, forKey: .roomno)
		duration = try values.decodeIfPresent(String.self, forKey: .duration)
	}

}

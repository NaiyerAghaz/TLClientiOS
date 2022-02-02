/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiMeetResultDataModel : Codable {
	let rOOMNO : String?
	let cLIENTSTATUS : Int?
	let dURATION : Int?
	let iNVITESTATUS : Int?
	let iNVITECOUNT : Int?
	let iNVITEDATA : Int?

	enum CodingKeys: String, CodingKey {

		case rOOMNO = "ROOMNO"
		case cLIENTSTATUS = "CLIENTSTATUS"
		case dURATION = "DURATION"
		case iNVITESTATUS = "INVITESTATUS"
		case iNVITECOUNT = "INVITECOUNT"
		case iNVITEDATA = "INVITEDATA"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		rOOMNO = try values.decodeIfPresent(String.self, forKey: .rOOMNO)
		cLIENTSTATUS = try values.decodeIfPresent(Int.self, forKey: .cLIENTSTATUS)
		dURATION = try values.decodeIfPresent(Int.self, forKey: .dURATION)
		iNVITESTATUS = try values.decodeIfPresent(Int.self, forKey: .iNVITESTATUS)
		iNVITECOUNT = try values.decodeIfPresent(Int.self, forKey: .iNVITECOUNT)
		iNVITEDATA = try values.decodeIfPresent(Int.self, forKey: .iNVITEDATA)
	}

}

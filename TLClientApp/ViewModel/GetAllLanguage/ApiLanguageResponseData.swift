/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiLanguageResponseData : Codable {
	let languageID : Int?
	let languageName : String?
	let active : Bool?
	let type : String?
	let rate : Int?
	let vendorLanguageID : String?
	let languageColorCode : String?

	enum CodingKeys: String, CodingKey {

		case languageID = "LanguageID"
		case languageName = "LanguageName"
		case active = "Active"
		case type = "Type"
		case rate = "Rate"
		case vendorLanguageID = "VendorLanguageID"
		case languageColorCode = "LanguageColorCode"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		languageID = try values.decodeIfPresent(Int.self, forKey: .languageID)
		languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		rate = try values.decodeIfPresent(Int.self, forKey: .rate)
		vendorLanguageID = try values.decodeIfPresent(String.self, forKey: .vendorLanguageID)
		languageColorCode = try values.decodeIfPresent(String.self, forKey: .languageColorCode)
	}

}

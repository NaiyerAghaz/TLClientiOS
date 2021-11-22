/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SpecialityDataModel : Codable {
	let specialityID : Int?
	let displayValue : String?
	let companyID : Int?
	let isDefault : Bool?
	let duration : String?
	let active : Bool?
	//let internal : Bool?
	let checkList : String?
	let interpretationType : String?
	let sType : String?
	let interpretationTypeID : String?
	let interpretationID : String?
	let specialityExperience : String?

	enum CodingKeys: String, CodingKey {

		case specialityID = "SpecialityID"
		case displayValue = "DisplayValue"
		case companyID = "CompanyID"
		case isDefault = "IsDefault"
		case duration = "Duration"
		case active = "Active"
		//case internal = "Internal"
		case checkList = "CheckList"
		case interpretationType = "InterpretationType"
		case sType = "SType"
		case interpretationTypeID = "InterpretationTypeID"
		case interpretationID = "InterpretationID"
		case specialityExperience = "SpecialityExperience"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		specialityID = try values.decodeIfPresent(Int.self, forKey: .specialityID)
		displayValue = try values.decodeIfPresent(String.self, forKey: .displayValue)
		companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
		isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
		duration = try values.decodeIfPresent(String.self, forKey: .duration)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		//internal = try values.decodeIfPresent(Bool.self, forKey: .internal)
		checkList = try values.decodeIfPresent(String.self, forKey: .checkList)
		interpretationType = try values.decodeIfPresent(String.self, forKey: .interpretationType)
		sType = try values.decodeIfPresent(String.self, forKey: .sType)
		interpretationTypeID = try values.decodeIfPresent(String.self, forKey: .interpretationTypeID)
		interpretationID = try values.decodeIfPresent(String.self, forKey: .interpretationID)
		specialityExperience = try values.decodeIfPresent(String.self, forKey: .specialityExperience)
	}

}

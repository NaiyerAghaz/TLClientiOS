/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct APIResultModel : Codable {
	let uSERID : Int?
	let cNAME : String?
	let cLOGO : String?
	let fULLNAME : String?
	let pARTCOUNT : Int?
	let sHAREACCESS : Bool?
	let eMAILFA : Bool?
	let mOBILEFA : Bool?
	let nOFA : Bool?
	let uSERIMAGE : String?
	let rECORDING : Bool?

	enum CodingKeys: String, CodingKey {

		case uSERID = "USERID"
		case cNAME = "CNAME"
		case cLOGO = "CLOGO"
		case fULLNAME = "FULLNAME"
		case pARTCOUNT = "PARTCOUNT"
		case sHAREACCESS = "SHAREACCESS"
		case eMAILFA = "EMAILFA"
		case mOBILEFA = "MOBILEFA"
		case nOFA = "NOFA"
		case uSERIMAGE = "USERIMAGE"
		case rECORDING = "RECORDING"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		uSERID = try values.decodeIfPresent(Int.self, forKey: .uSERID)
		cNAME = try values.decodeIfPresent(String.self, forKey: .cNAME)
		cLOGO = try values.decodeIfPresent(String.self, forKey: .cLOGO)
		fULLNAME = try values.decodeIfPresent(String.self, forKey: .fULLNAME)
		pARTCOUNT = try values.decodeIfPresent(Int.self, forKey: .pARTCOUNT)
		sHAREACCESS = try values.decodeIfPresent(Bool.self, forKey: .sHAREACCESS)
		eMAILFA = try values.decodeIfPresent(Bool.self, forKey: .eMAILFA)
		mOBILEFA = try values.decodeIfPresent(Bool.self, forKey: .mOBILEFA)
		nOFA = try values.decodeIfPresent(Bool.self, forKey: .nOFA)
		uSERIMAGE = try values.decodeIfPresent(String.self, forKey: .uSERIMAGE)
		rECORDING = try values.decodeIfPresent(Bool.self, forKey: .rECORDING)
	}

}

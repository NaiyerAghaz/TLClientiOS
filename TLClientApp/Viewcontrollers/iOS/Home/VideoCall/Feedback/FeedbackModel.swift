

import Foundation
struct APIGetfeedbackDetail : Codable {
    let getMembers : [GetMembers]?

    enum CodingKeys: String, CodingKey {

        case getMembers = "GetMembers"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        getMembers = try values.decodeIfPresent([GetMembers].self, forKey: .getMembers)
    }

}
struct GetMembers : Codable {
	let custID : Int?
	let customerName : String?
	let vendorImg : String?
	let languageName : String?
	let vendorName : String?
	let custImg : String?
	let sourcelanguageName : String?
	let vendID : Int?
	let lID : Int?
	let roomno : String?
	let duration : String?

	enum CodingKeys: String, CodingKey {

		case custID = "CustID"
		case customerName = "customerName"
		case vendorImg = "vendorImg"
		case languageName = "languageName"
		case vendorName = "VendorName"
		case custImg = "CustImg"
		case sourcelanguageName = "SourcelanguageName"
		case vendID = "VendID"
		case lID = "LID"
		case roomno = "roomno"
		case duration = "duration"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		custID = try values.decodeIfPresent(Int.self, forKey: .custID)
		customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		vendorImg = try values.decodeIfPresent(String.self, forKey: .vendorImg)
		languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
		vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
		custImg = try values.decodeIfPresent(String.self, forKey: .custImg)
		sourcelanguageName = try values.decodeIfPresent(String.self, forKey: .sourcelanguageName)
		vendID = try values.decodeIfPresent(Int.self, forKey: .vendID)
		lID = try values.decodeIfPresent(Int.self, forKey: .lID)
		roomno = try values.decodeIfPresent(String.self, forKey: .roomno)
		duration = try values.decodeIfPresent(String.self, forKey: .duration)
	}

}


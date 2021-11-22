/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CustomerSettingsResponseModel : Codable {
	let customerSettingID : Int?
	let customerID : Int?
	let emailforEdit : Bool?
	let emailforRequest : Bool?
	let emailforCancelled : Bool?
	let textMsgforRequest : Bool?
	let textMsgforCancelled : Bool?
	let textMsgforOneHour : Bool?
	let emailforBothced : Bool?
	let emailforLateCancelled : Bool?
	let textMsgforBothced : Bool?
	let textMsgforLateCancelled : Bool?
	let active : Bool?
	let textMsgForBooked : Bool?
	let translationByWord : Bool?
	let transcription : Bool?
	let transcriptionwithTranslation : Bool?
	let translationByPage : Bool?
	let translationByPageAndNotarization : Bool?

	enum CodingKeys: String, CodingKey {

		case customerSettingID = "CustomerSettingID"
		case customerID = "CustomerID"
		case emailforEdit = "EmailforEdit"
		case emailforRequest = "EmailforRequest"
		case emailforCancelled = "EmailforCancelled"
		case textMsgforRequest = "TextMsgforRequest"
		case textMsgforCancelled = "TextMsgforCancelled"
		case textMsgforOneHour = "TextMsgforOneHour"
		case emailforBothced = "EmailforBothced"
		case emailforLateCancelled = "EmailforLateCancelled"
		case textMsgforBothced = "TextMsgforBothced"
		case textMsgforLateCancelled = "TextMsgforLateCancelled"
		case active = "Active"
		case textMsgForBooked = "TextMsgForBooked"
		case translationByWord = "TranslationByWord"
		case transcription = "Transcription"
		case transcriptionwithTranslation = "TranscriptionwithTranslation"
		case translationByPage = "TranslationByPage"
		case translationByPageAndNotarization = "TranslationByPageAndNotarization"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerSettingID = try values.decodeIfPresent(Int.self, forKey: .customerSettingID)
		customerID = try values.decodeIfPresent(Int.self, forKey: .customerID)
		emailforEdit = try values.decodeIfPresent(Bool.self, forKey: .emailforEdit)
		emailforRequest = try values.decodeIfPresent(Bool.self, forKey: .emailforRequest)
		emailforCancelled = try values.decodeIfPresent(Bool.self, forKey: .emailforCancelled)
		textMsgforRequest = try values.decodeIfPresent(Bool.self, forKey: .textMsgforRequest)
		textMsgforCancelled = try values.decodeIfPresent(Bool.self, forKey: .textMsgforCancelled)
		textMsgforOneHour = try values.decodeIfPresent(Bool.self, forKey: .textMsgforOneHour)
		emailforBothced = try values.decodeIfPresent(Bool.self, forKey: .emailforBothced)
		emailforLateCancelled = try values.decodeIfPresent(Bool.self, forKey: .emailforLateCancelled)
		textMsgforBothced = try values.decodeIfPresent(Bool.self, forKey: .textMsgforBothced)
		textMsgforLateCancelled = try values.decodeIfPresent(Bool.self, forKey: .textMsgforLateCancelled)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		textMsgForBooked = try values.decodeIfPresent(Bool.self, forKey: .textMsgForBooked)
		translationByWord = try values.decodeIfPresent(Bool.self, forKey: .translationByWord)
		transcription = try values.decodeIfPresent(Bool.self, forKey: .transcription)
		transcriptionwithTranslation = try values.decodeIfPresent(Bool.self, forKey: .transcriptionwithTranslation)
		translationByPage = try values.decodeIfPresent(Bool.self, forKey: .translationByPage)
		translationByPageAndNotarization = try values.decodeIfPresent(Bool.self, forKey: .translationByPageAndNotarization)
	}

}

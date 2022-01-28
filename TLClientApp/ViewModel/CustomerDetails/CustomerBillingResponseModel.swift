/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CustomerBillingResponseModel : Codable {
	let customerBillingID : Int?
	let customerID : Int?
	let recordID : Int?
	let tierNameID : Int?
	let oSMinMinutesBilled : Int?
	let oSMinutesRounding : Int?
	let oSIsCancellationFee : Bool?
	let oSMinCancellationMinutes : Int?
	let oSCancellationFee : Int?
	let oSIsPriority : Bool?
	let oSPriorityFeeHourly : Int?
	let perHourFee : Double?
	let oSIsMillage : Bool?
	let oSMinMile : Int?
	let oSMaxMile : Int?
	let oSPerMileBill : Int?
	let oSIsTravelling : Bool?
	let oSTravelMinMinutes : Int?
	let oSTravelMaxMinutes : Int?
	let oSTravelRatePerHour : Int?
	let oSTravelTimeRoundingMinutes : Int?
	let tELMinMinutesBill : Int?
	let tELBillingIncrements : String?
	let tRANSNotirizedFee : Int?
	let tRANSSpecializedTerminologyFeePerWord : Int?
	let tRANSSpecializedTerminologyFeePerDocument : Int?
	let tRANSPriorityFeePerWord : Int?
	let tRANSPriorityFeePerDocument : Int?
	let active : Bool?
	let onsiteTemplateName : String?
	let onsiteSpecialtyType : String?
	let telePhonicTemplateName : String?
	let telePhonicSpecialtyType : String?
	let translationTemplateName : String?
	let translationSpecialtyType : String?
	let vriTemplateName : String?
	let vriSpecialtyType : String?
	let simultaneousHours : Int?
	let virtualMMinMinutesBill : Int?
	let virtualMBillingIncrements : String?
	let virtualMTemplateName : String?
	let virtualMSpecialtyType : String?
	let virtualPrioirtyFee : Int?
	let telephonePrioirtyFee : Int?

	enum CodingKeys: String, CodingKey {

		case customerBillingID = "CustomerBillingID"
		case customerID = "CustomerID"
		case recordID = "RecordID"
		case tierNameID = "TierNameID"
		case oSMinMinutesBilled = "OSMinMinutesBilled"
		case oSMinutesRounding = "OSMinutesRounding"
		case oSIsCancellationFee = "OSIsCancellationFee"
		case oSMinCancellationMinutes = "OSMinCancellationMinutes"
		case oSCancellationFee = "OSCancellationFee"
		case oSIsPriority = "OSIsPriority"
		case oSPriorityFeeHourly = "OSPriorityFeeHourly"
		case perHourFee = "perHourFee"
		case oSIsMillage = "OSIsMillage"
		case oSMinMile = "OSMinMile"
		case oSMaxMile = "OSMaxMile"
		case oSPerMileBill = "OSPerMileBill"
		case oSIsTravelling = "OSIsTravelling"
		case oSTravelMinMinutes = "OSTravelMinMinutes"
		case oSTravelMaxMinutes = "OSTravelMaxMinutes"
		case oSTravelRatePerHour = "OSTravelRatePerHour"
		case oSTravelTimeRoundingMinutes = "OSTravelTimeRoundingMinutes"
		case tELMinMinutesBill = "TELMinMinutesBill"
		case tELBillingIncrements = "TELBillingIncrements"
		case tRANSNotirizedFee = "TRANSNotirizedFee"
		case tRANSSpecializedTerminologyFeePerWord = "TRANSSpecializedTerminologyFeePerWord"
		case tRANSSpecializedTerminologyFeePerDocument = "TRANSSpecializedTerminologyFeePerDocument"
		case tRANSPriorityFeePerWord = "TRANSPriorityFeePerWord"
		case tRANSPriorityFeePerDocument = "TRANSPriorityFeePerDocument"
		case active = "Active"
		case onsiteTemplateName = "OnsiteTemplateName"
		case onsiteSpecialtyType = "OnsiteSpecialtyType"
		case telePhonicTemplateName = "TelePhonicTemplateName"
		case telePhonicSpecialtyType = "TelePhonicSpecialtyType"
		case translationTemplateName = "TranslationTemplateName"
		case translationSpecialtyType = "TranslationSpecialtyType"
		case vriTemplateName = "VriTemplateName"
		case vriSpecialtyType = "VriSpecialtyType"
		case simultaneousHours = "SimultaneousHours"
		case virtualMMinMinutesBill = "VirtualMMinMinutesBill"
		case virtualMBillingIncrements = "VirtualMBillingIncrements"
		case virtualMTemplateName = "VirtualMTemplateName"
		case virtualMSpecialtyType = "VirtualMSpecialtyType"
		case virtualPrioirtyFee = "VirtualPrioirtyFee"
		case telephonePrioirtyFee = "TelephonePrioirtyFee"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerBillingID = try values.decodeIfPresent(Int.self, forKey: .customerBillingID)
		customerID = try values.decodeIfPresent(Int.self, forKey: .customerID)
		recordID = try values.decodeIfPresent(Int.self, forKey: .recordID)
		tierNameID = try values.decodeIfPresent(Int.self, forKey: .tierNameID)
		oSMinMinutesBilled = try values.decodeIfPresent(Int.self, forKey: .oSMinMinutesBilled)
		oSMinutesRounding = try values.decodeIfPresent(Int.self, forKey: .oSMinutesRounding)
		oSIsCancellationFee = try values.decodeIfPresent(Bool.self, forKey: .oSIsCancellationFee)
		oSMinCancellationMinutes = try values.decodeIfPresent(Int.self, forKey: .oSMinCancellationMinutes)
		oSCancellationFee = try values.decodeIfPresent(Int.self, forKey: .oSCancellationFee)
		oSIsPriority = try values.decodeIfPresent(Bool.self, forKey: .oSIsPriority)
		oSPriorityFeeHourly = try values.decodeIfPresent(Int.self, forKey: .oSPriorityFeeHourly)
		perHourFee = try values.decodeIfPresent(Double.self, forKey: .perHourFee)
		oSIsMillage = try values.decodeIfPresent(Bool.self, forKey: .oSIsMillage)
		oSMinMile = try values.decodeIfPresent(Int.self, forKey: .oSMinMile)
		oSMaxMile = try values.decodeIfPresent(Int.self, forKey: .oSMaxMile)
		oSPerMileBill = try values.decodeIfPresent(Int.self, forKey: .oSPerMileBill)
		oSIsTravelling = try values.decodeIfPresent(Bool.self, forKey: .oSIsTravelling)
		oSTravelMinMinutes = try values.decodeIfPresent(Int.self, forKey: .oSTravelMinMinutes)
		oSTravelMaxMinutes = try values.decodeIfPresent(Int.self, forKey: .oSTravelMaxMinutes)
		oSTravelRatePerHour = try values.decodeIfPresent(Int.self, forKey: .oSTravelRatePerHour)
		oSTravelTimeRoundingMinutes = try values.decodeIfPresent(Int.self, forKey: .oSTravelTimeRoundingMinutes)
		tELMinMinutesBill = try values.decodeIfPresent(Int.self, forKey: .tELMinMinutesBill)
		tELBillingIncrements = try values.decodeIfPresent(String.self, forKey: .tELBillingIncrements)
		tRANSNotirizedFee = try values.decodeIfPresent(Int.self, forKey: .tRANSNotirizedFee)
		tRANSSpecializedTerminologyFeePerWord = try values.decodeIfPresent(Int.self, forKey: .tRANSSpecializedTerminologyFeePerWord)
		tRANSSpecializedTerminologyFeePerDocument = try values.decodeIfPresent(Int.self, forKey: .tRANSSpecializedTerminologyFeePerDocument)
		tRANSPriorityFeePerWord = try values.decodeIfPresent(Int.self, forKey: .tRANSPriorityFeePerWord)
		tRANSPriorityFeePerDocument = try values.decodeIfPresent(Int.self, forKey: .tRANSPriorityFeePerDocument)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		onsiteTemplateName = try values.decodeIfPresent(String.self, forKey: .onsiteTemplateName)
		onsiteSpecialtyType = try values.decodeIfPresent(String.self, forKey: .onsiteSpecialtyType)
		telePhonicTemplateName = try values.decodeIfPresent(String.self, forKey: .telePhonicTemplateName)
		telePhonicSpecialtyType = try values.decodeIfPresent(String.self, forKey: .telePhonicSpecialtyType)
		translationTemplateName = try values.decodeIfPresent(String.self, forKey: .translationTemplateName)
		translationSpecialtyType = try values.decodeIfPresent(String.self, forKey: .translationSpecialtyType)
		vriTemplateName = try values.decodeIfPresent(String.self, forKey: .vriTemplateName)
		vriSpecialtyType = try values.decodeIfPresent(String.self, forKey: .vriSpecialtyType)
		simultaneousHours = try values.decodeIfPresent(Int.self, forKey: .simultaneousHours)
		virtualMMinMinutesBill = try values.decodeIfPresent(Int.self, forKey: .virtualMMinMinutesBill)
		virtualMBillingIncrements = try values.decodeIfPresent(String.self, forKey: .virtualMBillingIncrements)
		virtualMTemplateName = try values.decodeIfPresent(String.self, forKey: .virtualMTemplateName)
		virtualMSpecialtyType = try values.decodeIfPresent(String.self, forKey: .virtualMSpecialtyType)
		virtualPrioirtyFee = try values.decodeIfPresent(Int.self, forKey: .virtualPrioirtyFee)
		telephonePrioirtyFee = try values.decodeIfPresent(Int.self, forKey: .telephonePrioirtyFee)
	}

}

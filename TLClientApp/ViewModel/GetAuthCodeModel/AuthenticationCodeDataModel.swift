/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct AuthenticationCodeDataModel : Codable {
	let appointmentID : Int?
	let appointmentIDAll : String?
	let authCode : String?
	let appointmentTypeID : Int?
	let appointmentTypeName : String?
	let appointmentStatusTypeID : Int?
	let appointmentStatusType : String?
	let specialityID : String?
	let specialityName : String?
	let languageID : String?
	let languageName : String?
	let companyID : String?
	let companyName : String?
	let text : String?
	let decspt : Bool?
	let caseNumber : String?
	let clientName : String?
	let venueID : String?
	let venueName : String?
	let address : String?
	let providerID : String?
	let providerName : String?
	let requestedBy : String?
	let requestedOn : String?
	let confirmedBy : String?
	let confirmedOn : String?
	let assignedByID : Int?
	let confirmationBit : Int?
	let bookedBy : String?
	let bookedOn : String?
	let addedOn : String?
	let startDateTime : String?
	let endDateTime : String?
	let duration : Int?
	let distance : String?
	let priorityfee : String?
	let wordCount : String?
	let specializedTerminology : String?
	let notarized : String?
	let readyToSync : String?
	let creadyToSync : String?
	let oSPerHourFee : String?
	let oSMillageRate : String?
	let fullName : String?
	let interpretorName : String?
	let billRate : String?
	let syncBit : String?
	let cSyncBit : String?
	let vendorid : String?

	enum CodingKeys: String, CodingKey {

		case appointmentID = "AppointmentID"
		case appointmentIDAll = "AppointmentIDAll"
		case authCode = "AuthCode"
		case appointmentTypeID = "AppointmentTypeID"
		case appointmentTypeName = "AppointmentTypeName"
		case appointmentStatusTypeID = "AppointmentStatusTypeID"
		case appointmentStatusType = "AppointmentStatusType"
		case specialityID = "SpecialityID"
		case specialityName = "SpecialityName"
		case languageID = "LanguageID"
		case languageName = "LanguageName"
		case companyID = "CompanyID"
		case companyName = "CompanyName"
		case text = "Text"
		case decspt = "decspt"
		case caseNumber = "CaseNumber"
		case clientName = "ClientName"
		case venueID = "VenueID"
		case venueName = "VenueName"
		case address = "Address"
		case providerID = "ProviderID"
		case providerName = "ProviderName"
		case requestedBy = "RequestedBy"
		case requestedOn = "RequestedOn"
		case confirmedBy = "ConfirmedBy"
		case confirmedOn = "ConfirmedOn"
		case assignedByID = "AssignedByID"
		case confirmationBit = "ConfirmationBit"
		case bookedBy = "BookedBy"
		case bookedOn = "BookedOn"
		case addedOn = "AddedOn"
		case startDateTime = "StartDateTime"
		case endDateTime = "EndDateTime"
		case duration = "Duration"
		case distance = "Distance"
		case priorityfee = "Priorityfee"
		case wordCount = "WordCount"
		case specializedTerminology = "SpecializedTerminology"
		case notarized = "Notarized"
		case readyToSync = "readyToSync"
		case creadyToSync = "CreadyToSync"
		case oSPerHourFee = "OSPerHourFee"
		case oSMillageRate = "OSMillageRate"
		case fullName = "FullName"
		case interpretorName = "interpretorName"
		case billRate = "BillRate"
		case syncBit = "SyncBit"
		case cSyncBit = "CSyncBit"
		case vendorid = "vendorid"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		appointmentID = try values.decodeIfPresent(Int.self, forKey: .appointmentID)
		appointmentIDAll = try values.decodeIfPresent(String.self, forKey: .appointmentIDAll)
		authCode = try values.decodeIfPresent(String.self, forKey: .authCode)
		appointmentTypeID = try values.decodeIfPresent(Int.self, forKey: .appointmentTypeID)
		appointmentTypeName = try values.decodeIfPresent(String.self, forKey: .appointmentTypeName)
		appointmentStatusTypeID = try values.decodeIfPresent(Int.self, forKey: .appointmentStatusTypeID)
		appointmentStatusType = try values.decodeIfPresent(String.self, forKey: .appointmentStatusType)
		specialityID = try values.decodeIfPresent(String.self, forKey: .specialityID)
		specialityName = try values.decodeIfPresent(String.self, forKey: .specialityName)
		languageID = try values.decodeIfPresent(String.self, forKey: .languageID)
		languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
		companyID = try values.decodeIfPresent(String.self, forKey: .companyID)
		companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		decspt = try values.decodeIfPresent(Bool.self, forKey: .decspt)
		caseNumber = try values.decodeIfPresent(String.self, forKey: .caseNumber)
		clientName = try values.decodeIfPresent(String.self, forKey: .clientName)
		venueID = try values.decodeIfPresent(String.self, forKey: .venueID)
		venueName = try values.decodeIfPresent(String.self, forKey: .venueName)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		providerID = try values.decodeIfPresent(String.self, forKey: .providerID)
		providerName = try values.decodeIfPresent(String.self, forKey: .providerName)
		requestedBy = try values.decodeIfPresent(String.self, forKey: .requestedBy)
		requestedOn = try values.decodeIfPresent(String.self, forKey: .requestedOn)
		confirmedBy = try values.decodeIfPresent(String.self, forKey: .confirmedBy)
		confirmedOn = try values.decodeIfPresent(String.self, forKey: .confirmedOn)
		assignedByID = try values.decodeIfPresent(Int.self, forKey: .assignedByID)
		confirmationBit = try values.decodeIfPresent(Int.self, forKey: .confirmationBit)
		bookedBy = try values.decodeIfPresent(String.self, forKey: .bookedBy)
		bookedOn = try values.decodeIfPresent(String.self, forKey: .bookedOn)
		addedOn = try values.decodeIfPresent(String.self, forKey: .addedOn)
		startDateTime = try values.decodeIfPresent(String.self, forKey: .startDateTime)
		endDateTime = try values.decodeIfPresent(String.self, forKey: .endDateTime)
		duration = try values.decodeIfPresent(Int.self, forKey: .duration)
		distance = try values.decodeIfPresent(String.self, forKey: .distance)
		priorityfee = try values.decodeIfPresent(String.self, forKey: .priorityfee)
		wordCount = try values.decodeIfPresent(String.self, forKey: .wordCount)
		specializedTerminology = try values.decodeIfPresent(String.self, forKey: .specializedTerminology)
		notarized = try values.decodeIfPresent(String.self, forKey: .notarized)
		readyToSync = try values.decodeIfPresent(String.self, forKey: .readyToSync)
		creadyToSync = try values.decodeIfPresent(String.self, forKey: .creadyToSync)
		oSPerHourFee = try values.decodeIfPresent(String.self, forKey: .oSPerHourFee)
		oSMillageRate = try values.decodeIfPresent(String.self, forKey: .oSMillageRate)
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		interpretorName = try values.decodeIfPresent(String.self, forKey: .interpretorName)
		billRate = try values.decodeIfPresent(String.self, forKey: .billRate)
		syncBit = try values.decodeIfPresent(String.self, forKey: .syncBit)
		cSyncBit = try values.decodeIfPresent(String.self, forKey: .cSyncBit)
		vendorid = try values.decodeIfPresent(String.self, forKey: .vendorid)
	}

}

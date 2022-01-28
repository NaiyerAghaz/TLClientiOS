/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CustomerCheckListresponseModel : Codable {
	let customerChkId : Int?
	let active : Bool?
	let resume : Bool?
	let medical : Bool?
	let legal : Bool?
	let general : Bool?
	let other : Bool?
	let hIPPA : Bool?
	let cORI : Bool?
	let screeningForm : Bool?
	let w_9 : Bool?
	let contractorAgreement : Bool?
	let payrollPolicy : Bool?
	let pPPhoto : Bool?
	let confidentialityAgreement : Bool?
	let medicalNoOfHoursRequired : String?
	let legalNoOfHoursRequired : String?
	let generalNoOfHoursRequired : String?
	let otherNoOfHoursRequired : String?
	let specialityCheckListId : String?
	let specialityID : String?
	let measles : Bool?
	let mumps : Bool?
	let rubella : Bool?
	let varicella : Bool?
	let hepB : Bool?
	let tdap : Bool?
	let pPD : Bool?
	let flu : Bool?
	let mMR : Bool?
	let covidVaccination : Bool?
	let fluShotDeclination : Bool?
	let createDate : String?
	let updateDate : String?
	let createdBy : String?
	let updatedBy : String?
	let orientation : Bool?

	enum CodingKeys: String, CodingKey {

		case customerChkId = "CustomerChkId"
		case active = "Active"
		case resume = "Resume"
		case medical = "Medical"
		case legal = "Legal"
		case general = "General"
		case other = "Other"
		case hIPPA = "HIPPA"
		case cORI = "CORI"
		case screeningForm = "ScreeningForm"
		case w_9 = "W_9"
		case contractorAgreement = "ContractorAgreement"
		case payrollPolicy = "PayrollPolicy"
		case pPPhoto = "PPPhoto"
		case confidentialityAgreement = "ConfidentialityAgreement"
		case medicalNoOfHoursRequired = "MedicalNoOfHoursRequired"
		case legalNoOfHoursRequired = "LegalNoOfHoursRequired"
		case generalNoOfHoursRequired = "GeneralNoOfHoursRequired"
		case otherNoOfHoursRequired = "OtherNoOfHoursRequired"
		case specialityCheckListId = "SpecialityCheckListId"
		case specialityID = "SpecialityID"
		case measles = "Measles"
		case mumps = "Mumps"
		case rubella = "Rubella"
		case varicella = "Varicella"
		case hepB = "HepB"
		case tdap = "Tdap"
		case pPD = "PPD"
		case flu = "Flu"
		case mMR = "MMR"
		case covidVaccination = "CovidVaccination"
		case fluShotDeclination = "FluShotDeclination"
		case createDate = "CreateDate"
		case updateDate = "UpdateDate"
		case createdBy = "CreatedBy"
		case updatedBy = "UpdatedBy"
		case orientation = "Orientation"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerChkId = try values.decodeIfPresent(Int.self, forKey: .customerChkId)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		resume = try values.decodeIfPresent(Bool.self, forKey: .resume)
		medical = try values.decodeIfPresent(Bool.self, forKey: .medical)
		legal = try values.decodeIfPresent(Bool.self, forKey: .legal)
		general = try values.decodeIfPresent(Bool.self, forKey: .general)
		other = try values.decodeIfPresent(Bool.self, forKey: .other)
		hIPPA = try values.decodeIfPresent(Bool.self, forKey: .hIPPA)
		cORI = try values.decodeIfPresent(Bool.self, forKey: .cORI)
		screeningForm = try values.decodeIfPresent(Bool.self, forKey: .screeningForm)
		w_9 = try values.decodeIfPresent(Bool.self, forKey: .w_9)
		contractorAgreement = try values.decodeIfPresent(Bool.self, forKey: .contractorAgreement)
		payrollPolicy = try values.decodeIfPresent(Bool.self, forKey: .payrollPolicy)
		pPPhoto = try values.decodeIfPresent(Bool.self, forKey: .pPPhoto)
		confidentialityAgreement = try values.decodeIfPresent(Bool.self, forKey: .confidentialityAgreement)
		medicalNoOfHoursRequired = try values.decodeIfPresent(String.self, forKey: .medicalNoOfHoursRequired)
		legalNoOfHoursRequired = try values.decodeIfPresent(String.self, forKey: .legalNoOfHoursRequired)
		generalNoOfHoursRequired = try values.decodeIfPresent(String.self, forKey: .generalNoOfHoursRequired)
		otherNoOfHoursRequired = try values.decodeIfPresent(String.self, forKey: .otherNoOfHoursRequired)
		specialityCheckListId = try values.decodeIfPresent(String.self, forKey: .specialityCheckListId)
		specialityID = try values.decodeIfPresent(String.self, forKey: .specialityID)
		measles = try values.decodeIfPresent(Bool.self, forKey: .measles)
		mumps = try values.decodeIfPresent(Bool.self, forKey: .mumps)
		rubella = try values.decodeIfPresent(Bool.self, forKey: .rubella)
		varicella = try values.decodeIfPresent(Bool.self, forKey: .varicella)
		hepB = try values.decodeIfPresent(Bool.self, forKey: .hepB)
		tdap = try values.decodeIfPresent(Bool.self, forKey: .tdap)
		pPD = try values.decodeIfPresent(Bool.self, forKey: .pPD)
		flu = try values.decodeIfPresent(Bool.self, forKey: .flu)
		mMR = try values.decodeIfPresent(Bool.self, forKey: .mMR)
		covidVaccination = try values.decodeIfPresent(Bool.self, forKey: .covidVaccination)
		fluShotDeclination = try values.decodeIfPresent(Bool.self, forKey: .fluShotDeclination)
		createDate = try values.decodeIfPresent(String.self, forKey: .createDate)
		updateDate = try values.decodeIfPresent(String.self, forKey: .updateDate)
		createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
		updatedBy = try values.decodeIfPresent(String.self, forKey: .updatedBy)
		orientation = try values.decodeIfPresent(Bool.self, forKey: .orientation)
	}

}

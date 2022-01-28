/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiScheduleAppointmentCustomerDataModel : Codable {
	let filecode : String?
	let appointmentID : Int?
	let cActive : String?
	let overrideSatus : String?
	let overrideauth : String?
	let multipleVenueFlag : String?
	let requestID : String?
	let serviceType : String?
	let authCode : String?
	let displayValue : String?
	let timeUpdateStatus : String?
	let venueName : String?
	let providerName : String?
	let vendorAddress : String?
	let departmentName : String?
	let appointmentTypeID : Int?
	let appointmentStatusType : String?
	let hashofminutes : String?
	let appointmentType : String?
	let appointmentStatusTypeCode : String?
	let appointmentStatusTypeTemp : String?
	let appointmentStatusID : String?
	let billRate : String?
	let tierName : String?
	let mgemilRist : String?
	let startDateTimeTemp : String?
	let endDateTimeTemp : String?
	let additionRembersmentDes : String?
	let timeFinishReview : Int?
	let scheduleNotes : String?
	let aptDetails : String?
	let financialNotes : String?
	let specialityID : String?
	let companyName : String?
	let mainPhone : String?
	let languageID : Int?
	let languageName : String?
	let userType : String?
	let companyID : Int?
	let oSMillageRate : String?
	let customerID : Int?
	let vendorName : String?
	let unicFlag : String?
	let badgeNumber : String?
	let onsiteMilage : String?
	let interpreterID : Int?
	let officialCompany : String?
	let acceptAndDeclineStatus : String?
	let text : String?
	let oSPerHourFee : String?
	let perHourFee : String?
	let startDateTime : String?
	let designedDueDate : String?
	let notoficationId : String?
	let endDateTime : String?
	let userColor : String?
	let decspt : Bool?
	let caseName : String?
	let clientInitial : String?
	let clientName : String?
	let cPIntials : String?
	let caseNumber : String?
	let securityClearence : String?
	let experienceOfVendor : String?
	let interpreterType : String?
	let departureTime : String?
	let arrivalTime : String?
	let translationInvoice : Bool?
	let translationConfirmed : Bool?
	let translationWaitingList : Bool?
	let translationCancellationFee : Bool?
	let translationPriority : Bool?
	let fileID : String?
	let translationDesc : String?
	let requestscounts : Int?
	let venueID : String?
	let invoiceNumber : String?
	let providerID : String?
	let departmentID : String?
	let customerUserName : String?
	let assignedByID : String?
	let assignedByName : String?
	let duration : Int?
	let distance : String?
	let gender : String?
	let location : String?
	let callServiceBit : Bool?
	let callTime : String?
	let purpose : String?
	let lastUpdated : String?
	let office : String?
	let home : String?
	let cell : String?
	let sourceLanguageID : String?
	let targetLanguageID : String?
	let appointmentMilage : String?
	let peopleOnCall : String?
	let invoiceCount : String?
	let callerNames : String?
	let wordCount : String?
	let uploadedDocument : String?
	let projectDueDate : String?
	let translationType : String?
	let translationCancellationFeeBit : String?
	let translationPriorityBit : String?
	let translationRequestedDate : String?
	let translationVendorRankingID : String?
	let waitingList : Bool?
	let bookedBy : Int?
	let bookedByName : String?
	let bookedOn : String?
	let confirmedBy : Int?
	let confirmedByName : String?
	let confirmedOn : String?
	let cancelledBy : String?
	let cancelledByName : String?
	let cancelledOn : String?
	let loadedBy : String?
	let loadedByName : String?
	let loadedOn : String?
	let requestedBy : Int?
	let requestedByName : String?
	let requestedOn : String?
	let updateDate : String?
	let priority : Bool?
	let customerReturnDate : String?
	let addedOn : String?
	let cancellationFee : Bool?
	let deleteStatus : Bool?
	let changeStatus : Bool?
	let qBID : String?
	let qBEditID : String?
	let ranking : String?
	let email : String?
	let number : String?
	let travelling : String?
	let notarized : String?
	let specializedTerminology : String?
	let priorityfee : String?
	let publicPrivate : Bool?
	let confirmationBit : Bool?
	let invoiceBit : Bool?
	let syncBit : Bool?
	let cSyncBit : Bool?
	let messageID : String?
	let readyToSync : Bool?
	let creadyToSync : Bool?
	let specialityName : String?
	let active : String?
	let customerName : String?
	let conformationKey : String?
	let interpreterBookedId : String?
	let filecounts : Int?
	let vendorFilecounts : Int?
	let total : String?
	let mileageCost : String?
	let cutomerInvoicesTotal : String?
	let vendorSpecializedTerminology : String?
	let vendorPriorityfee : String?
	let tRANTargetLanguagesRate : Int?
	let interpretorName : String?
	let address : String?
	let city : String?
	let stateName : String?
	let zipcode : String?
	let appointmentCount : String?
	let targetLanguageName : String?
	let isExpired : String?
	let billProcess : String?
	let finishedFileName : String?
	let finishedFileType : String?
	let endTime : String?
	let finishedTime : String?
	let previousTime : String?
	let myrequest : String?
	let custRequestID : String?
	let custrequestCode : String?
	let isAssigned : String?
	let appoinmentFileList : String?
	let appoinmentvenueList : String?
	let additionRembersmentList : String?
	let startTime : String?
	let customerUserID : String?
	let acceptRequestscounts : String?
	let declineRequestscounts : String?
	let isDirect : String?
	let vendorEmailConformation : Int?
	let vendorEmailConfDate : String?
	let clientAddress : String?
	let address2 : String?
	let clientCity : String?
	let clientZipCode : String?
	let clientStateName : String?
	let additionTravelTimePay : String?
	let updatedOn : String?
	let updatedBy : String?
	let updateUser : String?
	let reasonforBotch : String?
	let phoneNumber : String?
	let venueCount : String?
	let updatedStartDate : String?
	let syncText : String?
	let createUser : String?
	let interpreterRate : String?
	let additionRembersment : String?
	let clientInvoiceNotes : String?
	let startDate : String?
	let createDate : String?
	let returndate : String?
	let totalCustomerBill : String?
	let totalHours : String?
	let appointmentsCount : String?
	let totalCustomerMilageRate : String?
	let totalVendorExpenses : String?
	let vendorMileageRate : String?
	let roundtripMil : String?
	let perMilesBill : String?
	let profitOrLoss : String?
	let totalMargin : String?
	let appointmentTypeName : String?
	let totalMileageRate : String?
	let appointmentRate : String?
	let roundTripMile : String?
	let mileageRate : String?
	let vendorRate : String?
	let syncDate : String?
	let previousStatus : String?
	let nullDate : String?
	let tempFileName : String?
	let templateID : String?
	let templateName : String?
	let templateWordCount : String?
	let finalWordCount : String?
	let typeuser : String?
	let tEdateStatus : String?
	let tSdateStatus : String?
	let oldStartDateTime : String?
	let oldEndDateTime : String?
	let sendingEndTimes : String?
	let proofReader : String?
	let tempStatus : String?
	let vendorJobType : String?
	let quote : String?
	let approvedForTranslation : String?
	let paidNotVisible : String?
	let receivedDate : String?
	let translationSpecialties : String?
	let translatorDueDate : String?
	let proofreaderBooked : String?
	let proofreaderDueDate : String?
	let specialFormatting : String?
	let experience : String?
	let minimumCharge : String?
	let contactName : String?
	let docTranslationConfirmed : String?
	let assignStatus : String?
	let invoiceDate : String?
	let isChanged : String?
	let isOwnOrNot : String?
	let customerPriority : String?
	let vendorMileage : String?
	let interpreterCount : String?
	let previousInterpreterCount : String?
	let oneHremail : String?
	let oneHrcnfmsg : String?
	let bulkemailconf : String?
	let botchedReason : String?
	let image : String?
	let customerAddress1 : String?
	let customerAddress2 : String?
	let customerAddress3 : String?
	let customerCity : String?
	let customerPhone : String?
	let customerEmail : String?
	let customerExtension : String?
	let serviceVerificationName : String?
	let confrimbulkBy : String?
	let supportPermission : String?
	let supportmcount : String?
	let purchaseOrder : String?
	let claim : String?
	let reference : String?
	let customerCancelRequest : Int?
	let costOfJob : String?
	let isNotarized : String?
	let invoiceNotes : String?
	let upworkRef : String?
	let clientDueDate : String?
	let sLanguageID : Int?
	let sLanguageName : String?
	let id : String?
	let title : String?
	let url : String?
	let class1 : String?
	let start : String?
	let end : String?
	let proiectName : String?
	let approvedDate : String?
	let declinedDate : String?
	let tranlatedFile : String?
	let submitDate : String?
	let createdBy : String?
	let translatorName : String?
	let translatorRate : String?
	let vendorthirdPartyFee : String?
	let totalCustomercost : String?
	let completedDate : String?
	let vendorCost : String?
	let vendorTranslatorTotal : String?
	let margin : String?
	let encounter : String?
	let simultaneousHours : String?
	let isencounter : String?
	let missingformsEmailCount : String?
	let customerBill : String?
	let vendorExpenses : String?
	let x : String?
	let label : String?
	let y : String?
	let appointmentAllID : String?
	let vendorCancelledBy : String?
	let vendorCancelledDate : String?
	let requestorName : String?
	let requestorEmail : String?
	let assignToFieldStaff : String?
	let tFNotes : String?
	let customerSignature : String?
	let interpreterSignature : String?
	let customerRate : String?
	let checkIn : Int?
	let checkOut : Int?
	let checkInDateTime : String?
	let checkOutDateTime : String?
	let checkUser : String?
	let checkUserName : String?

	enum CodingKeys: String, CodingKey {

		case filecode = "filecode"
		case appointmentID = "AppointmentID"
		case cActive = "CActive"
		case overrideSatus = "overrideSatus"
		case overrideauth = "overrideauth"
		case multipleVenueFlag = "multipleVenueFlag"
		case requestID = "RequestID"
		case serviceType = "ServiceType"
		case authCode = "AuthCode"
		case displayValue = "DisplayValue"
		case timeUpdateStatus = "TimeUpdateStatus"
		case venueName = "VenueName"
		case providerName = "ProviderName"
		case vendorAddress = "vendorAddress"
		case departmentName = "DepartmentName"
		case appointmentTypeID = "AppointmentTypeID"
		case appointmentStatusType = "AppointmentStatusType"
		case hashofminutes = "hashofminutes"
		case appointmentType = "AppointmentType"
		case appointmentStatusTypeCode = "AppointmentStatusTypeCode"
		case appointmentStatusTypeTemp = "AppointmentStatusTypeTemp"
		case appointmentStatusID = "AppointmentStatusID"
		case billRate = "BillRate"
		case tierName = "TierName"
		case mgemilRist = "MgemilRist"
		case startDateTimeTemp = "StartDateTimeTemp"
		case endDateTimeTemp = "EndDateTimeTemp"
		case additionRembersmentDes = "AdditionRembersmentDes"
		case timeFinishReview = "TimeFinishReview"
		case scheduleNotes = "ScheduleNotes"
		case aptDetails = "AptDetails"
		case financialNotes = "FinancialNotes"
		case specialityID = "SpecialityID"
		case companyName = "CompanyName"
		case mainPhone = "MainPhone"
		case languageID = "LanguageID"
		case languageName = "LanguageName"
		case userType = "userType"
		case companyID = "CompanyID"
		case oSMillageRate = "OSMillageRate"
		case customerID = "CustomerID"
		case vendorName = "VendorName"
		case unicFlag = "UnicFlag"
		case badgeNumber = "BadgeNumber"
		case onsiteMilage = "OnsiteMilage"
		case interpreterID = "InterpreterID"
		case officialCompany = "OfficialCompany"
		case acceptAndDeclineStatus = "AcceptAndDeclineStatus"
		case text = "Text"
		case oSPerHourFee = "OSPerHourFee"
		case perHourFee = "perHourFee"
		case startDateTime = "StartDateTime"
		case designedDueDate = "DesignedDueDate"
		case notoficationId = "NotoficationId"
		case endDateTime = "EndDateTime"
		case userColor = "userColor"
		case decspt = "decspt"
		case caseName = "CaseName"
		case clientInitial = "ClientInitial"
		case clientName = "ClientName"
		case cPIntials = "cPIntials"
		case caseNumber = "CaseNumber"
		case securityClearence = "SecurityClearence"
		case experienceOfVendor = "ExperienceOfVendor"
		case interpreterType = "InterpreterType"
		case departureTime = "DepartureTime"
		case arrivalTime = "ArrivalTime"
		case translationInvoice = "TranslationInvoice"
		case translationConfirmed = "TranslationConfirmed"
		case translationWaitingList = "TranslationWaitingList"
		case translationCancellationFee = "TranslationCancellationFee"
		case translationPriority = "TranslationPriority"
		case fileID = "FileID"
		case translationDesc = "TranslationDesc"
		case requestscounts = "Requestscounts"
		case venueID = "VenueID"
		case invoiceNumber = "invoiceNumber"
		case providerID = "ProviderID"
		case departmentID = "DepartmentID"
		case customerUserName = "CustomerUserName"
		case assignedByID = "AssignedByID"
		case assignedByName = "AssignedByName"
		case duration = "Duration"
		case distance = "Distance"
		case gender = "Gender"
		case location = "Location"
		case callServiceBit = "CallServiceBit"
		case callTime = "CallTime"
		case purpose = "Purpose"
		case lastUpdated = "LastUpdated"
		case office = "Office"
		case home = "Home"
		case cell = "Cell"
		case sourceLanguageID = "SourceLanguageID"
		case targetLanguageID = "TargetLanguageID"
		case appointmentMilage = "AppointmentMilage"
		case peopleOnCall = "PeopleOnCall"
		case invoiceCount = "InvoiceCount"
		case callerNames = "CallerNames"
		case wordCount = "WordCount"
		case uploadedDocument = "UploadedDocument"
		case projectDueDate = "ProjectDueDate"
		case translationType = "TranslationType"
		case translationCancellationFeeBit = "TranslationCancellationFeeBit"
		case translationPriorityBit = "TranslationPriorityBit"
		case translationRequestedDate = "TranslationRequestedDate"
		case translationVendorRankingID = "TranslationVendorRankingID"
		case waitingList = "WaitingList"
		case bookedBy = "BookedBy"
		case bookedByName = "BookedByName"
		case bookedOn = "BookedOn"
		case confirmedBy = "ConfirmedBy"
		case confirmedByName = "ConfirmedByName"
		case confirmedOn = "ConfirmedOn"
		case cancelledBy = "CancelledBy"
		case cancelledByName = "CancelledByName"
		case cancelledOn = "CancelledOn"
		case loadedBy = "LoadedBy"
		case loadedByName = "LoadedByName"
		case loadedOn = "LoadedOn"
		case requestedBy = "RequestedBy"
		case requestedByName = "RequestedByName"
		case requestedOn = "RequestedOn"
		case updateDate = "UpdateDate"
		case priority = "Priority"
		case customerReturnDate = "CustomerReturnDate"
		case addedOn = "AddedOn"
		case cancellationFee = "CancellationFee"
		case deleteStatus = "DeleteStatus"
		case changeStatus = "ChangeStatus"
		case qBID = "QBID"
		case qBEditID = "QBEditID"
		case ranking = "Ranking"
		case email = "Email"
		case number = "Number"
		case travelling = "Travelling"
		case notarized = "Notarized"
		case specializedTerminology = "SpecializedTerminology"
		case priorityfee = "Priorityfee"
		case publicPrivate = "PublicPrivate"
		case confirmationBit = "ConfirmationBit"
		case invoiceBit = "InvoiceBit"
		case syncBit = "SyncBit"
		case cSyncBit = "CSyncBit"
		case messageID = "MessageID"
		case readyToSync = "readyToSync"
		case creadyToSync = "CreadyToSync"
		case specialityName = "SpecialityName"
		case active = "Active"
		case customerName = "CustomerName"
		case conformationKey = "ConformationKey"
		case interpreterBookedId = "InterpreterBookedId"
		case filecounts = "Filecounts"
		case vendorFilecounts = "VendorFilecounts"
		case total = "Total"
		case mileageCost = "MileageCost"
		case cutomerInvoicesTotal = "CutomerInvoicesTotal"
		case vendorSpecializedTerminology = "VendorSpecializedTerminology"
		case vendorPriorityfee = "VendorPriorityfee"
		case tRANTargetLanguagesRate = "TRANTargetLanguagesRate"
		case interpretorName = "InterpretorName"
		case address = "Address"
		case city = "city"
		case stateName = "StateName"
		case zipcode = "Zipcode"
		case appointmentCount = "AppointmentCount"
		case targetLanguageName = "TargetLanguageName"
		case isExpired = "IsExpired"
		case billProcess = "BillProcess"
		case finishedFileName = "FinishedFileName"
		case finishedFileType = "FinishedFileType"
		case endTime = "EndTime"
		case finishedTime = "FinishedTime"
		case previousTime = "PreviousTime"
		case myrequest = "Myrequest"
		case custRequestID = "CustRequestID"
		case custrequestCode = "CustrequestCode"
		case isAssigned = "IsAssigned"
		case appoinmentFileList = "AppoinmentFileList"
		case appoinmentvenueList = "AppoinmentvenueList"
		case additionRembersmentList = "AdditionRembersmentList"
		case startTime = "StartTime"
		case customerUserID = "CustomerUserID"
		case acceptRequestscounts = "AcceptRequestscounts"
		case declineRequestscounts = "DeclineRequestscounts"
		case isDirect = "IsDirect"
		case vendorEmailConformation = "VendorEmailConformation"
		case vendorEmailConfDate = "VendorEmailConfDate"
		case clientAddress = "ClientAddress"
		case address2 = "Address2"
		case clientCity = "ClientCity"
		case clientZipCode = "ClientZipCode"
		case clientStateName = "ClientStateName"
		case additionTravelTimePay = "AdditionTravelTimePay"
		case updatedOn = "UpdatedOn"
		case updatedBy = "UpdatedBy"
		case updateUser = "UpdateUser"
		case reasonforBotch = "ReasonforBotch"
		case phoneNumber = "PhoneNumber"
		case venueCount = "VenueCount"
		case updatedStartDate = "UpdatedStartDate"
		case syncText = "SyncText"
		case createUser = "CreateUser"
		case interpreterRate = "InterpreterRate"
		case additionRembersment = "AdditionRembersment"
		case clientInvoiceNotes = "ClientInvoiceNotes"
		case startDate = "StartDate"
		case createDate = "CreateDate"
		case returndate = "returndate"
		case totalCustomerBill = "TotalCustomerBill"
		case totalHours = "TotalHours"
		case appointmentsCount = "AppointmentsCount"
		case totalCustomerMilageRate = "TotalCustomerMilageRate"
		case totalVendorExpenses = "TotalVendorExpenses"
		case vendorMileageRate = "VendorMileageRate"
		case roundtripMil = "RoundtripMil"
		case perMilesBill = "PerMilesBill"
		case profitOrLoss = "ProfitOrLoss"
		case totalMargin = "TotalMargin"
		case appointmentTypeName = "AppointmentTypeName"
		case totalMileageRate = "TotalMileageRate"
		case appointmentRate = "AppointmentRate"
		case roundTripMile = "RoundTripMile"
		case mileageRate = "MileageRate"
		case vendorRate = "VendorRate"
		case syncDate = "SyncDate"
		case previousStatus = "PreviousStatus"
		case nullDate = "NullDate"
		case tempFileName = "tempFileName"
		case templateID = "TemplateID"
		case templateName = "TemplateName"
		case templateWordCount = "TemplateWordCount"
		case finalWordCount = "FinalWordCount"
		case typeuser = "typeuser"
		case tEdateStatus = "TEdateStatus"
		case tSdateStatus = "TSdateStatus"
		case oldStartDateTime = "oldStartDateTime"
		case oldEndDateTime = "oldEndDateTime"
		case sendingEndTimes = "SendingEndTimes"
		case proofReader = "ProofReader"
		case tempStatus = "TempStatus"
		case vendorJobType = "VendorJobType"
		case quote = "Quote"
		case approvedForTranslation = "ApprovedForTranslation"
		case paidNotVisible = "PaidNotVisible"
		case receivedDate = "ReceivedDate"
		case translationSpecialties = "TranslationSpecialties"
		case translatorDueDate = "TranslatorDueDate"
		case proofreaderBooked = "ProofreaderBooked"
		case proofreaderDueDate = "ProofreaderDueDate"
		case specialFormatting = "SpecialFormatting"
		case experience = "Experience"
		case minimumCharge = "MinimumCharge"
		case contactName = "ContactName"
		case docTranslationConfirmed = "DocTranslationConfirmed"
		case assignStatus = "AssignStatus"
		case invoiceDate = "InvoiceDate"
		case isChanged = "isChanged"
		case isOwnOrNot = "IsOwnOrNot"
		case customerPriority = "CustomerPriority"
		case vendorMileage = "VendorMileage"
		case interpreterCount = "InterpreterCount"
		case previousInterpreterCount = "PreviousInterpreterCount"
		case oneHremail = "oneHremail"
		case oneHrcnfmsg = "oneHrcnfmsg"
		case bulkemailconf = "bulkemailconf"
		case botchedReason = "BotchedReason"
		case image = "Image"
		case customerAddress1 = "CustomerAddress1"
		case customerAddress2 = "CustomerAddress2"
		case customerAddress3 = "CustomerAddress3"
		case customerCity = "CustomerCity"
		case customerPhone = "CustomerPhone"
		case customerEmail = "CustomerEmail"
		case customerExtension = "CustomerExtension"
		case serviceVerificationName = "ServiceVerificationName"
		case confrimbulkBy = "ConfrimbulkBy"
		case supportPermission = "SupportPermission"
		case supportmcount = "Supportmcount"
		case purchaseOrder = "PurchaseOrder"
		case claim = "Claim"
		case reference = "Reference"
		case customerCancelRequest = "CustomerCancelRequest"
		case costOfJob = "CostOfJob"
		case isNotarized = "IsNotarized"
		case invoiceNotes = "InvoiceNotes"
		case upworkRef = "UpworkRef"
		case clientDueDate = "ClientDueDate"
		case sLanguageID = "SLanguageID"
		case sLanguageName = "SLanguageName"
		case id = "id"
		case title = "title"
		case url = "url"
		case class1 = "class1"
		case start = "start"
		case end = "end"
		case proiectName = "ProiectName"
		case approvedDate = "ApprovedDate"
		case declinedDate = "DeclinedDate"
		case tranlatedFile = "TranlatedFile"
		case submitDate = "SubmitDate"
		case createdBy = "CreatedBy"
		case translatorName = "TranslatorName"
		case translatorRate = "TranslatorRate"
		case vendorthirdPartyFee = "VendorthirdPartyFee"
		case totalCustomercost = "TotalCustomercost"
		case completedDate = "CompletedDate"
		case vendorCost = "VendorCost"
		case vendorTranslatorTotal = "VendorTranslatorTotal"
		case margin = "Margin"
		case encounter = "Encounter"
		case simultaneousHours = "SimultaneousHours"
		case isencounter = "isencounter"
		case missingformsEmailCount = "MissingformsEmailCount"
		case customerBill = "CustomerBill"
		case vendorExpenses = "VendorExpenses"
		case x = "x"
		case label = "label"
		case y = "y"
		case appointmentAllID = "AppointmentAllID"
		case vendorCancelledBy = "VendorCancelledBy"
		case vendorCancelledDate = "VendorCancelledDate"
		case requestorName = "RequestorName"
		case requestorEmail = "RequestorEmail"
		case assignToFieldStaff = "AssignToFieldStaff"
		case tFNotes = "TFNotes"
		case customerSignature = "CustomerSignature"
		case interpreterSignature = "InterpreterSignature"
		case customerRate = "CustomerRate"
		case checkIn = "CheckIn"
		case checkOut = "CheckOut"
		case checkInDateTime = "CheckInDateTime"
		case checkOutDateTime = "CheckOutDateTime"
		case checkUser = "CheckUser"
		case checkUserName = "CheckUserName"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		filecode = try values.decodeIfPresent(String.self, forKey: .filecode)
		appointmentID = try values.decodeIfPresent(Int.self, forKey: .appointmentID)
		cActive = try values.decodeIfPresent(String.self, forKey: .cActive)
		overrideSatus = try values.decodeIfPresent(String.self, forKey: .overrideSatus)
		overrideauth = try values.decodeIfPresent(String.self, forKey: .overrideauth)
		multipleVenueFlag = try values.decodeIfPresent(String.self, forKey: .multipleVenueFlag)
		requestID = try values.decodeIfPresent(String.self, forKey: .requestID)
		serviceType = try values.decodeIfPresent(String.self, forKey: .serviceType)
		authCode = try values.decodeIfPresent(String.self, forKey: .authCode)
		displayValue = try values.decodeIfPresent(String.self, forKey: .displayValue)
		timeUpdateStatus = try values.decodeIfPresent(String.self, forKey: .timeUpdateStatus)
		venueName = try values.decodeIfPresent(String.self, forKey: .venueName)
		providerName = try values.decodeIfPresent(String.self, forKey: .providerName)
		vendorAddress = try values.decodeIfPresent(String.self, forKey: .vendorAddress)
		departmentName = try values.decodeIfPresent(String.self, forKey: .departmentName)
		appointmentTypeID = try values.decodeIfPresent(Int.self, forKey: .appointmentTypeID)
		appointmentStatusType = try values.decodeIfPresent(String.self, forKey: .appointmentStatusType)
		hashofminutes = try values.decodeIfPresent(String.self, forKey: .hashofminutes)
		appointmentType = try values.decodeIfPresent(String.self, forKey: .appointmentType)
		appointmentStatusTypeCode = try values.decodeIfPresent(String.self, forKey: .appointmentStatusTypeCode)
		appointmentStatusTypeTemp = try values.decodeIfPresent(String.self, forKey: .appointmentStatusTypeTemp)
		appointmentStatusID = try values.decodeIfPresent(String.self, forKey: .appointmentStatusID)
		billRate = try values.decodeIfPresent(String.self, forKey: .billRate)
		tierName = try values.decodeIfPresent(String.self, forKey: .tierName)
		mgemilRist = try values.decodeIfPresent(String.self, forKey: .mgemilRist)
		startDateTimeTemp = try values.decodeIfPresent(String.self, forKey: .startDateTimeTemp)
		endDateTimeTemp = try values.decodeIfPresent(String.self, forKey: .endDateTimeTemp)
		additionRembersmentDes = try values.decodeIfPresent(String.self, forKey: .additionRembersmentDes)
		timeFinishReview = try values.decodeIfPresent(Int.self, forKey: .timeFinishReview)
		scheduleNotes = try values.decodeIfPresent(String.self, forKey: .scheduleNotes)
		aptDetails = try values.decodeIfPresent(String.self, forKey: .aptDetails)
		financialNotes = try values.decodeIfPresent(String.self, forKey: .financialNotes)
		specialityID = try values.decodeIfPresent(String.self, forKey: .specialityID)
		companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
		mainPhone = try values.decodeIfPresent(String.self, forKey: .mainPhone)
		languageID = try values.decodeIfPresent(Int.self, forKey: .languageID)
		languageName = try values.decodeIfPresent(String.self, forKey: .languageName)
		userType = try values.decodeIfPresent(String.self, forKey: .userType)
		companyID = try values.decodeIfPresent(Int.self, forKey: .companyID)
		oSMillageRate = try values.decodeIfPresent(String.self, forKey: .oSMillageRate)
		customerID = try values.decodeIfPresent(Int.self, forKey: .customerID)
		vendorName = try values.decodeIfPresent(String.self, forKey: .vendorName)
		unicFlag = try values.decodeIfPresent(String.self, forKey: .unicFlag)
		badgeNumber = try values.decodeIfPresent(String.self, forKey: .badgeNumber)
		onsiteMilage = try values.decodeIfPresent(String.self, forKey: .onsiteMilage)
		interpreterID = try values.decodeIfPresent(Int.self, forKey: .interpreterID)
		officialCompany = try values.decodeIfPresent(String.self, forKey: .officialCompany)
		acceptAndDeclineStatus = try values.decodeIfPresent(String.self, forKey: .acceptAndDeclineStatus)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		oSPerHourFee = try values.decodeIfPresent(String.self, forKey: .oSPerHourFee)
		perHourFee = try values.decodeIfPresent(String.self, forKey: .perHourFee)
		startDateTime = try values.decodeIfPresent(String.self, forKey: .startDateTime)
		designedDueDate = try values.decodeIfPresent(String.self, forKey: .designedDueDate)
		notoficationId = try values.decodeIfPresent(String.self, forKey: .notoficationId)
		endDateTime = try values.decodeIfPresent(String.self, forKey: .endDateTime)
		userColor = try values.decodeIfPresent(String.self, forKey: .userColor)
		decspt = try values.decodeIfPresent(Bool.self, forKey: .decspt)
		caseName = try values.decodeIfPresent(String.self, forKey: .caseName)
		clientInitial = try values.decodeIfPresent(String.self, forKey: .clientInitial)
		clientName = try values.decodeIfPresent(String.self, forKey: .clientName)
		cPIntials = try values.decodeIfPresent(String.self, forKey: .cPIntials)
		caseNumber = try values.decodeIfPresent(String.self, forKey: .caseNumber)
		securityClearence = try values.decodeIfPresent(String.self, forKey: .securityClearence)
		experienceOfVendor = try values.decodeIfPresent(String.self, forKey: .experienceOfVendor)
		interpreterType = try values.decodeIfPresent(String.self, forKey: .interpreterType)
		departureTime = try values.decodeIfPresent(String.self, forKey: .departureTime)
		arrivalTime = try values.decodeIfPresent(String.self, forKey: .arrivalTime)
		translationInvoice = try values.decodeIfPresent(Bool.self, forKey: .translationInvoice)
		translationConfirmed = try values.decodeIfPresent(Bool.self, forKey: .translationConfirmed)
		translationWaitingList = try values.decodeIfPresent(Bool.self, forKey: .translationWaitingList)
		translationCancellationFee = try values.decodeIfPresent(Bool.self, forKey: .translationCancellationFee)
		translationPriority = try values.decodeIfPresent(Bool.self, forKey: .translationPriority)
		fileID = try values.decodeIfPresent(String.self, forKey: .fileID)
		translationDesc = try values.decodeIfPresent(String.self, forKey: .translationDesc)
		requestscounts = try values.decodeIfPresent(Int.self, forKey: .requestscounts)
		venueID = try values.decodeIfPresent(String.self, forKey: .venueID)
		invoiceNumber = try values.decodeIfPresent(String.self, forKey: .invoiceNumber)
		providerID = try values.decodeIfPresent(String.self, forKey: .providerID)
		departmentID = try values.decodeIfPresent(String.self, forKey: .departmentID)
		customerUserName = try values.decodeIfPresent(String.self, forKey: .customerUserName)
		assignedByID = try values.decodeIfPresent(String.self, forKey: .assignedByID)
		assignedByName = try values.decodeIfPresent(String.self, forKey: .assignedByName)
		duration = try values.decodeIfPresent(Int.self, forKey: .duration)
		distance = try values.decodeIfPresent(String.self, forKey: .distance)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		callServiceBit = try values.decodeIfPresent(Bool.self, forKey: .callServiceBit)
		callTime = try values.decodeIfPresent(String.self, forKey: .callTime)
		purpose = try values.decodeIfPresent(String.self, forKey: .purpose)
		lastUpdated = try values.decodeIfPresent(String.self, forKey: .lastUpdated)
		office = try values.decodeIfPresent(String.self, forKey: .office)
		home = try values.decodeIfPresent(String.self, forKey: .home)
		cell = try values.decodeIfPresent(String.self, forKey: .cell)
		sourceLanguageID = try values.decodeIfPresent(String.self, forKey: .sourceLanguageID)
		targetLanguageID = try values.decodeIfPresent(String.self, forKey: .targetLanguageID)
		appointmentMilage = try values.decodeIfPresent(String.self, forKey: .appointmentMilage)
		peopleOnCall = try values.decodeIfPresent(String.self, forKey: .peopleOnCall)
		invoiceCount = try values.decodeIfPresent(String.self, forKey: .invoiceCount)
		callerNames = try values.decodeIfPresent(String.self, forKey: .callerNames)
		wordCount = try values.decodeIfPresent(String.self, forKey: .wordCount)
		uploadedDocument = try values.decodeIfPresent(String.self, forKey: .uploadedDocument)
		projectDueDate = try values.decodeIfPresent(String.self, forKey: .projectDueDate)
		translationType = try values.decodeIfPresent(String.self, forKey: .translationType)
		translationCancellationFeeBit = try values.decodeIfPresent(String.self, forKey: .translationCancellationFeeBit)
		translationPriorityBit = try values.decodeIfPresent(String.self, forKey: .translationPriorityBit)
		translationRequestedDate = try values.decodeIfPresent(String.self, forKey: .translationRequestedDate)
		translationVendorRankingID = try values.decodeIfPresent(String.self, forKey: .translationVendorRankingID)
		waitingList = try values.decodeIfPresent(Bool.self, forKey: .waitingList)
		bookedBy = try values.decodeIfPresent(Int.self, forKey: .bookedBy)
		bookedByName = try values.decodeIfPresent(String.self, forKey: .bookedByName)
		bookedOn = try values.decodeIfPresent(String.self, forKey: .bookedOn)
		confirmedBy = try values.decodeIfPresent(Int.self, forKey: .confirmedBy)
		confirmedByName = try values.decodeIfPresent(String.self, forKey: .confirmedByName)
		confirmedOn = try values.decodeIfPresent(String.self, forKey: .confirmedOn)
		cancelledBy = try values.decodeIfPresent(String.self, forKey: .cancelledBy)
		cancelledByName = try values.decodeIfPresent(String.self, forKey: .cancelledByName)
		cancelledOn = try values.decodeIfPresent(String.self, forKey: .cancelledOn)
		loadedBy = try values.decodeIfPresent(String.self, forKey: .loadedBy)
		loadedByName = try values.decodeIfPresent(String.self, forKey: .loadedByName)
		loadedOn = try values.decodeIfPresent(String.self, forKey: .loadedOn)
		requestedBy = try values.decodeIfPresent(Int.self, forKey: .requestedBy)
		requestedByName = try values.decodeIfPresent(String.self, forKey: .requestedByName)
		requestedOn = try values.decodeIfPresent(String.self, forKey: .requestedOn)
		updateDate = try values.decodeIfPresent(String.self, forKey: .updateDate)
		priority = try values.decodeIfPresent(Bool.self, forKey: .priority)
		customerReturnDate = try values.decodeIfPresent(String.self, forKey: .customerReturnDate)
		addedOn = try values.decodeIfPresent(String.self, forKey: .addedOn)
		cancellationFee = try values.decodeIfPresent(Bool.self, forKey: .cancellationFee)
		deleteStatus = try values.decodeIfPresent(Bool.self, forKey: .deleteStatus)
		changeStatus = try values.decodeIfPresent(Bool.self, forKey: .changeStatus)
		qBID = try values.decodeIfPresent(String.self, forKey: .qBID)
		qBEditID = try values.decodeIfPresent(String.self, forKey: .qBEditID)
		ranking = try values.decodeIfPresent(String.self, forKey: .ranking)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		number = try values.decodeIfPresent(String.self, forKey: .number)
		travelling = try values.decodeIfPresent(String.self, forKey: .travelling)
		notarized = try values.decodeIfPresent(String.self, forKey: .notarized)
		specializedTerminology = try values.decodeIfPresent(String.self, forKey: .specializedTerminology)
		priorityfee = try values.decodeIfPresent(String.self, forKey: .priorityfee)
		publicPrivate = try values.decodeIfPresent(Bool.self, forKey: .publicPrivate)
		confirmationBit = try values.decodeIfPresent(Bool.self, forKey: .confirmationBit)
		invoiceBit = try values.decodeIfPresent(Bool.self, forKey: .invoiceBit)
		syncBit = try values.decodeIfPresent(Bool.self, forKey: .syncBit)
		cSyncBit = try values.decodeIfPresent(Bool.self, forKey: .cSyncBit)
		messageID = try values.decodeIfPresent(String.self, forKey: .messageID)
		readyToSync = try values.decodeIfPresent(Bool.self, forKey: .readyToSync)
		creadyToSync = try values.decodeIfPresent(Bool.self, forKey: .creadyToSync)
		specialityName = try values.decodeIfPresent(String.self, forKey: .specialityName)
		active = try values.decodeIfPresent(String.self, forKey: .active)
		customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		conformationKey = try values.decodeIfPresent(String.self, forKey: .conformationKey)
		interpreterBookedId = try values.decodeIfPresent(String.self, forKey: .interpreterBookedId)
		filecounts = try values.decodeIfPresent(Int.self, forKey: .filecounts)
		vendorFilecounts = try values.decodeIfPresent(Int.self, forKey: .vendorFilecounts)
		total = try values.decodeIfPresent(String.self, forKey: .total)
		mileageCost = try values.decodeIfPresent(String.self, forKey: .mileageCost)
		cutomerInvoicesTotal = try values.decodeIfPresent(String.self, forKey: .cutomerInvoicesTotal)
		vendorSpecializedTerminology = try values.decodeIfPresent(String.self, forKey: .vendorSpecializedTerminology)
		vendorPriorityfee = try values.decodeIfPresent(String.self, forKey: .vendorPriorityfee)
		tRANTargetLanguagesRate = try values.decodeIfPresent(Int.self, forKey: .tRANTargetLanguagesRate)
		interpretorName = try values.decodeIfPresent(String.self, forKey: .interpretorName)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
		zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode)
		appointmentCount = try values.decodeIfPresent(String.self, forKey: .appointmentCount)
		targetLanguageName = try values.decodeIfPresent(String.self, forKey: .targetLanguageName)
		isExpired = try values.decodeIfPresent(String.self, forKey: .isExpired)
		billProcess = try values.decodeIfPresent(String.self, forKey: .billProcess)
		finishedFileName = try values.decodeIfPresent(String.self, forKey: .finishedFileName)
		finishedFileType = try values.decodeIfPresent(String.self, forKey: .finishedFileType)
		endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
		finishedTime = try values.decodeIfPresent(String.self, forKey: .finishedTime)
		previousTime = try values.decodeIfPresent(String.self, forKey: .previousTime)
		myrequest = try values.decodeIfPresent(String.self, forKey: .myrequest)
		custRequestID = try values.decodeIfPresent(String.self, forKey: .custRequestID)
		custrequestCode = try values.decodeIfPresent(String.self, forKey: .custrequestCode)
		isAssigned = try values.decodeIfPresent(String.self, forKey: .isAssigned)
		appoinmentFileList = try values.decodeIfPresent(String.self, forKey: .appoinmentFileList)
		appoinmentvenueList = try values.decodeIfPresent(String.self, forKey: .appoinmentvenueList)
		additionRembersmentList = try values.decodeIfPresent(String.self, forKey: .additionRembersmentList)
		startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
		customerUserID = try values.decodeIfPresent(String.self, forKey: .customerUserID)
		acceptRequestscounts = try values.decodeIfPresent(String.self, forKey: .acceptRequestscounts)
		declineRequestscounts = try values.decodeIfPresent(String.self, forKey: .declineRequestscounts)
		isDirect = try values.decodeIfPresent(String.self, forKey: .isDirect)
		vendorEmailConformation = try values.decodeIfPresent(Int.self, forKey: .vendorEmailConformation)
		vendorEmailConfDate = try values.decodeIfPresent(String.self, forKey: .vendorEmailConfDate)
		clientAddress = try values.decodeIfPresent(String.self, forKey: .clientAddress)
		address2 = try values.decodeIfPresent(String.self, forKey: .address2)
		clientCity = try values.decodeIfPresent(String.self, forKey: .clientCity)
		clientZipCode = try values.decodeIfPresent(String.self, forKey: .clientZipCode)
		clientStateName = try values.decodeIfPresent(String.self, forKey: .clientStateName)
		additionTravelTimePay = try values.decodeIfPresent(String.self, forKey: .additionTravelTimePay)
		updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn)
		updatedBy = try values.decodeIfPresent(String.self, forKey: .updatedBy)
		updateUser = try values.decodeIfPresent(String.self, forKey: .updateUser)
		reasonforBotch = try values.decodeIfPresent(String.self, forKey: .reasonforBotch)
		phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
		venueCount = try values.decodeIfPresent(String.self, forKey: .venueCount)
		updatedStartDate = try values.decodeIfPresent(String.self, forKey: .updatedStartDate)
		syncText = try values.decodeIfPresent(String.self, forKey: .syncText)
		createUser = try values.decodeIfPresent(String.self, forKey: .createUser)
		interpreterRate = try values.decodeIfPresent(String.self, forKey: .interpreterRate)
		additionRembersment = try values.decodeIfPresent(String.self, forKey: .additionRembersment)
		clientInvoiceNotes = try values.decodeIfPresent(String.self, forKey: .clientInvoiceNotes)
		startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
		createDate = try values.decodeIfPresent(String.self, forKey: .createDate)
		returndate = try values.decodeIfPresent(String.self, forKey: .returndate)
		totalCustomerBill = try values.decodeIfPresent(String.self, forKey: .totalCustomerBill)
		totalHours = try values.decodeIfPresent(String.self, forKey: .totalHours)
		appointmentsCount = try values.decodeIfPresent(String.self, forKey: .appointmentsCount)
		totalCustomerMilageRate = try values.decodeIfPresent(String.self, forKey: .totalCustomerMilageRate)
		totalVendorExpenses = try values.decodeIfPresent(String.self, forKey: .totalVendorExpenses)
		vendorMileageRate = try values.decodeIfPresent(String.self, forKey: .vendorMileageRate)
		roundtripMil = try values.decodeIfPresent(String.self, forKey: .roundtripMil)
		perMilesBill = try values.decodeIfPresent(String.self, forKey: .perMilesBill)
		profitOrLoss = try values.decodeIfPresent(String.self, forKey: .profitOrLoss)
		totalMargin = try values.decodeIfPresent(String.self, forKey: .totalMargin)
		appointmentTypeName = try values.decodeIfPresent(String.self, forKey: .appointmentTypeName)
		totalMileageRate = try values.decodeIfPresent(String.self, forKey: .totalMileageRate)
		appointmentRate = try values.decodeIfPresent(String.self, forKey: .appointmentRate)
		roundTripMile = try values.decodeIfPresent(String.self, forKey: .roundTripMile)
		mileageRate = try values.decodeIfPresent(String.self, forKey: .mileageRate)
		vendorRate = try values.decodeIfPresent(String.self, forKey: .vendorRate)
		syncDate = try values.decodeIfPresent(String.self, forKey: .syncDate)
		previousStatus = try values.decodeIfPresent(String.self, forKey: .previousStatus)
		nullDate = try values.decodeIfPresent(String.self, forKey: .nullDate)
		tempFileName = try values.decodeIfPresent(String.self, forKey: .tempFileName)
		templateID = try values.decodeIfPresent(String.self, forKey: .templateID)
		templateName = try values.decodeIfPresent(String.self, forKey: .templateName)
		templateWordCount = try values.decodeIfPresent(String.self, forKey: .templateWordCount)
		finalWordCount = try values.decodeIfPresent(String.self, forKey: .finalWordCount)
		typeuser = try values.decodeIfPresent(String.self, forKey: .typeuser)
		tEdateStatus = try values.decodeIfPresent(String.self, forKey: .tEdateStatus)
		tSdateStatus = try values.decodeIfPresent(String.self, forKey: .tSdateStatus)
		oldStartDateTime = try values.decodeIfPresent(String.self, forKey: .oldStartDateTime)
		oldEndDateTime = try values.decodeIfPresent(String.self, forKey: .oldEndDateTime)
		sendingEndTimes = try values.decodeIfPresent(String.self, forKey: .sendingEndTimes)
		proofReader = try values.decodeIfPresent(String.self, forKey: .proofReader)
		tempStatus = try values.decodeIfPresent(String.self, forKey: .tempStatus)
		vendorJobType = try values.decodeIfPresent(String.self, forKey: .vendorJobType)
		quote = try values.decodeIfPresent(String.self, forKey: .quote)
		approvedForTranslation = try values.decodeIfPresent(String.self, forKey: .approvedForTranslation)
		paidNotVisible = try values.decodeIfPresent(String.self, forKey: .paidNotVisible)
		receivedDate = try values.decodeIfPresent(String.self, forKey: .receivedDate)
		translationSpecialties = try values.decodeIfPresent(String.self, forKey: .translationSpecialties)
		translatorDueDate = try values.decodeIfPresent(String.self, forKey: .translatorDueDate)
		proofreaderBooked = try values.decodeIfPresent(String.self, forKey: .proofreaderBooked)
		proofreaderDueDate = try values.decodeIfPresent(String.self, forKey: .proofreaderDueDate)
		specialFormatting = try values.decodeIfPresent(String.self, forKey: .specialFormatting)
		experience = try values.decodeIfPresent(String.self, forKey: .experience)
		minimumCharge = try values.decodeIfPresent(String.self, forKey: .minimumCharge)
		contactName = try values.decodeIfPresent(String.self, forKey: .contactName)
		docTranslationConfirmed = try values.decodeIfPresent(String.self, forKey: .docTranslationConfirmed)
		assignStatus = try values.decodeIfPresent(String.self, forKey: .assignStatus)
		invoiceDate = try values.decodeIfPresent(String.self, forKey: .invoiceDate)
		isChanged = try values.decodeIfPresent(String.self, forKey: .isChanged)
		isOwnOrNot = try values.decodeIfPresent(String.self, forKey: .isOwnOrNot)
		customerPriority = try values.decodeIfPresent(String.self, forKey: .customerPriority)
		vendorMileage = try values.decodeIfPresent(String.self, forKey: .vendorMileage)
		interpreterCount = try values.decodeIfPresent(String.self, forKey: .interpreterCount)
		previousInterpreterCount = try values.decodeIfPresent(String.self, forKey: .previousInterpreterCount)
		oneHremail = try values.decodeIfPresent(String.self, forKey: .oneHremail)
		oneHrcnfmsg = try values.decodeIfPresent(String.self, forKey: .oneHrcnfmsg)
		bulkemailconf = try values.decodeIfPresent(String.self, forKey: .bulkemailconf)
		botchedReason = try values.decodeIfPresent(String.self, forKey: .botchedReason)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		customerAddress1 = try values.decodeIfPresent(String.self, forKey: .customerAddress1)
		customerAddress2 = try values.decodeIfPresent(String.self, forKey: .customerAddress2)
		customerAddress3 = try values.decodeIfPresent(String.self, forKey: .customerAddress3)
		customerCity = try values.decodeIfPresent(String.self, forKey: .customerCity)
		customerPhone = try values.decodeIfPresent(String.self, forKey: .customerPhone)
		customerEmail = try values.decodeIfPresent(String.self, forKey: .customerEmail)
		customerExtension = try values.decodeIfPresent(String.self, forKey: .customerExtension)
		serviceVerificationName = try values.decodeIfPresent(String.self, forKey: .serviceVerificationName)
		confrimbulkBy = try values.decodeIfPresent(String.self, forKey: .confrimbulkBy)
		supportPermission = try values.decodeIfPresent(String.self, forKey: .supportPermission)
		supportmcount = try values.decodeIfPresent(String.self, forKey: .supportmcount)
		purchaseOrder = try values.decodeIfPresent(String.self, forKey: .purchaseOrder)
		claim = try values.decodeIfPresent(String.self, forKey: .claim)
		reference = try values.decodeIfPresent(String.self, forKey: .reference)
		customerCancelRequest = try values.decodeIfPresent(Int.self, forKey: .customerCancelRequest)
		costOfJob = try values.decodeIfPresent(String.self, forKey: .costOfJob)
		isNotarized = try values.decodeIfPresent(String.self, forKey: .isNotarized)
		invoiceNotes = try values.decodeIfPresent(String.self, forKey: .invoiceNotes)
		upworkRef = try values.decodeIfPresent(String.self, forKey: .upworkRef)
		clientDueDate = try values.decodeIfPresent(String.self, forKey: .clientDueDate)
		sLanguageID = try values.decodeIfPresent(Int.self, forKey: .sLanguageID)
		sLanguageName = try values.decodeIfPresent(String.self, forKey: .sLanguageName)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		class1 = try values.decodeIfPresent(String.self, forKey: .class1)
		start = try values.decodeIfPresent(String.self, forKey: .start)
		end = try values.decodeIfPresent(String.self, forKey: .end)
		proiectName = try values.decodeIfPresent(String.self, forKey: .proiectName)
		approvedDate = try values.decodeIfPresent(String.self, forKey: .approvedDate)
		declinedDate = try values.decodeIfPresent(String.self, forKey: .declinedDate)
		tranlatedFile = try values.decodeIfPresent(String.self, forKey: .tranlatedFile)
		submitDate = try values.decodeIfPresent(String.self, forKey: .submitDate)
		createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
		translatorName = try values.decodeIfPresent(String.self, forKey: .translatorName)
		translatorRate = try values.decodeIfPresent(String.self, forKey: .translatorRate)
		vendorthirdPartyFee = try values.decodeIfPresent(String.self, forKey: .vendorthirdPartyFee)
		totalCustomercost = try values.decodeIfPresent(String.self, forKey: .totalCustomercost)
		completedDate = try values.decodeIfPresent(String.self, forKey: .completedDate)
		vendorCost = try values.decodeIfPresent(String.self, forKey: .vendorCost)
		vendorTranslatorTotal = try values.decodeIfPresent(String.self, forKey: .vendorTranslatorTotal)
		margin = try values.decodeIfPresent(String.self, forKey: .margin)
		encounter = try values.decodeIfPresent(String.self, forKey: .encounter)
		simultaneousHours = try values.decodeIfPresent(String.self, forKey: .simultaneousHours)
		isencounter = try values.decodeIfPresent(String.self, forKey: .isencounter)
		missingformsEmailCount = try values.decodeIfPresent(String.self, forKey: .missingformsEmailCount)
		customerBill = try values.decodeIfPresent(String.self, forKey: .customerBill)
		vendorExpenses = try values.decodeIfPresent(String.self, forKey: .vendorExpenses)
		x = try values.decodeIfPresent(String.self, forKey: .x)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		y = try values.decodeIfPresent(String.self, forKey: .y)
		appointmentAllID = try values.decodeIfPresent(String.self, forKey: .appointmentAllID)
		vendorCancelledBy = try values.decodeIfPresent(String.self, forKey: .vendorCancelledBy)
		vendorCancelledDate = try values.decodeIfPresent(String.self, forKey: .vendorCancelledDate)
		requestorName = try values.decodeIfPresent(String.self, forKey: .requestorName)
		requestorEmail = try values.decodeIfPresent(String.self, forKey: .requestorEmail)
		assignToFieldStaff = try values.decodeIfPresent(String.self, forKey: .assignToFieldStaff)
		tFNotes = try values.decodeIfPresent(String.self, forKey: .tFNotes)
		customerSignature = try values.decodeIfPresent(String.self, forKey: .customerSignature)
		interpreterSignature = try values.decodeIfPresent(String.self, forKey: .interpreterSignature)
		customerRate = try values.decodeIfPresent(String.self, forKey: .customerRate)
		checkIn = try values.decodeIfPresent(Int.self, forKey: .checkIn)
		checkOut = try values.decodeIfPresent(Int.self, forKey: .checkOut)
		checkInDateTime = try values.decodeIfPresent(String.self, forKey: .checkInDateTime)
		checkOutDateTime = try values.decodeIfPresent(String.self, forKey: .checkOutDateTime)
		checkUser = try values.decodeIfPresent(String.self, forKey: .checkUser)
		checkUserName = try values.decodeIfPresent(String.self, forKey: .checkUserName)
	}

}

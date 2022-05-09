//
//  OnsiteInterpretationNewViewController.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 19/01/22.
//

import UIKit
import iOSDropDown
import Alamofire
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields

struct SpecialityData {
    var SpecialityID : Int?
    var DisplayValue : String?
    var Duration : Int?
}
struct ServiceData {
    var SpecialityID : Int?
    var DisplayValue : String?
    var Duration : Int?
}
struct LanguageData {
    var languageID : Int?
    var languageName : String?
    var rate :Double?
}
struct GenderData {
    var Id: Int
    var Code: String
    var Value: String
    var type: String
}
struct VenueData {
    var Address :String?
    var  Address2 :String?
    var City :String?
    var CompanyID :Int?
    var CustomerCompany :String?
    var CustomerName :String?
    var Notes :String?
    var State :String?
    var StateID :Int?
    var VenueID :Int?
    var VenueName :String?
    var ZipCode :String?
    var isOneTime:Bool?
}
struct DepartmentData {
    var DeActive :Int?
    var DepartmentID :Int?
    var DepartmentName :String?
    var isOneTime:Bool?
}
struct ProviderData {
    var ProviderID :Int?
    var ProviderName :String?
    var isOneTime: Bool?
}
struct SubCustomerListData {
    var UniqueID: Int?
    var Email : String?
    var CustomerUserName: String?
    var Priority : Int?
    var MasterUsertype : Int?
    var Mobile : String?
    var PurchaseOrderNote : String?
    var CustomerID : Int?
    var CustomerFullName : String?
    var EmailToRequestor : Int?
}

struct ApiEncryptedDataResponse : Codable {
    let value : String?

    enum CodingKeys: String, CodingKey {

        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}



public func convertDateFormatFromOneFormatToOther(date: String,currentFormat: String,reqFormat : String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = currentFormat
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = reqFormat
    return  dateFormatter.string(from: date!)

}

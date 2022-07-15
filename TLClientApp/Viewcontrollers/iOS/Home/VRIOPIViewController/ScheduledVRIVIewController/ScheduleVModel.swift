//
//  ScheduleVModel.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 13/07/22.
//

import Foundation
class ScheduleModel: NSObject {
    var SCHEDULVRIDETAILSBYID: NSMutableArray?
    override init() {
        SCHEDULVRIDETAILSBYID = NSMutableArray()
    }
    class func getScheduleData(dicts: NSDictionary) -> ScheduleModel {
        let item = ScheduleModel()
        item.SCHEDULVRIDETAILSBYID = NSMutableArray()
        let arr: NSArray = dicts["SCHEDULVRIDETAILSBYID"] as! NSArray
        for obj in arr {
            let nItem :ScheduleDataModel = ScheduleDataModel.getLanguageList(dicts: obj as! NSDictionary)
            item.SCHEDULVRIDETAILSBYID?.add(nItem)
        }
        return item
    }
}
class ScheduleDataModel : NSObject{
    var ThirdPartyCompanyId: String
    var RequestType : String
    var Inviteparticipant: String
    var UserType: String
    var StartDateTimeTemp: String
    var EndDateTimeTemp: String
    var AnticipatedDuration: String
    var LanguageID: String
    var DateTime: String
    var CreatedDate: String
    var CreatedBy: String
    var RequestedBy: String
    var Status: String
    var VendorId: String
    var VendorEmail: String
    var decspt : Bool
    var CaseName: String
    var CaseInitial : String
    var CaseNo: String
    var Notes: String
    var Random: String
    var SourceLanguageID: String
    var FirstName : String
    var LastName: String
    var PhNo: String
    var ConfMail: String
    var Speciality: String
    var ReasonCall: String
    var TranlatedFile: String
    var TranlatedWordCount: String
    var VendorList: String
    var AppointmentStatusType: String
    var VendorName: String
    var CustomerName: String
    var TLanguageName: String
    var SLanguageName: String
    var Id: String
    var Accepted: String
    var Decliend: String
    var UserId: String
    var AppointmentStatusTypeTemp: String
    var AppointmentID: String
    var active: String
    var ClientID: String
    var BadgeNo: String
    var GlobalFilterData: String
    override init() {
        ThirdPartyCompanyId = ""
        RequestType = ""
        Inviteparticipant = ""
        UserType = ""
        StartDateTimeTemp = ""
        EndDateTimeTemp = ""
        AnticipatedDuration = ""
        LanguageID = ""
        DateTime = ""
        CreatedDate = ""
        CreatedBy = ""
        RequestedBy = ""
        Status = ""
        VendorId = ""
        VendorEmail = ""
        decspt = false
        CaseName = ""
        CaseInitial = ""
        CaseNo = ""
        Notes = ""
        Random = ""
        SourceLanguageID = ""
        FirstName = ""
        LastName = ""
        PhNo = ""
        ConfMail = ""
        Speciality = ""
        ReasonCall = ""
        TranlatedFile = ""
        TranlatedWordCount = ""
        VendorList = ""
        AppointmentStatusType = ""
        VendorName = ""
        CustomerName = ""
        TLanguageName = ""
        SLanguageName = ""
        Id = ""
        Accepted = ""
        Decliend = ""
        UserId = ""
        AppointmentStatusTypeTemp = ""
        AppointmentID = ""
        active = ""
        ClientID = ""
        BadgeNo = ""
        GlobalFilterData = ""
        
    }
    class func getLanguageList(dicts: NSDictionary) -> ScheduleDataModel {
        
        let item = ScheduleDataModel()
        item.ThirdPartyCompanyId = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ThirdPartyCompanyId") ?? "") as String
        item.RequestType = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "RequestType") ?? "") as String
        item.Inviteparticipant = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Inviteparticipant") ?? "") as String
        item.UserType = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserType") ?? "") as String
        item.StartDateTimeTemp = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "StartDateTimeTemp") ?? "") as String
        item.EndDateTimeTemp = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "EndDateTimeTemp") ?? "") as String
        item.AnticipatedDuration = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "AnticipatedDuration") ?? "") as String
        item.LanguageID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LanguageID") ?? "") as String
        item.DateTime = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "DateTime") ?? "") as String
        item.CreatedDate = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CreatedDate") ?? "") as String
        item.CreatedBy = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CreatedBy") ?? "") as String
        item.Status = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Status") ?? "") as String
        item.VendorId = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VendorId") ?? "") as String
        item.VendorEmail = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VendorEmail") ?? "") as String
        item.decspt  = (dicts.value(forKey: "Active") as? Bool) ?? false
        item.CaseName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CaseName") ?? "") as String
        item.CaseInitial = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CaseInitial") ?? "") as String
        item.CaseNo = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CaseNo") ?? "") as String
        item.Notes = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Notes") ?? "") as String
        item.Random = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Random") ?? "") as String
        item.SourceLanguageID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "SourceLanguageID") ?? "") as String
        item.FirstName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "FirstName") ?? "") as String
        item.LastName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LastName") ?? "") as String
        item.PhNo = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "PhNo") ?? "") as String
        item.ConfMail = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ConfMail") ?? "") as String
        item.Speciality = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Speciality") ?? "") as String
        item.ReasonCall = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ReasonCall") ?? "") as String
        item.TranlatedFile = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TranlatedFile") ?? "") as String
        item.TranlatedWordCount = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TranlatedWordCount") ?? "") as String
        item.VendorList = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VendorList") ?? "") as String
        item.AppointmentStatusType = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "AppointmentStatusType") ?? "") as String
        item.VendorName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "VendorName") ?? "") as String
        item.CustomerName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CustomerName") ?? "") as String
        item.TLanguageName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TLanguageName") ?? "") as String
        item.SLanguageName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "SLanguageName") ?? "") as String
        item.Id = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Id") ?? "") as String
        item.Accepted = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Accepted") ?? "") as String
        item.Decliend = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Decliend") ?? "") as String
        item.UserId = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserId") ?? "") as String
        item.AppointmentStatusTypeTemp = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "AppointmentStatusTypeTemp") ?? "") as String
        item.AppointmentID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "AppointmentID") ?? "") as String
        item.active = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "active") ?? "") as String
        item.ClientID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ClientID") ?? "") as String
        item.BadgeNo = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "BadgeNo") ?? "") as String
        item.GlobalFilterData = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "GlobalFilterData") ?? "") as String
        return item
        
    }
}
class ScheduleViewModel: NSObject {
    var scheduleModel = ScheduleModel()
    func scheduleData(urlStr:String,complitionBlock: @escaping(ScheduleModel?, Error?) -> ()){
        
        WebServices.get(url: URL(string: urlStr)!) { (response, _) in
            self.scheduleModel  = ScheduleModel.getScheduleData(dicts: response as! NSDictionary)
            ///self.languageListArr = self.lanuageList.LanguageData as! [LanguageModel]
            complitionBlock(self.scheduleModel,nil)
            SwiftLoader.hide()
        } failureHandler: { (error, _) in
            complitionBlock(nil,nil)
            SwiftLoader.hide()
        }
        
    }
}

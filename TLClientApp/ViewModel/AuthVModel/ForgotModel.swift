//
//  ForgotModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/13/21.
//

import Foundation
/*{
 "SuccessErrorDetails": [
     {
         "Status": 1,
         "Message": "Please check your email inbox for steps to change your password."
     }
 ],
 "UserDetails": [
     {
         "UserName": "Naiyer_customer1",
         "Email": "naiyer.aghaz@gmail.com",
         "FirstName": "Naiyer",
         "LastName": "Aghaz",
         "EmailActivationKey": "5QC45C45",
         "MessageActivationKey": null,
         "CompanyName": "`development ios test company",
         "CompanyID": 55,
         "FromEmail": null
     }
 ]
}*/

class ForgotUser: NSObject {
    var SuccessErrorDetails : NSMutableArray?
    var UserDetails: NSMutableArray?
    override init(){
        SuccessErrorDetails = NSMutableArray()
        UserDetails  = NSMutableArray()
    }
  class func getForgotData(dicts: NSDictionary) -> ForgotUser {
        let item = ForgotUser()
        item.SuccessErrorDetails = NSMutableArray()
        let arr : NSArray = dicts["SuccessErrorDetails"] as! NSArray
        for obj in arr {
            let newItem: ErrorModel = ErrorModel.getErrorData(dicts: obj as! NSDictionary)
            item.SuccessErrorDetails?.add(newItem)
        }
    item.UserDetails = NSMutableArray()
    let arr2 : NSArray = dicts["UserDetails"] as! NSArray
    for obj in arr2 {
        let newItem: userDetailsModel = userDetailsModel.getUserDetails(dicts: obj as! NSDictionary)
        item.UserDetails?.add(newItem)
    }
        
        return item
    }
    
    
}
class ErrorModel: NSObject {
    var Status: String?
    var Message: String?
    override init() {
        Status = ""
        Message = ""
    }
   class func getErrorData(dicts:NSDictionary) -> ErrorModel {
        let item = ErrorModel()
        item.Status = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Status") ?? "") as String
        item.Message = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Message") ?? "") as String
        
        return item
    }
}
class userDetailsModel: NSObject {
    var UserName: String?
    var Email: String?
    var FirstName: String
    var LastName: String?
    var EmailActivationKey: String?
    var MessageActivationKey: String?
    var CompanyName: String?
    var CompanyID: String?
    var FromEmail: String?
    override init() {
        UserName = ""
        Email = ""
        FirstName = ""
        LastName = ""
        EmailActivationKey = ""
        MessageActivationKey = ""
        CompanyName = ""
        CompanyID = ""
        FromEmail = ""
    }
    class func getUserDetails(dicts: NSDictionary) -> userDetailsModel {
        let item = userDetailsModel()
        item.UserName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserName") ?? "") as String
        item.Email = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Email") ?? "") as String
        item.FirstName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "FirstName") ?? "") as String
        item.LastName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LastName") ?? "") as String
        item.EmailActivationKey = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "EmailActivationKey") ?? "") as String
        item.MessageActivationKey = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "MessageActivationKey") ?? "") as String
        item.CompanyName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyName") ?? "") as String
        item.CompanyID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyID") ?? "") as String
        item.FromEmail = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "FromEmail") ?? "") as String
        
        return item
    }
}


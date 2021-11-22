//
//  LoginModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/8/21.
//

import Foundation



class UserDetail: NSObject {
    
    var userDetails: NSMutableArray?
    
    override init() {
        
        userDetails = NSMutableArray()
    }
    class func getUserDetails(dicts: NSDictionary) -> UserDetail {
        let itemModel = UserDetail()
        
        itemModel.userDetails = NSMutableArray()
        let arr:NSArray = dicts["UserDetails"] as! NSArray
        
        for items in arr {
            let dict = items as! NSDictionary
            let rides:DetailsModal = DetailsModal.getUserDetailsData(dicts: dict)
            itemModel.userDetails?.add(rides)
        }
        return itemModel
    }
}
class DetailsModal: NSObject {
    var Message : String
    var UserID, userTypeID, companyID: String
    var userName, password: String
    var status: Bool
    var email, firstName, lastName: String
    var categoryID: String
    var fullName: String
    var qbid, qbEditID, interpreter, translator: String
    var subCompanyName: String
    var createDate, createUser, updateDate, updateUser: String
    var active: Bool
    var emailActivationKey, emailActivationKeyDateTime: String
    var groupID: String
    var phoneNumber, messageActivationKey: String
    var isAlreadyLoggedIN: Bool
    var forgotPasswordKey: String
    var isAcceptedAgreement: Bool
    var mulGroups, mulGroupIDs, tempCompanyID, latitude: String
    var longitude, ip, device: String
    var decline: Bool
    var usertoken: String
    var timeZone: String
    var proZUUID, prozImgurl: String
    var passwordResetStatus: String
    var deviceType, companyNameTemp, companyPhone, loginWay: String
    var userTypeName: String
    var userTypeID1: String
    var userTypeCode, userType: String
    var isAuthenticated, customerID: String
    var companyName, companyEmail: String
    var companyLogo: String
    var sessionID: String
    var userGuID: String
    var imageID: String
    var imageName, imageData, tokenID, deviceType1: String
    var companyUserToken, timeZone1, currencyCode, companyTimeZone: String
    var paymentType: String
    var currantBAL: String
    var dateFormat, dateTimeFormate: String
    var isSupportPermission: String
    var NewRegFlag: String?
    override init() {
        Message = ""
        UserID = ""
        userTypeID = ""
        companyID = ""
        
        userName = ""
        password = ""
        
        status = false
        email = ""
        firstName = ""
        lastName = ""
        categoryID = ""
        fullName = ""
        qbid = ""
        qbEditID = ""
        interpreter = ""
        translator = ""
        subCompanyName = ""
        createDate = ""
        createUser = ""
        updateDate = ""
        updateUser = ""
        active = false
        emailActivationKey = ""
        emailActivationKeyDateTime = ""
        groupID = ""
        phoneNumber = ""
        messageActivationKey = ""
        isAlreadyLoggedIN = false
        forgotPasswordKey = ""
        isAcceptedAgreement = false
        mulGroups = ""
        mulGroupIDs = ""
        tempCompanyID = ""
        latitude = ""
        longitude = ""
        ip = ""
        device = ""
        decline = false
        usertoken = ""
        timeZone = ""
        proZUUID = ""
        prozImgurl = ""
        passwordResetStatus = ""
        deviceType = ""
        companyNameTemp = ""
        companyPhone = ""
        loginWay = ""
        userTypeName = ""
        userTypeID1 = ""
        userTypeCode = ""
        userType = ""
        isAuthenticated = ""
        customerID = ""
        companyName = ""
        companyEmail = ""
        companyLogo = ""
        sessionID = ""
        userGuID = ""
        imageID = ""
        imageName = ""
        imageData = ""
        tokenID = ""
        deviceType1 = ""
        companyUserToken = ""
        timeZone1 = ""
        currencyCode = ""
        companyTimeZone = ""
        paymentType = ""
        currantBAL = ""
        dateFormat = ""
        dateTimeFormate = ""
        isSupportPermission = ""
        NewRegFlag = ""
        
    }
    class func getUserDetailsData(dicts: NSDictionary) -> DetailsModal {
        let item = DetailsModal()
        item.Message = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Message") ?? "") as String
        item.UserID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserID") ?? "") as String
        item.userTypeID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserTypeID") ?? "") as String
        item.companyID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyID") ?? "") as String
        
        item.userName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserName") ?? "") as String
        
        item.password = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Password") ?? "") as String
        if let status = dicts.value(forKey: "Status") as? Bool {
            item.status = status
        }
        else {
            item.status = false
        }
        
        item.email = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Email") ?? "") as String
        item.firstName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "FirstName") ?? "") as String
        item.lastName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LastName") ?? "") as String
        item.categoryID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CategoryID") ?? "") as String
        item.fullName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "FullName") ?? "") as String
        item.qbid = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "QBID") ?? "") as String
        item.qbEditID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "QBEditID") ?? "") as String
       
        item.interpreter = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Interpreter") ?? "") as String
        item.subCompanyName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "SubCompanyName") ?? "") as String
        item.translator = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Translator") ?? "") as String
        item.createDate = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CreateDate") ?? "") as String
        item.createUser = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CreateUser") ?? "") as String
        item.updateDate = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UpdateDate") ?? "") as String
        item.updateUser = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UpdateUser") ?? "") as String
        if let active = dicts.value(forKey: "Active") as? Bool {
            item.active = active
        }
        else {
            item.active = false
        }
        //  item.active =  dicts.value(forKey: "active") as! Bool
        item.emailActivationKey = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "EmailActivationKey") ?? "") as String
        item.emailActivationKeyDateTime = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "EmailActivationKeyDateTime") ?? "") as String
        item.groupID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "GroupID") ?? "") as String
        item.phoneNumber = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "PhoneNumber") ?? "") as String
        item.messageActivationKey = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "MessageActivationKey") ?? "") as String
        if let isAlreadyLoggedIN = dicts.value(forKey: "IsAlreadyLoggedIN") as? Bool {
            item.isAlreadyLoggedIN = isAlreadyLoggedIN
        }
        else {
            item.isAlreadyLoggedIN = false
        }
        
        item.forgotPasswordKey = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "forgotPasswordKey") ?? "") as String
        
        
        if let isAcceptedAgreement = dicts.value(forKey: "IsAcceptedAgreement") as? Bool {
            item.isAcceptedAgreement = isAcceptedAgreement
        }
        else {
            item.isAcceptedAgreement = false
        }
        item.mulGroups = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "MulGroups") ?? "") as String
        item.mulGroupIDs = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "MulGroupIDs") ?? "") as String
        item.tempCompanyID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TempCompanyID") ?? "") as String
        item.latitude = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Latitude") ?? "") as String
        item.longitude = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Longitude") ?? "") as String
        item.ip = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Ip") ?? "") as String
        
        item.device = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "device") ?? "") as String
        
        
        if let decline = dicts.value(forKey: "Decline") as? Bool {
            item.decline = decline
        }
        else {
            item.decline = false
        }
        item.usertoken = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "usertoken") ?? "") as String
        item.timeZone = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TimeZone") ?? "") as String
        item.proZUUID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ProZ_UUID") ?? "") as String
        item.prozImgurl = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Proz_imgurl") ?? "") as String
        item.passwordResetStatus = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "PasswordResetStatus") ?? "") as String
        item.deviceType = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "DeviceType") ?? "") as String
        item.companyNameTemp = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyNameTemp") ?? "") as String
        item.companyPhone = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyPhone") ?? "") as String
        item.loginWay = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "LoginWay") ?? "") as String
        item.NewRegFlag = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "NewRegFlag") ?? "") as String
        item.userTypeName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserTypeName") ?? "") as String
        item.userTypeID1 = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserTypeID1") ?? "") as String
        item.userTypeCode = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserTypeCode") ?? "") as String
        item.userType = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserType") ?? "") as String
        item.isAuthenticated = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "IsAuthenticated") ?? "") as String
        
        item.customerID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CustomerID") ?? "") as String
        item.companyName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyName") ?? "") as String
        item.companyEmail = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyEmail") ?? "") as String
        item.companyLogo = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyLogo") ?? "") as String
        item.sessionID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "SessionID") ?? "") as String
        item.userGuID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "UserGuID") ?? "") as String
        item.imageID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ImageId") ?? "") as String
        item.imageName = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ImageName") ?? "") as String
        item.imageData = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "ImageData") ?? "") as String
        item.tokenID = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TokenID") ?? "") as String
        item.deviceType1 = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "DeviceType1") ?? "") as String
        item.companyUserToken = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyUserToken") ?? "") as String
        item.timeZone1 = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "TimeZone1") ?? "") as String
        
        item.currencyCode = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "currencyCode") ?? "") as String
        item.companyTimeZone = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CompanyTimeZone") ?? "") as String
        item.paymentType = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "PaymentType") ?? "") as String
        item.currantBAL = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CurrantBal") ?? "") as String
        item.dateFormat = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "DateFormat") ?? "") as String
        item.dateTimeFormate = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "DateTimeFormate") ?? "") as String
        item.isSupportPermission = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "IsSupportPermission") ?? "") as String
        return item
    }
}
class UpdatedUserDeviceToken: NSObject {
    
    var table: NSMutableArray?
    
    override init() {
        
        table = NSMutableArray()
    }
    class func getUserDetails(dicts: NSDictionary) -> UpdatedUserDeviceToken {
        let itemModel = UpdatedUserDeviceToken()
        
        itemModel.table = NSMutableArray()
        let arr:NSArray = dicts["Table"] as! NSArray
        
        for items in arr {
            let dict = items as! NSDictionary
            let rides:TableModel = TableModel.getUserDetailsData(dicts: dict)
            itemModel.table?.add(rides)
        }
        return itemModel
    }
}

class TableModel: NSObject {
   
    var success, tokenid, devicetype, Utype, CurrentUserGuid: String
    
    
    override init() {
        success = ""
        tokenid = ""
        devicetype = ""
        Utype = ""
        
        CurrentUserGuid = ""
       
        
    }
    class func getUserDetailsData(dicts: NSDictionary) -> TableModel {
        let item = TableModel()
        item.success = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "success") ?? "") as String
        item.tokenid = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "tokenid") ?? "") as String
        item.devicetype = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "devicetype") ?? "") as String
        item.Utype = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "Utype") ?? "") as String
        
        item.CurrentUserGuid = CEnumClass.share.parseValueFromkey(anyObj: dicts.value(forKey: "CurrentUserGuid") ?? "") as String
        
       
        return item
    }
}

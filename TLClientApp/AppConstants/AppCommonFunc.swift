//
//  AppCommonFunc.swift
//  TLClientApp
//
//  Created by Mac on 09/09/21.
//

import Foundation


class AppCommonFunc {
    func getCheckList(by companyID: String) -> [[String: String]] {
        let checkListArray = [
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"SCClearance","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"eSCClearance","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"CTCClearance","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"NPPV3Clearance","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"NRPSI","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"ITI","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"UK","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"CIOL","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"DiplomaPSI","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSpokL1","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSpokL2","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSpokL3","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSpokL4","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSpokL5","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSignL1","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSignL2","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSignL3","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSignL4","Value":"false"],
            ["Id":companyID,"SortOrder":"1","ExactValue":"0","Code":"espoSignL5","Value":"false"]
        ]
        return checkListArray
    }
}

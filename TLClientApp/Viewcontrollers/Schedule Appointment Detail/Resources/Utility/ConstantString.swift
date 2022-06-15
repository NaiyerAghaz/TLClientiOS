//
//  ConstantString.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 15/02/22.
//

import Foundation
enum ConstantStr {
    case noItnernet
    case editRecurrence
    case nodata
    case noRecordMsz
    case somethingwrong
    case msz
    var val:String {
        switch self {
        case .noItnernet:
            return "No internet connection!"
        case .editRecurrence:
            return "Are you sure that you want to edit the recurring pattern, If you do so you will lose the data for the existing appointments?"
        case .nodata:
            return "No records found"
        case .noRecordMsz:
            return "Please select another date"
        case .somethingwrong:
            return "Something went wrong please try again!"
        case .msz:
            return "Please enter your message"
        
        }
   
    
    
    }
    
}


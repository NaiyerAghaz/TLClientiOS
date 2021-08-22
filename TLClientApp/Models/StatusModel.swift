//
//  StatusModel.swift
//  TLClientApp
//
//  Created by Naiyer on 8/21/21.
//

import Foundation

struct ValidationResult {
    var error: String
    var success : Bool
}
struct responseResult {
    var message : String
    var data: Data
}
struct TxtRequest {
    var txt: String?
}

struct ValidationReq {
    func validate(txtfield:TxtRequest) -> ValidationResult {
        if txtfield.txt!.isEmpty {
            return ValidationResult(error: "Please fill Target Language", success: false)
        }
        else {
            return ValidationResult(error: "", success: true)
        }
        
    }
}

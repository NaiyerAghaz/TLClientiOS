//
//  ChatModels.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 06/06/22.
//

import Foundation
import UIKit


struct RowData {
    var rowType: RowType = .txt
    var sender : Int? = 0
    var cellIdentifier: chatDetailIndentifier = .txtCell
    var cellTypeIdx :CellType_Idx = .TextChatCell
    var txt :String? = ""
    var imgUrl : String? = ""
    var vdoUrl : String = ""
    var audioUrl : String = ""
    var name : String? = ""
    var time: String? = ""
   
}
enum RowType:Int {
   case txt = 0
    case img
    case audioP
    case vdo
    
}
enum chatDetailIndentifier : String {
    case txtCell =  "TextChatCell"
}
enum CellType_Idx : Int {
    case TextChatCell =  0
}

//Nib Name
struct NibNames {
    static let chat = "ChatTVCell"
}


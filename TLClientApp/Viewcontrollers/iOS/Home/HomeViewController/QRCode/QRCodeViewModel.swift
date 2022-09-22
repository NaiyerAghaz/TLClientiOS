//
//  HomeViewModel.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 14/09/22.
//

import Foundation
import UIKit
//QRCode Get Model and viewModel
class QRCodeViewModel {
func qrCodeGetMethod(handler: @escaping(QRCodeModel?,Error?) ->()){
    
WebServices.postJson(url: APi.getqrcode.url, jsonObject: qrCodeRequest(userID: userDefaults.string(forKey: "userId")!)) { response, err in
       
        guard let daata6 = cEnum.instance.jsonToData(json: response) else { return }
        do {
           // print("qrResponse--->",response)
            let jsonDecoder = JSONDecoder()
            let qrCodeModel = try jsonDecoder.decode(QRCodeModel.self, from: daata6)
            handler(qrCodeModel, nil)
            
        } catch{
            handler(nil, err as? Error)
            print("error block getCommonDetail " ,error)
        }
     
    } failureHandler: { resp, err in
        handler(nil, err as? Error)
        print(err)
    }
}
func qrCodeRequest(userID:String) -> [String:Any]{
    let para:[String:Any] = ["strSearchString":"<INFO><USERID>\(userID)</USERID><APPID>0</APPID></INFO>"]
  //  print("parr------>",para)
    return para
}
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
}
struct QRCodeModel:Codable{
    var QrUri: String?
    var Status: String?
    var QrUID: String?
    enum CodingKeys: String, CodingKey {
    case QrUri = "QrUri"
        case Status = "Status"
        case QrUID = "QrUID"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        QrUri = try values.decodeIfPresent(String.self, forKey: .QrUri)
        Status = try values.decodeIfPresent(String.self, forKey: .Status)
        QrUID = try values.decodeIfPresent(String.self, forKey: .QrUID)
    }
}

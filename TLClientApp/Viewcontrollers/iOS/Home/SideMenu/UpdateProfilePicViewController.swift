//
//  UpdateProfilePicViewController.swift
//  TLClientApp
//
//  Created by Mac on 08/11/21.
//

import UIKit
import Alamofire
class UpdateProfilePicViewController: UIViewController {

    @IBOutlet var userImg: UIImageView!
    var apiUploadImageOnlyResponse:ApiUploadImageOnlyResponse?
    var apiUploadImageDataResponse:ApiUploadImageDataResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.userImg.sd_setImage(with: URL(string: userImageURl), completed: nil)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func updateButton(_ sender: UIButton) {
        let imageToUpload = userImg.image ?? UIImage()
        uploadImageOnly(userImg: imageToUpload)
    }
    
    @IBAction func selectImg(_ sender: UIButton) {
        
        DispatchQueue.main.async {
                   CameraHandler.shared.showActionSheet(vc: self)
                   CameraHandler.shared.imagePickedBlock = { (image) in
                       /* get your image here */
                       self.userImg.image = image
                   }
               }
    }
    func uploadImageOnly(userImg : UIImage){
        
                SwiftLoader.show(animated: true)
                
                AF.upload(multipartFormData: { multipartFormData in
                    
                    if let imageData = userImg.jpegData(compressionQuality: 0.5) {
                        multipartFormData.append(imageData, withName: "files", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    }
                },
                to: APi.importImage.url, method: .post , headers: nil)
                .responseJSON(completionHandler: { (response) in
                    SwiftLoader.hide()
                    print(response)
            
//                    if let err = response.error{
//                        print(err)
//
//                        return
//                    }
                    
                    print("Succesfully uploaded")
                    
                    switch(response.result){
                    
                    case .success(_):
                        print("Respose Success ")
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiUploadImageOnlyResponse = try jsonDecoder.decode(ApiUploadImageOnlyResponse.self, from: daata)
                           print("Success")
                            let contentType = self.apiUploadImageOnlyResponse?.fileExtension ?? ""
                            let filename = self.apiUploadImageOnlyResponse?.tempFileName ?? ""
                            self.hitApiUploadImage(imageName: filename, contentType: contentType)
                            
                            
                        } catch{
                            
                            print("error block forgot password " ,error)
                        }
                    case .failure(_):
                        print("Respose Failure ")
                       
                    }
                    
            
                })
            }
    func hitApiUploadImage(imageName: String , contentType: String){
        SwiftLoader.show(animated: true)
    
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let companyId = userDefaults.string(forKey: "companyID") ?? ""
        
        let parameters = [
            "ImageId" : 0 ,
                  "UserName" : userId,
                  "ImageName" : imageName,
                 "ContentType" : contentType,
                  "UserType": "Customer",
                  
             ] as [String:Any]
        //print("url to get schedule \(urlString),\(parameters)")
                AF.request(APi.uploadImageData.url, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiUploadImageDataResponse = try jsonDecoder.decode(ApiUploadImageDataResponse.self, from: daata)
                                
                                if apiUploadImageDataResponse?.fileName ?? "" != "" {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            } catch{
                                self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                            self.view.makeToast("Please try after sometime.",duration: 2, position: .center)
                           
                        }
                })
     }
    
}

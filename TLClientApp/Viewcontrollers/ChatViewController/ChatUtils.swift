//
//  ChatUtils.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 06/06/22.
//

import Foundation
import UIKit
import Alamofire
import AVFoundation

extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }

            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)

            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)

                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }

            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }

            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}

extension Dictionary {
    
    /// Convert Dictionary to JSON string
    /// - Throws: exception if dictionary cannot be converted to JSON data or when data cannot be converted to UTF8 string
    /// - Returns: JSON string
    func toJson() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError(domain: "Dictionary", code: 1, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
}
class chatDetails: NSObject {
    static let share = chatDetails()
    func getchatString(filename: String, mszCount: Int) -> [AnyHashable: Any] {
        let pImage = ((userDefaults.string(forKey: "ImageData") != "" ) && (userDefaults.string(forKey: "ImageData") != nil)) ? (userDefaults.string(forKey: "ImageData")) : "/images/noprofile.jpg"
        let msz = "\(userDefaults.string(forKey: "firstName") ?? ""):#\(userDefaults.string(forKey: "firstName") ?? "")\(mszCount)##\(filename)#\(pImage!)#\(userDefaults.string(forKey: "twilioIdentity") ?? "")"
        let jsonObj:[AnyHashable:Any] = ["attributes": msz]
        return jsonObj
    }
    func getchatPrivateString(filename: String, mszCount: Int,replyID:String) -> String {
        let pImage = ((userDefaults.string(forKey: "ImageData") != "" ) && (userDefaults.string(forKey: "ImageData") != nil)) ? (userDefaults.string(forKey: "ImageData")) : "/images/noprofile.jpg"
        let msz = "#\(userDefaults.string(forKey: "firstName") ?? "")\(mszCount)#\(replyID)#\(filename)#\(pImage!)#\(userDefaults.string(forKey: "twilioIdentity") ?? "")"
       // let jsonObj:[AnyHashable:Any] = ["attributes": msz]
        return msz
    }
    
    func getchatTextReq(msz: String, mszCount: Int,replyID:String) -> String {
        let pImage = ((userDefaults.string(forKey: "ImageData") != "" ) && (userDefaults.string(forKey: "ImageData") != nil)) ? (userDefaults.string(forKey: "ImageData")) : "/images/noprofile.jpg"
        
        let msz = "#\(userDefaults.string(forKey: "firstName") ?? "")\(mszCount)#\(replyID)#\(msz)#\(pImage!)#\(userDefaults.string(forKey: "twilioIdentity") ?? "")"
       // let jsonObj:[AnyHashable:Any] = ["attributes": msz]
        return msz
    }
    func getUploadedFileExtension(file:String) -> Int {
        
        switch file {
        case "jpg":
            return 1
        case "png":
            return 1
        case "jpeg":
            return 1
        case "gif":
            return 1
        case "MOV":
            return 2
        case "mov":
            return 2
        case "mp4":
            return 2
        case "3gp":
            return 2
        case "flv":
            return 2
        case "avi":
            return 2
        case "wmv":
            return 2
        case "mp3":
            return 3
        case "wav":
            return 3
        case "aac":
            return 3
        case "amr":
            return 3
        case "ogg":
            return 3
        case "doc":
           return 4
        case "docx":
            return 4
        case "pdf":
            return 4
        case "xls":
            return 4
        case "xlsx":
            return 4
        case "ppt":
            return 4
        case "pptx":
            return 4
        case "txt":
            return 4
        case "zip":
            return 4
        default:
            return 0
        }
    }
    func getImageFromExt(file:String) -> UIImage {
       
        switch file {
        case "doc":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

            let largeBoldDoc = UIImage(systemName: "doc.text", withConfiguration: largeConfig)!.withTintColor(.blue)
            return largeBoldDoc
        case "docx":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

            let largeBoldDoc = UIImage(systemName: "doc.text", withConfiguration: largeConfig)?.withTintColor(.blue)
           
            return largeBoldDoc!
        case "pdf":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

            let largeBoldDoc = UIImage(systemName: "doc.fill", withConfiguration: largeConfig)!.withTintColor(.red)
            return largeBoldDoc
        case "xls":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

             let largeBoldDoc = UIImage(systemName: "doc.plaintext", withConfiguration: largeConfig)?.withTintColor(.green)
            return largeBoldDoc!
        case "xlsx":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

            let largeBoldDoc = UIImage(systemName: "doc.append", withConfiguration: largeConfig)?.withTintColor(.green)
            return largeBoldDoc!
        case "ppt":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

            let largeBoldDoc = UIImage(systemName: "doc.text.image.fill", withConfiguration: largeConfig)?.withTintColor(.green)
            return largeBoldDoc!
        case "pptx":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

             let largeBoldDoc = UIImage(systemName: "chart.bar.doc.horizontal.fill", withConfiguration: largeConfig)?.withTintColor(.green)
            return largeBoldDoc!
        case "txt":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

             let largeBoldDoc = UIImage(systemName: "doc.plaintext", withConfiguration: largeConfig)?.withTintColor(.darkGray)
            return largeBoldDoc!
        case "zip":
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

            let largeBoldDoc = UIImage(systemName: "doc.zipper", withConfiguration: largeConfig)?.withTintColor(.black)
            return largeBoldDoc!
        default:
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .large)

             let largeBoldDoc = UIImage(systemName: "doc.text", withConfiguration: largeConfig)!.withTintColor(.blue)
            return largeBoldDoc
        }
    }
    func getThumbnailFrom(path: URL) -> UIImage? {

            do {
                let asset = AVURLAsset(url: path , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let timestamp = asset.duration
                print("Timestemp:   \(timestamp)")
                let cgImage = try imgGenerator.copyCGImage(at: timestamp, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                print("thumb-->",thumbnail)
                return thumbnail
                } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
                return nil
              }
            }
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    func getImageFromName(fileName: String) -> UIImage?{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(fileName)
        
        if let imageData = try? Data(contentsOf: url) {
            let image = UIImage(data: imageData) // HERE IS YOUR IMAGE! Do what you want with it!
            return image
            
        } else {
            print("Couldn't get image for \(fileName)")
            return nil
            
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL, completion:@escaping(UIImage?, Bool?) ->()){
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, true)
                return
                
            }
          //  print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
//            DispatchQueue.main.async() { [weak self] in
//                self?.imageView.image = UIImage(data: data)
//            }
            completion(UIImage(data: data), false)
           
        }
       
    }
    func saveImageLocally(image: UIImage, fileName: String) {
        
     // Obtaining the Location of the Documents Directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Creating a URL to the name of your file
        let url = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 1) {
            do {
                try data.write(to: url) // Writing an Image in the Documents Directory
            } catch {
                print("Unable to Write \(fileName) Image Data to Disk")
            }
        }
    }
     func createVideoThumbnail(fileName:String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(fileName)
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: 400, height: 400)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }

    }
}

   


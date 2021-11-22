//
//  DocumentTranslationViewController.swift
//  TLClientApp
//
//  Created by Mac on 27/10/21.
//

import UIKit
import  MobileCoreServices
import Alamofire
import DropDown
class DocumentTranslationViewController: UIViewController, UIDocumentPickerDelegate {
    @IBOutlet var companyNameLbl: UILabel!
    @IBOutlet var contactNameLbl: UIView!
    @IBOutlet var clientInitialsTF: UITextField!
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var authCodeLbl: UILabel!
    @IBOutlet var studentNameTF: UITextField!
    @IBOutlet var clientRefrenceTF: UITextField!
    @IBOutlet var dueDateTF: UITextField!
    var apiGetAllLanguageResponse : ApiGetAllLanguageResponse?
    var dropDown = DropDown()
    var languageDataSource:[String] = []
    let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
    override func viewDidLoad() {
        super.viewDidLoad()
         updateUI()
        getAllLanguage()
        
    }
    
    @IBAction func selecttargetLanguage(_ sender: UIButton) {
        dropDown.anchorView = sender //5
                dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
                //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
                dropDown.backgroundColor = UIColor.white
                dropDown.layer.cornerRadius = 20
                dropDown.clipsToBounds = true
                dropDown.show() //7
                dropDown.dataSource = languageDataSource
              dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
                     sender.setTitle(item, for: .normal)
              }
    }
    @IBAction func selectSourceLanguage(_ sender: UIButton) {
        dropDown.anchorView = sender //5
                dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
                //dropDown.textFont = UIFont(name: "ProximaNova-Regular", size: 14.0)!
                dropDown.backgroundColor = UIColor.white
                dropDown.layer.cornerRadius = 20
                dropDown.clipsToBounds = true
                dropDown.show() //7
                dropDown.dataSource = languageDataSource
                dropDown.selectionAction = { [weak self] (indselectedDataex: Int, item: String) in //8
                     sender.setTitle(item, for: .normal)
           }
    }
    @IBAction func actionChoosePDf(_ sender: UIButton) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    @IBAction func actionOpenCalender(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date", cancelText: "Cancel", didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.dueDateTF.text = selectedDate.dateString("MM/dd/YYYY")
                             let selectedDate = selectedDate.dateString("MM/dd/YYYY")
                           print("selected date :\(selectedDate)")
                    })
    }
    @IBAction func actionSubmit(_ sender: UIButton) {
    }
    @IBAction func actionBackbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func updateUI(){
        
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
              print(urls)
    }
    func getAllLanguage(){
        SwiftLoader.show(animated: true)
             
       
        let urlString = "https://lsp.totallanguage.com/Security/GetData?methodType=LanguageData"
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetAllLanguageResponse = try jsonDecoder.decode(ApiGetAllLanguageResponse.self, from: daata)
                               print("Success")
                                self.apiGetAllLanguageResponse?.languageData?.forEach({ languageData in
                                    let languageString = languageData.languageName ?? ""
                                    languageDataSource.append(languageString)
                                })
                                
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                })
     }
}


extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

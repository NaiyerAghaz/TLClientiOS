//
//  SideMenuViewController.swift
//  TLClientApp
//
//  Created by Mac on 13/10/21.
//

import UIKit
import  SideMenu
import Alamofire
import SDWebImage
var isLogoutPressed = false
class sideMenuTableViewCell :UITableViewCell{
    
    @IBOutlet var downOptionView: UIView!
    @IBOutlet var downArrowBtn: UIButton!
    @IBOutlet var downArrowImg: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    override func awakeFromNib() {
        self.downOptionView.visibility = .gone
    }
}
class SideMenuViewController: UIViewController {
    var delegateScanner: delegateScanner?
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var sideMenuTv: UITableView!
    var openSection = 0
    var  isRow1Open = false
    var isRow4open = false
   
    var apiGetProfileResponseModel:ApiGetProfileResponseModel?
//open var leftMenuNavigationController: SideMenuNavigationController?
   //let titleSectionArr = ["Dash Board","Controls","VPI and OPI Logs","Support" , "userName"]
    // let titleArr = [[""],["Customer Details", "Venues"],[""],[""],["Logout"]]
    let titleSectionArr = ["Dashboard","Controls", "userName"]
    let titleArr = [[""],["Customer Details", "Venues"],["Logout"]]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Do any additional setup after loading the view.
        sideMenuTv.delegate = self
        sideMenuTv.dataSource = self
       
        let firstName = userDefaults.string(forKey: "firstName") ?? ""
               let lastName = userDefaults.string(forKey: "lastName") ?? ""
               let userName   = "\(String(describing: firstName)) \(lastName)"
               
               self.userNameLbl.text = userName
        self.userImg.layer.cornerRadius = self.userImg.bounds.height / 2 
        getProfileimg()
        //leftMenuNavigationController?.menuWidth = 350
    }
    
    @IBAction func uploadProfileImg(_ sender: UIButton) {
        let dict :[String:String] = ["val": "1"]
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("UpdateProfilePic"), object: nil, userInfo: dict)
        
    }
    @IBAction func btnScanTapped(_ sender: Any) {
        let dict :[String:String] = ["val": "2"]
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("UpdateProfilePic"), object: nil, userInfo: dict)
    }
    
    @IBAction func actionBackButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
   
    
    func getProfileimg(){
        if Reachability.isConnectedToNetwork() {
        SwiftLoader.show(animated: true)
              
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let urlPrefix = "userid=\(userId)"
        let urlString = "\(APi.getProfileImg.url)" + urlPrefix
        print("url to get image is \(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success ")
                            guard let daata80 = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetProfileResponseModel = try jsonDecoder.decode(ApiGetProfileResponseModel.self, from: daata80)
                                let postUrl = self.apiGetProfileResponseModel?.uSERLOGOS?.first?.imageData ?? ""
                                let imgUrl = nBaseUrl + postUrl
                              
                                self.userImg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "person.circle"))
                             
                                 userImageURl = imgUrl
                            } catch{
                                
                                print("error block forgot password " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                    })}
        else {
            self.view.makeToast(ConstantStr.noItnernet.val)
        }
     }
}
extension SideMenuViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleSectionArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == openSection {
            if section == 1 {
                if isRow1Open {
                    return titleArr[section].count
                }else {
                    return 0
                }
            }else if section == 2 {
                if isRow4open {
                    return titleArr[section].count
                }else {
                    return 0
                }
            }
            else {
                return 0 
            }
            
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = storyboard?.instantiateViewController(identifier: "CustomerDetailsViewController") as! CustomerDetailsViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                let vc = storyboard?.instantiateViewController(identifier: "VenueListViewController") as! VenueListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                userDefaults.removeObject(forKey: "isDeclineTimeZone")
                isLogoutPressed = true
                let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to Logout?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
               self.dismiss(animated: false, completion: nil)
               NotificationCenter.default.post(name: Notification.Name("LogoutFunction"), object: nil, userInfo: nil)
                               }))

                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
                  }))

                present(refreshAlert, animated: true, completion: nil)            }else {
                
            }
            
        }else {
            
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
                returnedView.backgroundColor = .clear
              let tap = UITapGestureRecognizer(target: self, action:#selector(self.sectionTap(_:)))
               returnedView.addGestureRecognizer(tap)
                returnedView.tag = section
        print("view for section ",view.frame.size.width)
        let image = UIImageView(frame: CGRect(x: view.frame.size.width - 30, y: 20, width: 20, height: 20))
        image.image = UIImage(named: "ic_downarrow")
        
             let label = UILabel(frame: CGRect(x: 20, y: 20, width: view.frame.size.width - 60, height:25))
        let firstName = userDefaults.string(forKey: "firstName") ?? ""
                let lastName = userDefaults.string(forKey: "lastName") ?? ""
                let username   = "\(String(describing: firstName)) \(lastName)"
                    if section == 2 {
                          label.text =  username
                        label.adjustsFontSizeToFitWidth = true
                     }
                else {
                           label.text =  self.titleSectionArr[section]
                     }
                       label.textColor = .white
                 label.font =  UIFont.boldSystemFont(ofSize: 22.0)
               let label2 = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.size.width, height:1))
               label2.backgroundColor = .white
                 returnedView.addSubview(label)
               returnedView.addSubview(label2)
        
            if section == 1 || section == 2 {
                      returnedView.addSubview(image)
            }
              

                 return returnedView
        //return UIView()
    }
   
    @objc func sectionTap(_ sender: UITapGestureRecognizer) {
            
            let newSection = sender.view!.tag
              print("newsection \(newSection)")
            self.openSection = newSection
        if newSection == 1 {
            print("ControlR")
            self.isRow1Open = !self.isRow1Open
        }else if newSection == 2{
            print("userName")
            self.isRow4open = !self.isRow4open
        }
       /* else if newSection == 3 {
            print("Support option" )
            let vc = storyboard?.instantiateViewController(identifier: "SupportViewController") as! SupportViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if newSection == 2 {
            print("Vri opi call log history")
            let vc = storyboard?.instantiateViewController(identifier: "VRIAndOPILogsViewController") as! VRIAndOPILogsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        else if newSection == 0 {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.isRow1Open = false
            self.isRow4open = false
        }
        sideMenuTv.reloadData()
            
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            return 50
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuTableViewCell") as! sideMenuTableViewCell
        cell.titleLbl.text = titleArr[indexPath.section][indexPath.row]
        if indexPath.row == 1 || indexPath.row == 2 {
            cell.downArrowImg.isHidden = true
        }else{
            cell.downArrowImg.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2 {
            return UITableView.automaticDimension
        }else {
            return 0
        }
    }
}

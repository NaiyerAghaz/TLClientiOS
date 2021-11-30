//
//  MeetingViewController.swift
//  TLClientApp
//
//  Created by SMIT 005 on 29/11/21.
//

import UIKit
import XLPagerTabStrip
class AddparticipentstableViewCell:UITableViewCell {
    
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
}
class MeetingViewController: UIViewController , IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Meeting")
    }
    static func createWith(navigator: Navigator, storyboard: UIStoryboard) -> MeetingViewController {
        return storyboard.instantiateViewController(ofType: MeetingViewController.self).then { viewController in
            
        }
    }

    @IBOutlet weak var inviteParticipantTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inviteParticipantTV.delegate = self
        self.inviteParticipantTV.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addParticipents(_ sender: UIButton) {
    }
    

}
//MARK: - Table Work
extension MeetingViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddparticipentstableViewCell", for: indexPath) as! AddparticipentstableViewCell
        return cell
    }
    
    
}

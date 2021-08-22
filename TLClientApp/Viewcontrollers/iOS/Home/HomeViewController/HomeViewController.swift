//
//  HomeViewController.swift
//  TLClientApp
//
//  Created by Naiyer on 8/14/21.
//

import UIKit
import FSCalendar


class HomeViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource {

    @IBOutlet weak var tblCalenderView: UITableView!
    var navigator = Navigator()
    var loginVM = DetailsModal()
    static func createWith(navigator: Navigator, storyboard: UIStoryboard,userModel: DetailsModal) -> HomeViewController {
        return storyboard.instantiateViewController(ofType: HomeViewController.self).then { viewController in
            viewController.loginVM = userModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnTapped(_ sender: UIButton){
        if sender.tag == 3 {
            //navigator.show(segue: .vRIOPI, sender: self)
//            let pager = navigator.homeStoryBoard.instantiateViewController(identifier: "VRIOPIViewController") as! VRIOPIViewController
//            self.navigationController?.pushViewController(pager, animated: true)
            
            if !(self.navigationController?.topViewController is VRIOPIViewController) {
                print("MainSegue LoginViewController")
                self.performSegue(withIdentifier: "vriopiSeque", sender: nil)
            }
            
        }
        
    }
    private func updateUI(){
        tblCalenderView.register(UINib(nibName: nibNamed.calendarTVCell, bundle: nil), forCellReuseIdentifier: HomeCellIdentifier.calendarTVCell.rawValue)
        tblCalenderView.delegate = self
        tblCalenderView.dataSource = self
        tblCalenderView.reloadData()
    }
    
}
extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifier.calendarTVCell.rawValue, for: indexPath) as! CalendarTVCell
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 240
    }
}

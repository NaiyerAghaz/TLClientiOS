//
//  InitialLoginVC.swift
//  TLClientApp
//
//  Created by Naiyer on 8/7/21.
//

import UIKit

class InitialLoginVC: UIViewController {
    var navigator = Navigator()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.navigator.show(segue:.login, sender: self)
    }

}

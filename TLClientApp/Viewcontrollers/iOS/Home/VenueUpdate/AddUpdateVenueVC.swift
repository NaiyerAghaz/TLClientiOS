//
//  AddUpdateVenueVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 21/03/22.
//

import UIKit

class AddUpdateVenueVC: UIViewController {

    @IBOutlet weak var updateVenueView: UIView!
    @IBOutlet weak var addvenueView: UIView!
    @IBOutlet weak var updateVenueLbl: UILabel!
    @IBOutlet weak var addVenueLbl: UILabel!
    @IBOutlet weak var updateVenueContainer: UIView!
    @IBOutlet weak var addvenueContainer: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addvenueContainer.alpha = 1
        self.updateVenueContainer.alpha = 0
        
        
        self.addvenueView.backgroundColor = UIColor(hexString: "33A5ff")
        self.addVenueLbl.textColor = UIColor.white
        
        self.updateVenueView.backgroundColor = UIColor.white
        self.updateVenueLbl.textColor = UIColor(hexString: "33A5ff")
        self.addvenueView.layer.borderColor = UIColor(hexString: "33A5ff").cgColor
        self.addvenueView.layer.borderWidth = 1
        self.updateVenueView.layer.borderColor = UIColor(hexString: "33A5ff").cgColor
        self.updateVenueView.layer.borderWidth = 1
       
        
    }
    
    @IBAction func actionAddvenue(_ sender: UIButton) {
        self.addvenueContainer.alpha = 1
        self.updateVenueContainer.alpha = 0
        
        self.addvenueView.backgroundColor = UIColor(hexString: "33A5ff")
        self.updateVenueView.backgroundColor = UIColor.white
        self.updateVenueLbl.textColor = UIColor(hexString: "33A5ff")
        self.addVenueLbl.textColor = UIColor.white
        
    }
    @IBAction func actionUpdatevenue(_ sender: UIButton) {
        self.addvenueContainer.alpha = 0
        self.updateVenueContainer.alpha = 1
        
        self.addvenueView.backgroundColor = UIColor.white
        self.updateVenueView.backgroundColor = UIColor(hexString: "33A5ff")
        self.updateVenueLbl.textColor = UIColor.white
        self.addVenueLbl.textColor = UIColor(hexString: "33A5ff")
        
    }
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

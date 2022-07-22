//
//  AppoinmentTVCells.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 19/07/22.
//

import Foundation
import UIKit
class ScheduleAppointmentTableViewCell:UITableViewCell{
    
    @IBOutlet weak var jobTypeText: UILabel!
    @IBOutlet weak var lblTextVenue: UILabel!
    @IBOutlet weak var cancelMessageStack: UIStackView!
    @IBOutlet weak var appointmentTitleLbl: UILabel!
    @IBOutlet var statusOuterView: UIView!
    @IBOutlet var checkOutOuterView: UIView!
    @IBOutlet var startDateLbl: UILabel!
    @IBOutlet var customerName: UILabel!
    @IBOutlet var checkInLbl: UILabel!
    @IBOutlet weak var CustomerNameStack: UIStackView!
    @IBOutlet weak var clientValueStack: UIStackView!
    @IBOutlet var statusOfAppointmentLbl: UILabel!
    @IBOutlet weak var customerValueStack: UIStackView!
    @IBOutlet weak var clientnameStack: UIStackView!
    @IBOutlet var outerView: UIView!
    @IBOutlet var interpreterLbl: UILabel!
    @IBOutlet var typeOfMeetLbl: UILabel!
    @IBOutlet var venuLbl: UILabel!
    @IBOutlet var checkOutHeadingLbl: UILabel!
    @IBOutlet var clientNameLbl: UILabel!
    @IBOutlet var targetLanguageLbl: UILabel!
    @IBOutlet var sourceLanguageLbl: UILabel!
    @IBOutlet var appointmentTimeLbl: UILabel!
    @IBOutlet var appointmentIDLbl: UILabel!
    @IBOutlet var btnVideoAndAudioCall : UIButton!
    @IBOutlet weak var btnCallHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblCallWarning: UILabel!
    @IBOutlet weak var btnVideoAndAudioWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        outerView.addShadowGrey()
        self.customerValueStack.isHidden = false
        self.CustomerNameStack.isHidden = false
        self.clientnameStack.isHidden = false
        self.clientValueStack.isHidden = false
        self.cancelMessageStack.isHidden = true
    }
}
class ScheduleMeetingTableViewCell:UITableViewCell{
    
    //   @IBOutlet weak var appointmentTitleLbl: UILabel!
    @IBOutlet var statusOuterView: UIView!
    
    @IBOutlet var startDateLbl: UILabel!
    
    @IBOutlet var checkInLbl: UILabel!
    @IBOutlet var statusOfAppointmentLbl: UILabel!
    @IBOutlet var outerView: UIView!
    @IBOutlet var interpreterLbl: UILabel!
    @IBOutlet weak var joinMeetBtn: UIButton!
    @IBOutlet weak var documentTranslationView: UIView!
    @IBOutlet var appointmentTimeLbl: UILabel!
    @IBOutlet var appointmentIDLbl: UILabel!
    override func awakeFromNib() {
        outerView.addShadowGrey()
    }
}

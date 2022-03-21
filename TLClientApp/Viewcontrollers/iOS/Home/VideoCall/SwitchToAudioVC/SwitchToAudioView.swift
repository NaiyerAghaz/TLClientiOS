//
//  SwitchToAudioView.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 16/03/22.
//

import UIKit
import Malert
import Foundation

class SwitchToAudioView: UIView {

   @IBOutlet weak var lblSTLang: UILabel!
    var stLang : String?
    override func awakeFromNib() {
        super.awakeFromNib()
    applyLayout()
    }
    func applyLayout(){
        lblSTLang.text = stLang
    }
    class func instantiateFromNib() -> SwitchToAudioView {
        return Bundle.main.loadNibNamed("SwitchToAudioView", owner: nil, options: nil)!.first as! SwitchToAudioView
    }
}

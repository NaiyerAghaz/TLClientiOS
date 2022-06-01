//
//  DraggedView.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 21/03/22.
//

import Foundation
import UIKit

extension VideoCallViewController{
   
  
    func getPreview(){
        lblParticipantSearching.bounds = CGRect(x: 40, y: 100, width: self.view.frame.size.width - 8, height: 40)
        lblParticipantSearching.textAlignment = .center
        lblParticipantSearching.numberOfLines = 0
        
        lblParticipantSearching.font = UIFont.systemFont(ofSize: 18)
        lblParticipantSearching.text = "Particiapnt searching..."
        lblParticipantSearching.backgroundColor = .red
        self.view.bringSubviewToFront(lblParticipantSearching)
        
    }
  
   
}

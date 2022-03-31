//
//  DraggedView.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 21/03/22.
//

import Foundation
import UIKit

extension VideoCallViewController{
   
   /* public func draggedView()
    {
        draggedPreview.frame = CGRect(x: 0, y: self.view.bounds.height - 40, width: 100, height: 120)
        draggedPreview.backgroundColor = .red
        draggedPreview.layer.cornerRadius = 10
        draggedPreview.translatesAutoresizingMaskIntoConstraints = false
        draggedPreview.contentMode = .scaleAspectFit
        draggedPreview.clipsToBounds = true
        imageView.frame.size.width = draggedPreview.frame.size.width
        imageView.frame.size.height = draggedPreview.frame.size.height
        
       // imageView.image = UIImage(named: "privacyIcon")
       // imageView.contentMode = .scaleAspectFit
       // newView.addSubview(imageView)
       
        
        self.view.bringSubviewToFront(draggedPreview)
        draggedPreview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        draggedPreview.topAnchor.constraint(equalTo: view.topAnchor, constant: 40 ).isActive = true
        draggedPreview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        draggedPreview.heightAnchor.constraint(equalTo: draggedPreview.widthAnchor, multiplier: 1).isActive = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
        draggedPreview.isUserInteractionEnabled = true
        draggedPreview.addGestureRecognizer(panGesture)
    }*/
//    @objc func panGestureHandler(_ recognizer: UIPanGestureRecognizer){
//        self.view.bringSubviewToFront(localPreview)
//        let translation = recognizer.translation(in: self.view)
//        localPreview.center = CGPoint(x: localPreview.center.x + translation.x, y: localPreview.center.y + translation.y)
//        print("xAXIS--->",localPreview.center.x + translation.x, "Yaxis------->", localPreview.center.y + translation.y)
//        recognizer.setTranslation(CGPoint.zero, in: self.view)
//    }
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

//
//  ImagePopupViewController.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 24/06/22.
//

import UIKit
import WebKit

class ImagePopupViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var popupWebView: WKWebView!
    var isImage = false
    var fileName: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        if isImage {
            imgView.isHidden = false
            popupWebView.isHidden = true
            imgView.image = chatDetails.share.getImageFromName(fileName: fileName ?? "")
        }
        else {
            imgView.isHidden = true
            popupWebView.isHidden = false
            configUI()
        }
        // Do any additional setup after loading the view.
    }
    func configUI(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let vurl = documentsDirectory.appendingPathComponent(fileName!)
        DispatchQueue.main.async {
            
           // let url = URL(string: self.serviceURL)!
            var urlReq = URLRequest(url: vurl)
            urlReq.cachePolicy = .returnCacheDataElseLoad
            self.popupWebView.load(urlReq)
        }
      }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
       dismiss(animated: true, completion: nil)
        
    }
    //MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("DID FINISH DELEGATE")
        SwiftLoader.hide()
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SwiftLoader.show(animated: true)
          
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            SwiftLoader.hide()
           
            self.view.makeToast("Unable to load document")
        }

        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print(#function)
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print(#function)
        }
 }

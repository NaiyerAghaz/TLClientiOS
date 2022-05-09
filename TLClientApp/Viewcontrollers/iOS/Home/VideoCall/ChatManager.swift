//
//  ChatManager.swift
//  TLClientApp
//
//  Created by Naiyer on 10/21/21.
//

import Foundation
import TwilioChatClient
import UIKit
class ChatManager: NSObject, TwilioChatClientDelegate {
    static let share  = ChatManager()
    var client : TwilioChatClient?
    func loginWithIdentityChat(indentityName: String, handler:@escaping(Bool?, Error?) -> ()){
        if (self.client != nil) {
           //logout will add here token will be unregister
        }
        tokenForIdentity(indentity: indentityName) { success, chatModel in
            if success! {
                handler(true, nil)
            }
            else {
                handler(false, nil)
            }
            }
    }
    func tokenForIdentity(indentity: String,handler:@escaping(Bool?, TwilioChatModel?) ->()){
        let deviceid = UIDevice.current.identifierForVendor!.uuidString
        let fullUrl = chatURL + "/chattoken??device=\(deviceid)"
        WebServices.get(url: URL(string: fullUrl)!) { (response, _) in
            print("url:\( fullUrl) response:\(response)")
            let twilioData = TwilioChatModel.getData(dicts: response as! NSDictionary)
            print("TWILIO DATA IS \(twilioData.token)")
            TwilioChatClient.chatClient(withToken: twilioData.token!, properties: nil, delegate: self) { result, chatClient in
                self.client = chatClient

                print("chatClient---:", chatClient)
                handler(true, twilioData)
              //  self.updateChatClient()
            }

            SwiftLoader.hide()
        } failureHandler: { (error, _) in
            print("Failure block in chatClient \(error)")
            handler(false,nil)
            SwiftLoader.hide()
        }
        
    }
    func updateChatClient(){
        if (self.client != nil) && (client?.synchronizationStatus == TCHClientSynchronizationStatus.completed || client?.synchronizationStatus == TCHClientSynchronizationStatus.channelsListCompleted) {
            
        }
    }
}

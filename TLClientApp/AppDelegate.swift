//
//  AppDelegate.swift
//  TLClientApp
//
//  Created by Naiyer on 8/6/21.
//

import UIKit
import CoreData
import IQKeyboardManager
import FirebaseMessaging
import UserNotifications
import Messages
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    var inHouseValue, inBoostlingoValue, isBoostlingoAccess: String?
    var slangNameAppdel, slangIDAppdel, tlangIDAppdel, tlangNameAppdel, tokenAppdel, initalCallType, roomIDAppdel, callTypeAppdel, patientnameAppdel, patientnoAppdel, myIDAppdel: String?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerNotification(app: application)
        
        let userId = userDefaults.string(forKey: "userId") ?? ""
        if userId != "" {
            let storyboard : UIStoryboard = UIStoryboard(name:Storyboard_name.home, bundle: nil)
//                        let navigationController : UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "TestNav") as! TestNav
//                        navigationController.viewControllers = [rootViewController]
                                           //self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = rootViewController
                        self.window?.makeKeyAndVisible()
        }else {
            let storyboard : UIStoryboard = UIStoryboard(name:Storyboard_name.login, bundle: nil)
                        let navigationController : UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "InitialLoginVC") as! InitialLoginVC
                        navigationController.viewControllers = [rootViewController]
                                           //self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()
        }
        
        
        
        
        
        if #available(iOS 13.0, *) {
                         window?.overrideUserInterfaceStyle = .light
                         UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle = .light
        }
        
        let center = UNUserNotificationCenter.current()
                 center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                     // Enable or disable features based on Screen Time authorization.
                 }
                 application.registerForRemoteNotifications()
             
             if #available(iOS 10.0, *) {
               // For iOS 10 display notification (sent via APNS)
               UNUserNotificationCenter.current().delegate = self

               let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
               UNUserNotificationCenter.current().requestAuthorization(
                 options: authOptions,
                 completionHandler: { _, _ in }
               )
             } else {
               let settings: UIUserNotificationSettings =
                 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
               application.registerUserNotificationSettings(settings)
             }
             if #available(iOS 13.0, *) {
                         window?.overrideUserInterfaceStyle = .light
                         UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle = .light
                     }
             
             if #available(iOS 13.0, *) {
                      window?.overrideUserInterfaceStyle = .light
                      UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle = .light
                  }
        
        
        return true
    }

   
    // MARK: UISceneSession Lifecycle
/*
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }*/

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TLClientApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // Register for FCM notification
    
    public func registerNotification(app: UIApplication){
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            app.registerUserNotificationSettings(settings)
        }

        app.registerForRemoteNotifications()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().token { token, error in
            print("check FCM TOken ")
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          //  let fcmToken = Data("\(token)".utf8)
            userDefaults.setValue(token, forKey: "fcmToken")
            //keychainServices.save(key: "fcmtoken", data: fcmToken)
          }
        }
        //or
        /*
         let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
         print("dtoken=", deviceTokenString)
     Messaging.messaging().apnsToken = deviceToken**/
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("userInfo-------------------->",userInfo.values, "Info:", userInfo )
        handleNotification(userInfo: userInfo)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("will not generate in simulator", error.localizedDescription)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        print("new notification ",userInfo.values)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("userNotificationCenter",completionHandler)
    }
    func handleNotification(userInfo:[AnyHashable:Any]){
        let type =  userInfo[AnyHashable("type")] as? String
        let payload = userInfo[AnyHashable("payload")] as? String
        
        if type != nil {
           // let dict = convertToDictionary(text: payload!)
            if type == TypeNotification.notavailable.rawValue {
                print("mytype--->", type)
                if let roomNo = userInfo[AnyHashable("gcm.notification.Roomno")]  as? String {
                    print("roommmm---->",roomNo)
                    if roomNo == roomIDAppdel {
                        
                    }
                }
                
                // CommonMethods.playSounds(audioName: "cyanping")
               // let timeDisDict = NotificationsTimeForDistance(dictionary: dict!)
                // let assignedJob = ApiJobListIncomming.JobAssignedDetail(dictionary: dict! as NSDictionary)
                
               /* if timeDisDict.valjob == 1 {
                    //   NotificationCenter.default.post(name: Notification.Name("notificationRegularJob"), object: nil)
                    /* vc.isValidateStatus = true
                     vc.jobAssignDic = jobAcceptData */
                    CommonMethods.playSounds(audioName: "notification_driver")
                    
                    if let rootViewController = self.window!.rootViewController as? UINavigationController {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        if let vc = storyboard.instantiateViewController(withIdentifier: "RegularJobViewController") as? RegularJobViewController {
                            let assignedJob = ApiJobListIncomming.JobAssignedDetail(dictionary: dict! as NSDictionary)
                            print("assignedJob!!=",assignedJob)
                            vc.jobAssignDriverDict = assignedJob
                            vc.isFromNotification = true
                            vc.jobId = assignedJob.id
                            rootViewController.pushViewController(vc, animated: true)
                        }
                    }
                }*/
            
            
            }else if type == "opicall" {
                
                print("opi call Start")
                
                NotificationCenter.default.post(name: Notification.Name("vendorAnswered"), object: nil, userInfo: nil)
                
            }else if type?.contains("ParticipantLeave") ?? false {
                print("participants leave notify ")
                let participantsValue = type?.components(separatedBy: ",")
                if (participantsValue?.count ?? 0 ) > 0 {
                    let participantsStr = participantsValue?[0]
                    let conferenceSID = participantsValue?[1] ?? ""
                    let objConferenceSID:[String:String] = ["conferenceSID":conferenceSID]
                    if participantsStr == "ParticipantLeave" {
                        NotificationCenter.default.post(name: Notification.Name("removeParticipants"), object: nil, userInfo: objConferenceSID)
                    }
                }
                
                
            }else if type == "tokenupdate" {
                if isLogoutPressed {
                    //isLogoutPressed = false
                }else {
                    self.window?.makeToast("This customer already logged-in on another device")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        let storyboard:UIStoryboard = UIStoryboard(name: Storyboard_name.login, bundle: nil)
                        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "InitialLoginVC") as! InitialLoginVC
                        navigationController.viewControllers = [rootViewController]
                        appDelegate.window!.rootViewController = navigationController
                        appDelegate.window!.makeKeyAndVisible()
                    }
                }
                
            }
        }
    }
   
}

